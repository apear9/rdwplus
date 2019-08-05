#' Compute Euclidean distance to a survey site or stream line within a watershed
#' @description This function is needed to compute Euclidean distance from a feature of interest in a watershed raster. The computations here are performed in the background by SAGA. This is required to manage memory correctly even for small rasters (~10s of MB).
#' @param background File path to an existing raster, which has non NoData cells for the watershed over which distances are being computed.
#' @param target File path to an existing raster, from which distances will be computed.
#' @param out_file File path for the result to be written.
#' @return Nothing. A file with the name and location \code{out_file} will be created. 
get_SAGA_distance <- function(background, target, out_file){
  
  # Convert to SAGA format
  tmp_in <- c(background, target)
  tmp_ot <- paste0(tempdir(), "/", tmp_in, ".sdat")
  convert_to_sgrd(tmp_out, fin_out)
  
  # Create distance raster
  rsaga.geoprocessor(
    "grid_tools",
    26, 
    list(
      FEATURES = tmp_ot[2],
      DISTANCE = paste0(out_file, ".sdat")
    )
  )
  
  # Return nothing
  invisible()
  
}