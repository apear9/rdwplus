#' Extract streams from a flow accumulation raster
#' @description Derive a set of stream lines from a flow accumulation raster.
#' @param dem Name of the elevation raster in the current GRASS mapset.
#' @param flow_acc Name of the flow accumulation raster in the current GRASS mapset.
#' @param out File path to the output vector dataset of stream lines. Should be WITHOUT .shp extension. 
#' @param min_acc The minimum accumulation value (in upstream cells) that a cell needs to have in order to be classified as a stream. Defaults to \code{1000}.
#' @param min_length The minimum length of a stream segment in cells. Defaults to \code{0}.
#' @param overwrite A logical indicating whether the output should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @param ... Additional arguments to \code{r.stream.extract}.
#' @return Nothing. A file with the name \code{paste0(out, ".shp")} will be created and a vector dataset with the name \code{basename(out)} will appear in the current GRASS mapset. 
#' @examples  
#' # Will only run if GRASS is running
#' if(check_running()){
#' 
#' # Load data set
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' stream_shp <- system.file("extdata", "streams.shp", package = "rdwplus")
#' 
#' # Set environment parameters
#' set_envir(dem)
#' 
#' # Set 
#' raster_to_mapset(rasters = c(dem), as_integer = c(FALSE))
#' vector_to_mapset(vectors = c(stream_shp))
#' 
#' # Create binary stream
#' rasterise_stream("streams", "streams_rast.tif", overwrite = TRUE)
#' reclassify_streams("streams_rast.tif", "streams_binary.tif",
#'  out_type = "binary", overwrite = TRUE)
#' 
#' # Burn dem 
#' burn_in(dem = "dem.tif", stream = "streams_binary.tif", 
#' out = "dem_burn.tif", burn = 10, overwrite = TRUE)
#' 
#' # Fill sinks
#' fill_sinks(dem = "dem_burn.tif", out = "dem_fill.tif", size = 1, overwrite = TRUE)
#' 
#' # Derive flow accumulation and direction grids
#' derive_flow(dem = "dem_fill.tif", flow_dir = "fdir.tif",  
#' flow_acc = "facc.tif", overwrite = TRUE)
#' 
#' # Derive streams 
#' derive_streams(flow_acc = "facc.tif", out = "stream_lines", overwrite = TRUE)
#' }
#' @export
derive_streams <- function(dem, flow_acc, out, min_acc = 1e3, min_length = 0, overwrite = FALSE, ...){
  
  # Check for GRASS instance
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Set flags
  flags <- c("quiet")
  if(overwrite) flags <- c(flags, "overwrite")
  
  # Execute GRASS function
  out_grass <- basename(out)
  execGRASS(
    "r.stream.extract",
    flags = flags,
    parameters = list(
      elevation = dem,
      accumulation = flow_acc,
      stream_length = min_length,
      threshold = min_acc,
      stream_vector = out_grass,
      ...
    )
  )
  
  # Get as shapefile
  out_shp <- paste0(out, ".shp")
  retrieve_vector(out_grass, out_shp, overwrite = overwrite)
   
}