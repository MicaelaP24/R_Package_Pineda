spring <- noctules %>% 
  filter(timestamp <= as.Date("2018-04-23"))
dir.create("C:\\Users\\12093\\Documents\\Bat data\\CSV")
write.csv(spring, 
          "C:\\Users\\12093\\Documents\\Bat data\\CSV\\spring.csv")
spring$timeLag <- unlist(lapply(timeLag(spring, units='secs'), c, NA)) 
range(spring$timeLag, na.rm=TRUE)
ggplot(spring@data)+geom_histogram(aes(x = timeLag))+xlim(200, 500)


##Expected function inputs
##Data frame of bats caught in spring

##Expected outputs
##Data frame with added column "timelag" which has regularized time lag intervals