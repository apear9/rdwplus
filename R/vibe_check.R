#' A function to summarise the computation region, vectors and rasters in the mapset.
#' @description This function takes no inputs. It prints a list of data sets in the current GRASS mapset, as well as the parameters of the current computation region.
#' @return Nothing.
#' @examples 
#' if(check_running()) vibe_check()
#' @export 
vibe_check <- function(){
  
  # Check if a GRASS session exists
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Print computation region
  message("Current computation region:") 
  execGRASS("g.region", flags = "p")
  
  # Print vect names
  message("Vectors in mapset:")
  execGRASS("g.list", parameters = list(type = "vector"))
  
  # Print rast names
  message("Rasters in mapset:")
  execGRASS("g.list", parameters = list(type = "raster"))
  
  # Return nothing
  invisible()
  
}