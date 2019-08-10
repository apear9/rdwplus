check_running <- function(){
  info <- get.GIS_LOCK()
  length(info) > 0
}