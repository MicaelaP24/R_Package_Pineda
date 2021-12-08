library(move)
library(momentuHMM)
library(tidyverse)
X6E6B_1<- read.csv("/cloud/project/Thesis data/Fall nights/30 sec/X6E6B_3.csv")
X6E6B_1$timestamp <- ymd_hms(X6E6B_1$timestamp)



#check the interval of how long the bat was tracked per night

int <- interval(min(X6E6B_1$timestamp), max(X6E6B_1$timestamp))
time_length(int, unit = "mins")

library(conicfit)
X6E6B_1_re <- X6E6B_1%>% dplyr::select(ID=batIDday, time=timestamp, x=utm.x, y=utm.y)

##fitting crwPredict
crwOut_3 <- crawlWrap(obsData= X6E6B_1_re, 
                      Time.name="time", 
                      timeStep="30 secs",
                      retryFits = 5)

plot(crwOut_3,ask=FALSE)
X6E6B_1_processed <- prepData(crwOut_3, type= c("UTM"), coordNames = c("x", "y"))

plot(X6E6B_1_processed)
par(mfrow=c(1,2))
hist(X6E6B_1_processed$step, xlim= c(0,250), ylim= c(0,25))
hist(X6E6B_1_processed$angle)

stateNames <- c("extensive search", "forage", "commute") # initial parameters
stepParMean <- c(1, 25, 100)
stepParSD <- c(20, 15, 10)
stepPar0 <- c(stepParMean, stepParSD)
anglePar0 <-c(2, 0.5, 0.001)


dist = list(step = "gamma", angle = "vm")

m <- momentuHMM::fitHMM(data=a_processed,
                        nbStates=3,
                        dist=dist,
                        Par0=list(step=stepPar0, angle=anglePar0),
                        stateNames = stateNames)
m
plot(m)
AIC(m)

