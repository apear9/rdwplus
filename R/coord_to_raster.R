#' Turn coordinates of outlets into rasters
#' @description Given a set of x-y coordinates, this function will return a raster with a single cell at those coordinates.
#' @param outlets The name of a set of sites in the current GRASS mapset.
#' @param which A numeric identifier for the site to convert to raster.
#' @param out The file name of the output outlet raster in the current GRASS mapset.
#' @param overwrite Whether the output files should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @return Nothing.
#' @details 
#' This function is exposed to the user, and users are welcome to use if convenient for them, this function is intended for internal use in other functions. 
#' @examples
#' # Will only run if GRASS is running
#' if(check_running()){
#' # Load data set
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' sts <- system.file("extdata", "sites.shp", packages = "rdwplus")
#' 
#' # Set environment parameters
#' set_envir(dem)
#' 
#' # Read in sites
#' vector_to_mapset(sts)
#' 
#' # Convert first site to raster
#' coord_to_raster(sts, 1, "coords", overwrite = TRUE)
#' }
#' @export
coord_to_raster <- function(outlets, which, out, overwrite = FALSE){
  
  # Check grass running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Set flags
  flags <- c("quiet")
  if(overwrite) flags <- c(flags, "overwrite")
  
  # Convert point to raster
  execGRASS(
    "v.to.rast",
    flags = flags,
    parameters = list(
      input = outlets,
      output = basename(out),
      use = "cat",
      cats = as.character(which)
    )
  )
  
  # Return nothing
  invisible()
  
}