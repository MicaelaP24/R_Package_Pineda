library(move)
library(momentuHMM)
library(tidyverse)
CECB_2 <- read.csv("/cloud/project/Thesis data/Spring nights/CECB_2.csv")
CECB_2$timestamp <- ymd_hms(CECB_2$timestamp)



#check the interval of how long the bat was tracked per night

int <- interval(min(CECB_2$timestamp), max(CECB_2$timestamp))
time_length(int, unit = "mins")

library(conicfit)
CECB_2_re <- CECB_2 %>% dplyr::select(ID=batIDday, time=timestamp, x=utm.x, y=utm.y)

##fitting crwPredict
crwOut_5 <- crawlWrap(obsData= CECB_2_re, 
                      Time.name="time", 
                      timeStep="30 secs",
                      retryFits = 5)

plot(crwOut_5,ask=FALSE)
CECB_2_processed <- prepData(crwOut_5, type= c("UTM"), coordNames = c("x", "y"))

plot(CECB_2_proccessed)
par(mfrow=c(2,1))
hist(CECB_2_processed$step)
hist(CECB_2_processed$angle)

stateNames <- c("extensive search", "forage", "commute") # initial parameters
stepParMean <- c(1, 15, 30)
stepParSD <- c(10, 5, 1)
stepPar0 <- c(stepParMean, stepParSD)
anglePar0 <-c(2, 1, 0.1)


dist = list(step = "gamma", angle = "vm")

m <- momentuHMM::fitHMM(data=CECB_2_processed,
                        nbStates=3,
                        dist=dist,
                        Par0=list(step=stepPar0, angle=anglePar0),
                        stateNames = stateNames)
m
plot(m)