#' Burn in streams to a digital elevation model
#' @description Burning-in streams (also called 'drainage reinforcement') ensures flow direction and accumulation grids based on the digital elevation model will correctly identify the stream path.
#' @param dem A RasterLayer object containing the digital elevation model. This can also be the file path to a raster. 
#' @param stream A RasterLayer object containing a rasterised stream. The stream pixels should have a value of 1 and non-stream pixels should have a value of 0. This can also be the file path to a raster. 
#' @param burn The magnitude of the drainage reinforcement (in elevation units). Defaults to \code{10}.
#' @param out An optional string giving the basename of the raster to be written to file. If missing, then no file will be written.
#' @return A RasterLayer containing the burned digital elevation model.
#' @export 
burn_in <- function(dem, stream, burn = 10, out){
  
  # If dem and stream are file paths, then import them as rasters
  if(is.character(dem)) dem <- raster(dem)
  if(is.character(stream)) stream <- raster(stream)
  
  # Input checking
  check_dem <- is_raster_layer(dem)
  check_stm <- is_raster_layer(stream)   
  if(!check_dem) stop("dem is not a Raster* object")
  if(!check_stm) stop("stream is not a Raster* object")
  
  # More input checking
  check_stm <- is_binary_raster(stream)
  if(!check_stm) stop("stream is not a binary raster.")
  
  # Burn in the stream
  burned <- dem - burn * stream
  
  # Write raster to file
  tmp_out <- paste0(tempdir(), "/", out, ".tif")
  writeRaster(burned, tmp_out)
  
  # Convert written file to SGRD format
  fin_out <- paste0(getwd(), "/", out, ".sdat")
  convert_to_sgrd(tmp_out, fin_out)
  
  # Return nothing
  invisible()
  
}
