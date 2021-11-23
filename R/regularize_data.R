#'data frame with added column timelag  
#'
#'@param x is a movestack object
#'@return product histogram of timelags
#'@usage


timeLags <- function(x){
  x$timelag <- unlist(lapply(timeLag(x, units='secs'), c, NA)) 
  product <- ggplot(x@data)+geom_histogram(aes(x = timelag)) +xlim(0, 100)
  if(is.ggplot(product) == FALSE){
    return("ERROR - non data frame")
  }
  return(product)
  
}
