library(move)
library(momentuHMM)
library(tidyverse)
X5493_4<- read.csv("/cloud/project/Thesis data/Fall nights/30 sec/X5493_4.csv")
X5493_4$timestamp <- ymd_hms(X5493_4$timestamp)



#check the interval of how long the bat was tracked per night

int <- interval(min(X5493_4$timestamp), max(X5493_4$timestamp))
time_length(int, unit = "mins")

library(conicfit)
X5493_4_re <- X5493_4%>% dplyr::select(ID=batIDday, time=timestamp, x=utm.x, y=utm.y)

##fitting crwPredict
crwOut_5 <- crawlWrap(obsData= X5493_4_re, 
                      Time.name="time", 
                      timeStep="30 secs",
                      retryFits = 5)

plot(crwOut_5,ask=FALSE)
X5493_4_processed <- prepData(crwOut_5, type= c("UTM"), coordNames = c("x", "y"))

plot(X5493_4_processed)
par(mfrow=c(2,1))
hist(X5493_4_processed$step)
hist(X5493_4_processed$angle)

stateNames <- c("extensive search", "forage", "commute") # initial parameters
stepParMean <- c(1, 75, 150)
stepParSD <- c(50, 25, 10)
stepPar0 <- c(stepParMean, stepParSD)
anglePar0 <-c(2, 1, 0.01)


dist = list(step = "gamma", angle = "vm")

m <- momentuHMM::fitHMM(data=X5493_4_processed,
                        nbStates=3,
                        dist=dist,
                        Par0=list(step=stepPar0, angle=anglePar0),
                        stateNames = stateNames)
m
plot(m)