#'one individual filtered out of the data set
#'
#'@param x a csv file with gps locations 
#'@param y individual local identifier column
#'@param z individual selected
#'@return data frame of one individual
#'@usage

fil <- function(x, y, z){
  product <- x %>% 
    rename(ID = {{y}}) %>% 
   filter(ID == z)
   if(is.data.frame(product) == FALSE){
    return("ERROR - non data frame")
  }
  return(product)
  
}


