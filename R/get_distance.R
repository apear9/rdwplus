#' Compute Euclidean distance to a survey site or stream line within a watershed
#' @description This function is needed to compute Euclidean distance from a feature of interest in a watershed raster.
#' @param target File name of the watershed outlet or streams (as a raster) in the current GRASS mapset.
#' @param out File path for the result to be written.
#' @param overwrite A logical indicating whether the outputs of this function should be allowed to overwrite existing files.
#' @return Nothing. A file with the name \code{basename(out)} will be created in the current GRASS mapset. 
get_distance <- function(target, out, overwrite = FALSE){
  
  # Check grass is running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Set flags
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  
  # Execute GRASS command
  execGRASS(
    "r.grow.distance",
    parameters = list(
      input = target,
      distance = basename(out),
      metric = "euclidean"
    )
  )
  
  # Return nothing
  invisible()
  
}