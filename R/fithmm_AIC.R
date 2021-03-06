#'best fit model with lowest AIC value
#'
#'@param x list of fit momentuHMMdata and data.frame
#'@return product of min AIC value
#'@export


best_fit_model <- function(x){
  allAIC <- unlist(lapply(x, AIC))
  product <- min(allAIC)
  if(is.numeric(product) == FALSE){
    return("ERROR - non numeric")
  }
  return(product)
  
}
