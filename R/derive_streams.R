#' Extract streams from a flow accumulation raster
#' @description Derive a raster and a vector layer of stream lines from a flow accumulation raster.
#' @param dem Name of an elevation raster in the current GRASS mapset.
#' @param flow_acc Name of a flow accumulation raster in the current GRASS mapset.
#' @param out_vect Name of the output vector dataset of stream lines. Should be WITHOUT .shp extension. 
#' @param out_rast Name of the output raster dataset of stream lines. File extensions should not matter.
#' @param min_acc The minimum accumulation value that a cell needs to be classified as a stream. Defaults to \code{1000}.
#' @param min_length The minimum length of a stream segment in cells. Defaults to \code{0}.
#' @param overwrite A logical indicating whether the output should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @param ... Additional arguments to \code{r.stream.extract}.
#' @return Nothing. A vector dataset with the name \code{basename(out)} will appear in the current GRASS mapset. 
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
#' 
#' # Derive flow direction and accumulation grids
#' derive_flow("dem.tif", "fd.tif", "fa.tif", overwrite = T)
#' 
#' # Derive a new stream raster from the FA grid
#' derive_streams("dem.tif", "fa.tif", "new_stm.tif", "new_stm", min_acc = 200, overwrite = T)
#' }
#' @export
derive_streams <- function(dem, flow_acc, out_rast, out_vect, min_acc = 1e3, min_length = 0, overwrite = FALSE, ...){
  
  # Check for GRASS instance
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Set flags
  flags <- c("quiet")
  if(overwrite) flags <- c(flags, "overwrite")
  
  # Execute GRASS function
  execGRASS(
    "r.stream.extract",
    flags = flags,
    parameters = list(
      elevation = dem,
      accumulation = flow_acc,
      stream_length = min_length,
      threshold = min_acc,
      stream_vector = out_vect,
      stream_raster = out_rast,
      ...
    )
  )
   
}