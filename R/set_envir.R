#' Set projection and computation region from a raster file.
#' @description This function simplifies the process of setting up a GRASS environment with parameters such as cell snapping, size and mapset extent. 
#' @param file The file path to a raster that should be used to set environment parameters such as the projection, cell size, extent, etc. The \code{file} argument will automatically be imported into the mapset as \code{basename(file)}.
#' @param ... Optional arguments for \code{raster_to_mapset()}. The main argument of interest for most users will be \code{overwrite}, which should be set to true if an object of name \code{basename(file)} already exists in the mapset.
#' @return Nothing. Displays current environment settings.
#' @examples 
#' # Will only run if GRASS is running
#' # You should load rdwplus and initialise GRASS with initGRASS
#' if(check_running()){
#' 
#' # Load data set
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' 
#' # Set environment 
#' set_envir(dem)
#' 
#' }
#' @export
set_envir <- function(file, ...){
  
  # Check if GRASS session is running
  if(!check_running()) stop("No active GRASS session. Please run the 'initGRASS' function.")

  # Projection must be set first from file
  execGRASS(
    "g.proj", 
    flags = c("c", "quiet"),
    parameters = list(
      georef = file
    )
  )
  
  # Import the layer into the mapset
  layer <- raster_to_mapset(file, ...) 
  
  # Set region parameters from the layer in the mapset
  execGRASS(
    "g.region", 
    flags = c("verbose"), # not sure of utility of this flag.
    parameters = list(
      raster = layer        
    )
  )
  
}
