#' Burn in streams to a digital elevation model
#' @description Burning-in streams (also called 'drainage reinforcement') ensures flow direction and accumulation grids based on the digital elevation model will correctly identify the stream path.
#' @param dem A RasterLayer object containing the digital elevation model.
#' @param stream A RasterLayer object containing a rasterised stream. The stream pixels should have a value of 1 and non-stream pixels should have a value of 0.
#' @param burn The magnitude of the drainage reinforcement (in elevation units). Defaults to \code{10}.
#' @return A RasterLayer containing the burned digital elevation model.
#' @export 
burn_in <- function(dem, stream, burn = 10){
  
  # Input checking
  check_dem <- is_raster_layer(dem)
  check_stm <- is_raster_layer(stream)   
  if(!check_dem) stop("dem is not a Raster* object")
  if(!check_stm) stop("stream is not a Raster* object")
  
  # More input checking
  check_stm <- is_binary_raster(stream)
  if(!check_stm) stop("stream is not a binary raster.")
  
  # Burn in the stream and return
  dem - burn * stream
    
}