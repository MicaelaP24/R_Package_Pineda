#'reorder data by individual ID and timestamp
#'
#'@param x a data frame
#'@param y individual local identifier column
#'@param z timestamp column
#'@return product of reordered data frame
#'@usage

data_ordered <- function(x, y, by_col){
  x <- x %>%
    rename(ID = {{y}}) %>% 
    rename(sortkey = {{by_col}})
  product <- x[with(x, order(ID, sortkey)),]
  
  if(is.data.frame(product) == FALSE){
    return("ERROR - non data frame")
  }
  return(product)
  
}


