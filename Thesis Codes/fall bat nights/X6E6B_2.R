library(move)
library(momentuHMM)
library(tidyverse)
X6E6B_2 <- read.csv("/cloud/project/Thesis data/Fall nights/30 sec/X6E6B_2.csv")
X6E6B_2$timestamp <- ymd_hms(X6E6B_2$timestamp)



#check the interval of how long the bat was tracked per night

int <- interval(min(X6E6B_2$timestamp), max(X6E6B_2$timestamp))
time_length(int, unit = "mins")

library(conicfit)
X6E6B_2_re <- X6E6B_2 %>% dplyr::select(ID=batIDday, time=timestamp, x=utm.x, y=utm.y)

##fitting crwPredict
crwOut_5 <- crawlWrap(obsData= X6E6B_2_re, 
                      Time.name="time", 
                      timeStep="30 secs",
                      retryFits = 5)

plot(crwOut_5,ask=FALSE)
X6E6B_2_processed <- prepData(crwOut_5, type= c("UTM"), coordNames = c("x", "y"))

plot(X6E6B_2_proccessed)
par(mfrow=c(2,1))
hist(X6E6B_2_processed$step)
hist(X6E6B_2_processed$angle)

stateNames <- c("extensive search", "forage", "commute") # initial parameters
stepParMean <- c(1, 75, 150)
stepParSD <- c(50, 25, 10)
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
AIC(m)

