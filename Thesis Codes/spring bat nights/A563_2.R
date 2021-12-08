library(move)
library(momentuHMM)
library(tidyverse)
A563_2 <- read.csv("/cloud/project/Thesis data/Spring nights/A563_2.csv")
A563_2$timestamp <- ymd_hms(A563_2$timestamp)



#check the interval of how long the bat was tracked per night

int <- interval(min(A563_2$timestamp), max(A563_2$timestamp))
time_length(int, unit = "mins")

library(conicfit)
A563_2_re <- A563_2 %>% dplyr::select(ID=batIDday, time=timestamp, x=utm.x, y=utm.y)

##fitting crwPredict
crwOut_5 <- crawlWrap(obsData= A563_2_re, 
                      Time.name="time", 
                      timeStep="30 secs",
                      retryFits = 5)

plot(crwOut_5,ask=FALSE)
A563_2_processed <- prepData(crwOut_5, type= c("UTM"), coordNames = c("x", "y"))

plot(A563_2_processed)
par(mfrow=c(2,1))
hist(A563_2_processed$step)
hist(A563_2_processed$angle)

stateNames <- c("extensive search", "forage", "commute") # initial parameters
stepParMean <- c(1, 15, 30)
stepParSD <- c(10, 5, 1)
stepPar0 <- c(stepParMean, stepParSD)
anglePar0 <-c(2, 1, 0.1)


dist = list(step = "gamma", angle = "vm")

m <- momentuHMM::fitHMM(data=A563_2_processed,
                        nbStates=3,
                        dist=dist,
                        Par0=list(step=stepPar0, angle=anglePar0),
                        stateNames = stateNames)
m
plot(m)

##four state model 
set.seed(12345)
niter <- 25
vals <- seq(1, niter, by = 1) 
allm <- split(vals, f = vals)

for(i in 1:niter) {
  tryCatch({
    # Step length mean 
    ES_Step0 <- runif(1, min = c(0.001, 25), max = c(25, 50))
    forageStep0 <- runif(1, min = c(51, 75), max = c(75, 100))
    commuteStep0 <- runif(1, min = c(101, 200), max = c(200, 250))
    moveStep0 <- runif(1, min = c(251, 350), max = c(350, 400))
    stepMean0 <- c(ES_Step0, forageStep0, commuteStep0, moveStep0)
    # Step length standard deviation
    stepSD0 <- runif(4,
                     min = c(5, 10),
                     max = c(10, 25)) # Turning angle mean
    anglePar0 <- c(2, 1, 0.5, 0.001)
    # Turning angle concentration
    dist <- list(step = "gamma", angle = "vm")
    # Fit model
    stepPar0 <- c(stepMean0, stepSD0)
    allm[[i]] <- fitHMM(data = A563_2_processed, 
                        nbStates = 4,
                        dist= dist,
                        Par0=list(step=stepPar0, angle=anglePar0))
  },error=function(e) NULL)
}

allm2 <- allm[-c(22)]
allnllkAIC4 <- unlist(lapply(allm, AIC))
best_model <- min(allnllkAIC4)
print(best_model)
allnllkAIC4
plot(allm$`14`)
best_model_14 <- allm$`14`
save(best_model_14, file="./Bat data/Best_models/CF51_3_best.Rdata")


