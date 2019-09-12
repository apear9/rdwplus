#' Compute Euclidean distance to a survey site or stream line within a watershed
#' @description This function is needed to compute Euclidean distance from a feature of interest in a watershed raster. 
#' @param background A raster of the watershed outline. This can also be a file path to an existing raster.
#' @param target A raster of the survey site or stream lines. This can also be a file path to an existing raster.
#' @param out_file File path for the result to be written.
#' @return Nothing. A file with the name and location \code{out_file} will be created. 
get_distance <- function(background, target, out_file){
  
  # What happens if inputs are file names?
  if(is.character(background)) background <- raster(background)
  if(is.character(target)) target <- raster(target)
  
  # Check if inputs are now raster layers
  check_back <- is_raster_layer(background)
  check_targ <- is_raster_layer(target)
  if(!check_back) stop("The argument background is not a Raster* object")
  if(!check_targ) stop("The argument target is not a Raster* object")
  
  # Compute distance raster
  dist_raster <- distance(target, background)
  
  # Write distance raster 
  out_file <- paste0(out, ".tif")
  writeRaster(dist_raster, out_file)
  
  # Return nothing
  invisible()
  
}