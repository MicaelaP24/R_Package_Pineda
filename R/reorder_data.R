noctules_2 <- read.csv("C:\\Users\\12093\\Documents\\Bat data\\Nyctalus.csv")
noctules2<- noctules_2 %>% 
  rename(ID = individual.local.identifier)
data_ordered <- noctules2[with(noctules2, order(ID, timestamp)),]
data_ordered
