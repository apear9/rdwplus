#' Set environment parameters from a GIS layer.
#' @description This function simplifies the process of setting up a GRASS environment with parameters such as cell snapping, size and mapset extent. 
#' @param layer A \code{Raster*} object or the file path to a GIS layer that should be used to set environment parameters such as cell size, extent, etc.
#' @return Nothing. Displays current environment settings.
#' @export
set_envir <- function(layer){
  
  # Check if GRASS session is running
  if(!check_running()) stop("No active GRASS session. Please use initGRASS.")

  # Check whether input is filepath or is already a raster layer
  if(!is_raster_layer(layer)){
    r_layer <- raster(layer)
  } else {
    r_layer <- layer
  }
  
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