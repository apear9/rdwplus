#' Set environment parameters from a GIS layer.
#' @description This function simplifies the process of setting up a GRASS environment with parameters such as cell snapping, size and mapset extent. 
#' @param layer File path to a GIS layer that should be used to set environment parameters such as cell size, extent, etc.
#' @return Nothing.
#' @export
set_envir <- function(layer){
  if(!check_running()) stop("No active GRASS session. Please use initGRASS.")

  r_layer <- raster(layer)
  
  r_attr <- get_raster_attr(r_layer)
  
  execGRASS("g.mapset", flags = c("quiet"),
            parameters = list(
              mapset = "PERMANENT"))
  
  execGRASS("g.proj", flags = c("c", "quiet"),
            parameters = list(
              georef = layer
            ))
  
  execGRASS("g.region", flags = c("verbose"),
            parameters = r_attr)
  
}