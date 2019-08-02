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