#' Turn coordinates of outlets into rasters
#' @description Given a set of coordinates in space (x, y), this function will return a rasterised version of that point in space.
#' @param outlets The name of a set of sites in the current GRASS mapset.
#' @param which The site to convert to raster.
#' @param out The file name of the output outlet raster in the current GRASS mapset.
#' @param overwrite Whether the output files should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @return Nothing.
#' @examples
#' # Will only run if GRASS is running
#' if(check_running()){
#' # Load data set
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' 
#' # Set environment parameters
#' set_envir(dem)
#' 
#' # Read in data
#' raster_to_mapset(dem)
#' 
#' # Set coordinates to rasterise
#' coord_df <-  c(1098671, 6924794)
#' 
#' # Convert to raster
#' coord_to_raster(outlet = coord_df, out = "coords", overwrite = TRUE)
#' 
#' # Plot
#' plot_GRASS("dem.tif", col = topo.colors(15))
#' plot_GRASS("coords", col = "red", add = TRUE)
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
      cat = as.character(which)
    )
  )
  
  # Return nothing
  invisible()
  
}