#' Set environment parameters from a GIS layer.
#' @description This function simplifies the process of setting up a GRASS environment with parameters such as cell snapping, size and mapset extent. 
#' @param layer File path to a GIS layer that should be used to set environment parameters such as cell size, extent, etc.
#' @return Nothing.
#' @export
set_envir <- function(layer){
  if(!check_running()) stop("No active GRASS session. Please use initGRASS.")
  
  invisible()
  
}