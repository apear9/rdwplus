#' Burn in streams to a digital elevation model
#' @description Burning-in streams (also called 'drainage reinforcement') ensures flow direction and accumulation grids based on the digital elevation model will correctly identify the stream path.
#' @param dem Digital elevation model raster in the GRASS mapset. 
#' @param stream Binary stream raster in the GRASS mapset. 
#' @param out Name of output to be created in the GRASS mapset. 
#' @param burn The magnitude of the drainage reinforcement in elevation units. Defaults to \code{10} elevation units.
#' @param overwrite A logical indicating whether the file \code{out} should be overwritten in the mapset and on disk. Defaults to \code{FALSE}.
#' @return Nothing. A raster with the name \code{out} will be written to the current GRASS mapset.
#' @examples
#' # Will only run if a GRASS session is initialised
#' if(check_running()){
#' # Load data set
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' stream_shp <- system.file("extdata", "streams.shp", package = "rdwplus")
#' set_envir(dem)
#' raster_to_mapset(dem)
#' vector_to_mapset(stream_shp)
#' 
#' # Create binary stream
#' rasterise_stream("streams", "streams_rast")
#' reclassify_streams("streams_rast", "streams_binary", out_type = "binary")
#' 
#' # Burn dem 
#' burn_in(dem = "dem.tif", stream = "streams_binary", 
#' out = "dem_burn", burn = 10, overwrite = FALSE)
#' 
#' # Plot
#' plot_GRASS("dem_burn", col = topo.colors(10))
#' }
#' @export 
burn_in <- function(dem, stream, out, burn = 10, overwrite = FALSE){
  
  # Check that grass is running
  running <- check_running()
  if(!running) stop("No active GRASS session. Program halted.")
  
  # Create command to run
  exec_cmd <- paste0(out, " = ", dem, " - ", burn, " * ", stream)
  
  # Run command with flags
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  execGRASS(
    "r.mapcalc",
    flags = flags,
    parameters = list(expression = exec_cmd)
  )
  
  # Return nothing
  invisible()
  
}
