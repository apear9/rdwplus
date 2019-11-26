#' A function to print current vectors and rasters in the mapset.
#' @description This function takes no inputs. It prints a list of maps in the current GRASS mapset.
#' @return Nothing.
#' @examples 
#' if(check_running) vibe_check()
#' @export 
vibe_check <- function(){
  
  # Check if a GRASS session exists
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Print vect names
  message("Vectors in mapset:")
  execGRASS("g.list", parameters = list(type = "vector"))
  
  # Print rast names
  message("Rasters in mapset:")
  execGRASS("g.list", parameters = list(type = "raster"))
  
  # Return nothing
  invisible()
  
}