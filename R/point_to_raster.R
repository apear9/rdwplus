#' Convert outlet of a watershed from shapefile format into raster format
#' @description Given a shapefile of outlet(s), this function will convert its contents into a raster.
#' @param outlets A shapefile of outlets in the current GRASS mapset.
#' @param out The name of the output raster.
#' @param overwrite A logical indicating whether the output should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @param max_memory Max memory used in memory swap mode (MB). Defaults to \code{300}.
#' @return Nothing. A file called \code{out} will be created in the current GRASS mapset.
#' @examples
#' ## Uncomment and run the following if you haven't already set up a GRASS session
#' ## Initialise session
#' #if(.Platform$OS.type == "windows"){
#' #   my_grass <- "C:/Program Files/GRASS GIS 7.6"
#' #} else {
#' #   my_grass <- "/usr/lib/grass76/"
#' #}
#' #initGRASS(gisBase = my_grass, override = TRUE, mapset = "PERMANENT")
#' 
#' # Will only run if GRASS is running
#' if(check_running()){
#' 
#' # Load data set
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' sites <- system.file("extdata", "site.shp", package = "rdwplus")
#' 
#' # Set environment parameters and import data to GRASS
#' set_envir(dem)
#' vector_to_mapset(vectors = sites)
#' 
#' # Point to raster
#' point_to_raster(outlets = "site", out = "sites_rast.tif", overwrite = TRUE)
#' 
#' # Check conversion success
#' vibe_check()
#' 
#' }
#' @export
point_to_raster <- function(
  outlets,
  out,
  overwrite = FALSE,
  max_memory = 300
){
  
  # Check if GRASS is running
  if(!check_running()) stop("There is currently no valid GRASS session. Program halted.")
  
  # Run GRASS function
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  execGRASS(
    "v.to.rast",
    flags = flags,
    parameters = list(
      input = outlets,
      output = out,
      type = "point",
      use = "cat",
      memory = max_memory
    )
  )
  
  # Return nothing
  invisible()
  
}