#' A function to print current vectors and rasters in the mapset.
#' @description This function takes no inputs and prints a list of maps in mapset.
#' @return Nothing.
#' @export 
vibe_check <- function(){
  
  # Check if a GRASS session exists
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  print("Vectors in mapset:")
  execGRASS("g.list", parameters = list(type = "vector"))
  
  print("Rasters in mapset:")
  execGRASS("g.list", parameters = list(type = "raster"))
  
  # Return nothing
  invisible()
  
}