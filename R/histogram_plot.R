noctules <- read.csv("C:\\Users\\12093\\Documents\\Bat data\\CSV\\spring.csv")
str(noctules)
unique(noctules$individual.local.identifier)
unique(noctules$timestamp)
library(tidyverse)
library(lubridate)
noctules$timestamp <- ymd_hms(noctules$timestamp)

f1 <- noctules %>% 
  filter(individual.local.identifier == "60F1")