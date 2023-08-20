#' Fill sinks in a digital elevation model (DEM)
#' @description Remove sinks in a DEM (see the 'Details' section)
#' @param dem The name of a DEM in the current GRASS mapset.
#' @param out_dem Name of the output DEM, which is a hydrologically corrected (sink-filled) DEM.
#' @param out_fd Name of the output flow direction map for the sink-filled DEM.
#' @param out_sinks Optional argument giving the name of the output sinks raster. Leave this missing to skip the output.
#' @param overwrite A logical indicating whether the output should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @param ... Optional additional parameters to \code{r.fill.dir}.
#' @return  Nothing. A file with the name \code{out} will be created in the current GRASS mapset.
#' @details 
#' 
#' A sink is a depression in a DEM. Water flows into these depressions but does not flow out of them. These depressions, although often real features of landscapes, are problematic for flow direction and accumulation algorithms. Therefore, it is common practice to remove these depressions. 
#' 
#' @examples 
#' # Will only run if GRASS is running
#' if(check_running()){
#' # Retrieve paths to data sets
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' lus <- system.file("extdata", "landuse.tif", package = "rdwplus")
#' sts <- system.file("extdata", "site.shp", package = "rdwplus")
#' stm <- system.file("extdata", "streams.shp", package = "rdwplus")
#' 
#' # Set environment
#' set_envir(dem)
#' 
#' # Get other data sets (stream layer, sites, land use, etc.)
#' raster_to_mapset(lus)
#' vector_to_mapset(c(stm, sts))
#' 
#' # Reclassify streams
#' out_stream <- paste0(tempdir(), "/streams.tif")
#' rasterise_stream("streams", out_stream, TRUE)
#' reclassify_streams("streams.tif", "streams01.tif", overwrite = TRUE)
#' 
#' # Burn in the streams to the DEM
#' burn_in("dem.tif", "streams01.tif", "burndem.tif", overwrite = TRUE)
#' 
#' # Fill dem
#' fill_sinks("burndem.tif", "filldem.tif", "fd1.tif", "sinks.tif", overwrite = TRUE)
#' }
#' @export
fill_sinks <- function(dem, out_dem, out_fd, out_sinks, overwrite = FALSE, ...){
  
  # Check that GRASS is running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Run r.fill.dir
  flags <- NULL
  if(overwrite) flags <- "overwrite"
  
  # Inputs list
  inputs <- list(
    input = dem,
    output = out_dem,
    direction = out_fd,
    ...
  )
  # Add sink-checking argument
  if(!missing(out_sinks)) inputs$areas <- out_sinks
  
  # Execcute GRASS command
  execGRASS(
    "r.fill.dir",
    flags = flags,
    parameters = inputs
  )
  
  # Return nothing
  invisible()
  
}
