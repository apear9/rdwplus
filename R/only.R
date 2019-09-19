only <- function(x, target, compare){
  
  x <- x[x != target]
  !any(x %in% compare) & (target %in% compare)
  
}