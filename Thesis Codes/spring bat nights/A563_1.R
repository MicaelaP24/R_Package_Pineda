library(move)
library(momentuHMM)
library(tidyverse)
A563_1 <- read.csv("/cloud/project/Thesis data/Spring nights/A563_1.csv")
A563_1$timestamp <- ymd_hms(A563_1$timestamp)



#check the interval of how long the bat was tracked per night

int <- interval(min(A563_1$timestamp), max(A563_1$timestamp))
time_length(int, unit = "mins")

library(conicfit)
A563_1_re <- A563_1 %>% dplyr::select(ID=batIDday, time=timestamp, x=utm.x, y=utm.y)

##fitting crwPredict
crwOut_5 <- crawlWrap(obsData= A563_1_re, 
                      Time.name="time", 
                      timeStep="30 secs",
                      retryFits = 5)

plot(crwOut_5,ask=FALSE)
A563_1_processed <- prepData(crwOut_5, type= c("UTM"), coordNames = c("x", "y"))

plot(A563_1_proccessed)
par(mfrow=c(2,1))
hist(A563_1_processed$step)
hist(A563_1_processed$angle)

stateNames <- c("extensive search", "forage", "commute") # initial parameters
stepParMean <- c(1, 15, 30)
stepParSD <- c(10, 5, 1)
stepPar0 <- c(stepParMean, stepParSD)
anglePar0 <-c(2, 1, 0.1)


dist = list(step = "gamma", angle = "vm")

m <- momentuHMM::fitHMM(data=A563_1_processed,
                        nbStates=3,
                        dist=dist,
                        Par0=list(step=stepPar0, angle=anglePar0),
                        stateNames = stateNames)
m
plot(m)
