#' Compute Euclidean distance to a survey site or stream line within a watershed
#' @description This function is needed to compute Euclidean distance from a feature of interest in a watershed raster.
#' @param target File name of the watershed outlet or streams (as a raster) in the current GRASS mapset.
#' @param out File path for the result to be written.
#' @param overwrite A logical indicating whether the outputs of this function should be allowed to overwrite existing files.
#' @return Nothing. A file with the name \code{basename(out)} will be created in the current GRASS mapset. 
#' @examples 
#' if(check_running()){
#' 
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
#' 
#' # Derive flow direction and accumulation grids
#' derive_flow("dem.tif", "fd.tif", "fa.tif", overwrite = T)
#' 
#' # Derive a new stream raster from the FA grid
#' derive_streams("dem.tif", "fa.tif", "new_stm.tif", "new_stm", min_acc = 200, overwrite = T)
#' 
#' # Get distances
#' get_distance("new_stm.tif", "dist_from_stream.tif", T)
#'
#' }
#' @export
get_distance <- function(target, out, overwrite = FALSE){
  
  # Check grass is running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Set flags
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  
  # Execute GRASS command
  execGRASS(
    "r.grow.distance",
    flags = flags,
    parameters = list(
      input = target,
      distance = basename(out),
      metric = "euclidean"
    )
  )
  
  # Return nothing
  invisible()
  
}