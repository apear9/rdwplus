#' Import rasters into GRASS mapset
#' @description GRASS can only deal with raster and vector data in a GRASS mapset. This function takes external rasters and imports them into the current GRASS mapset.
#' @param rasters A character vector of filenames of rasters to import.
#' @return Nothing.
#' @export
raster_to_mapset <- function(rasters){
  
  # Check that GRASS is running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Check how many rasters
  n_raster <- length(rasters)
  
  # Loop over rasters
  for(i in 1:n_raster){
    cur_name <- rasters[i]
    out_name <- basename(cur_name)
    execGRASS(
      "r.import",
      parameters = list(
        input = cur_name,
        output = out_name
      )
    )
  }
  
  # Return nothing
  invisible()
  
}