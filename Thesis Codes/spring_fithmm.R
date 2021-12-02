##Creating bat days from spring captures
noctules <- read.csv("/cloud/project/Thesis data/spring.csv")
library(tidyverse)
library(lubridate)
noctules$timestamp <- ymd_hms(noctules$timestamp)
noctules_m <- move(x = noctules$location.long,
                   y = noctules$location.lat,
                   time = noctules$timestamp,
                   data = noctules,
                   proj = CRS("+proj=longlat +ellps=WGS84"),
                   animal = noctules$individual.local.identifier)
#str(noctules_m)
plot(noctules_m)

noctules_m$tlag <- unlist(lapply(timeLag(noctules_m, units="secs"), c, NA))
noctules_m$batID <- noctules_m@trackId

#Add in Bat Day
moveList2 <- lapply(split(noctules_m), function(myInd){
  datechange <- c(0, abs(diff(as.numeric(as.factor(date(myInd@timestamps-(12*60*60)))))))
  myInd$BatDay <- cumsum(datechange)+1
  return(myInd)
})
noctules_m <- moveStack(moveList2, forceTz="UTC")

#Add in the UTM XY locations, just in case they are needed
noctules_m <- spTransform(noctules_m, CRS("+proj=utm +zone=30 +datum=WGS84"))
crds <- as.data.frame(noctules_m@coords)
noctules_m$utm.x <- crds$coords.x1 
noctules_m$utm.y <- crds$coords.x2 
noctules_m <- spTransform(noctules_m, CRS("+proj=longlat +datum=WGS84")) #convert back to longlat
noctules_m$batIDday <- paste0(noctules_m$batID, ".", noctules_m$BatDay)

nocday <- as.data.frame(noctules_m@data)

nocday$timestamp <- as.POSIXct(nocday$timestamp, tz = "UTC")


nocday_L <- split(nocday, f=nocday$batIDday)


##Creating data frames for individual bat days
a <- as.data.frame(nocday_L$X60F1.2)
write.csv(X60F1_2, file = "C:\\Users\\12093\\Documents\\Bat data\\Batday_dataframes\\X60F1_2.csv")
##switching between individuals
a <- CECB_2
int <- interval(min(a$timestamp), max(a$timestamp))
time_length(int, unit = "mins")

#check the interval of how long each bat was tracked per night
lapply(nocday_L, function(x){
  time_length(interval(min(x$timestamp), max(x$timestamp)), unit="mins")}) 

library(conicfit)
a_re <- a %>% dplyr::select(ID=batIDday, time=timestamp, x=utm.x, y=utm.y)

##fitting crwPredict
crwOut_2 <- crawlWrap(obsData= a_re, 
                      Time.name="time", 
                      timeStep="30 secs",
                      retryFits = 5) 
plot(crwOut_2,ask=FALSE)
a_processed <- prepData(crwOut_2, type= c("UTM"), coordNames = c("x", "y"))

plot(a_processed)
par(mfrow=c(2,1))
hist(a_processed$step)
hist(a_processed$angle)

## inital fit model parameters
whichzero <-which(a_processed$step == 0.1) 
whichzero
stateNames <- c("extensive search", "forage", "commute") # initial parameters
stepParMean <- c(1, 75, 105)
stepParSD <- c(5, 25, 10)
stepPar0 <- c(stepParMean, stepParSD)
anglePar0 <-c(2, 1, 0.01)

kappa0 <- c(0.8, 1) # angle concentration
anglePar0 <- kappa0

dist = list(step = "gamma", angle = "vm")

m <- momentuHMM::fitHMM(data=a_processed,
                        nbStates=3,
                        dist=dist,
                        Par0=list(step=stepPar0, angle=anglePar0),
                        stateNames = stateNames)
m
plot(m)
