#'plot of speed & height above sea level 
#'
#'@param x a movestack object specifying a data frame
#'@param y height.above.msl column
#'@param z speed column
#'@return product plot of speed & height above sea level 
#'@export

point_plot <- function(x, y, z){
  product <- ggplot(data = x)+
    geom_point(aes(x = {{y}}, y = {{z}}))
  if(is.ggplot(product) == FALSE){
    return("ERROR - non plot")
  }
  return(product)
  
}

