X5057_1 <- read.csv("/cloud/project/Thesis data/Spring nights/X5057_1.csv")
X5057_1$timestamp <- ymd_hms(X5057_1$timestamp)
int <- interval(min(X5057_1$timestamp), max(X5057_1$timestamp))
time_length(int, unit = "mins")

library(conicfit)
X5057_1_re <- X5057_1 %>% dplyr::select(ID=batIDday, time=timestamp, x=utm.x, y=utm.y)

##fitting crwPredict
crwOut <- crawlWrap(obsData= X5057_1_re, 
                      Time.name="time", 
                      timeStep="30 secs",
                      retryFits = 5) 
plot(crwOut,ask=FALSE)
X5057_1_processed <- prepData(crwOut, type= c("UTM"), coordNames = c("x", "y"))

plot(X5057_1_processed)
par(mfrow=c(2,1))
hist(X5057_1_processed$step)
hist(X5057_1_processed$angle)

stateNames <- c("extensive search", "forage", "commute") # initial parameters
stepParMean <- c(1, 15, 30)
stepParSD <- c(10, 5, 1)
stepPar0 <- c(stepParMean, stepParSD)
anglePar0 <-c(2, 1, 0.1)


dist = list(step = "gamma", angle = "vm")

m <- momentuHMM::fitHMM(data=X5057_1_processed,
                        nbStates=3,
                        dist=dist,
                        Par0=list(step=stepPar0, angle=anglePar0),
                        stateNames = stateNames)
m
plot(m)
