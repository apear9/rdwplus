#' Turn coordinates of outlets into rasters
#' @description Given a set of coordinates in space (x, y), this function will return a rasterised version of that point in space.
#' @param outlet A single pair of Easting, Northing or long, lat coordinates as a numeric vector. 
#' @param out The file name of the output outlet raster in the current GRASS mapset.
#' @param overwrite Whether the output files should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @return Nothing.
#' @examples
#' ## Uncomment and run the following if you haven't already got a
#' ## running session of GRASS 
#' ## Initialise session
#' #if(.Platform$OS.type == "windows"){
#' #   my_grass <- "C:/Program Files/GRASS GIS 7.6"
#' #} else {
#' #   my_grass <- "/usr/lib/grass76/"
#' #}
#' #initGRASS(gisBase = my_grass, override = TRUE, mapset = "PERMANENT")
#' 
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
coord_to_raster <- function(outlet, out, overwrite = FALSE){
  
  # Check grass running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Set flags
  flags <- c("quiet")
  if(overwrite) flags <- c(flags, "overwrite")
  
  # Convert coords to text
  text <- data.frame(x = outlet[1], y = outlet[2])
  where_temp <- paste0(tempdir(), "/temp_hold_coord.csv")
  write.csv(text, where_temp, row.names = FALSE)
  
  # Convert coords to point
  point <- paste0("point_", basename(out))
  execGRASS(
    "v.in.ascii",
    flags = c(flags, "n"),
    parameters = list(
      input = where_temp,
      output = point,
      separator = ",",
      format = "point",
      skip = 1
    )
  )
  
  # Clean up temporary file
  file.remove(where_temp)
  
  # Convert point to raster
  execGRASS(
    "v.to.rast",
    flags = flags,
    parameters = list(
      input = point,
      output = basename(out),
      use = "cat"
    )
  )
  
  # Return nothing
  invisible()
  
}