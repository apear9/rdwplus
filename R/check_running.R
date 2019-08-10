check_running <- function(){
  info <- get.GIS_LOCK()
  nchar(info) > 0
}