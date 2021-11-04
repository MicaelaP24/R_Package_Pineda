noctules <- read.csv("C:\\Users\\12093\\Documents\\Bat data\\CSV\\spring.csv")
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