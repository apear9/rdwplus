#' Reclassify streams into the format required for the land use metric calculations
#' @description Given a streams raster, this function will either create a binary streams raster (0 for non-stream cells and 1 for stream cells) or a unary streams raster (1 for stream cells and NoData for all other cells). Another option is to reclassify the streams raster such that stream cells are given the value NoData and non-stream cells are given the value 1.
#' @param stream Name of a streams raster in the current GRASS mapset. Typically this is the result of \code{rasterise_stream}. The raster should have NoData values for all non-stream cells. Stream cells can have any other value.
#' @param out The output file.
#' @param out_type Either 'binary', 'unary', or 'none'. See the Description above.
#' @param overwrite A logical indicating whether the output should be allowed to overwrite any existing files. Defaults to \code{FALSE}.
#' @return Nothing. A file with the name \code{out} will be written to the current GRASS mapset. This raster will be in unsigned integer format.
#' @examples
#' # Will only run if GRASS is running
#' if(check_running()){
#' 
#' # Load data set
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' stream_shp <- system.file("extdata", "streams.shp", package = "rdwplus")
#' 
#' # Set environment parameters and import data
#' set_envir(dem)
#' vector_to_mapset(vectors =  stream_shp)
#' 
#' # Create binary stream
#' out_name <- paste0(tempdir(), "/streams_rast.tif")
#' rasterise_stream("streams", out_name, overwrite = TRUE)
#' reclassify_streams("streams_rast.tif", "streams_binary.tif", out_type = "binary", overwrite = TRUE)
#' reclassify_streams("streams_rast.tif", "streams_unary.tif", out_type = "unary", overwrite = TRUE)
#' reclassify_streams("streams_rast.tif", "streams_none.tif", out_type = "none", overwrite = TRUE)
#' 
#' # Plot
#' plot_GRASS("streams_rast.tif", col = topo.colors(2), main = "Rasterized Streams")
#' plot_GRASS("streams_binary.tif", col = topo.colors(2), main = "Binary Streams")
#' plot_GRASS("streams_unary.tif", col = topo.colors(2), main = "Unary Streams")
#' plot_GRASS("streams_none.tif", col = topo.colors(2), main = "Null (none) Streams")
#' }
#' @export
reclassify_streams <- function(stream, out, out_type = "binary", overwrite = FALSE){
  
  # Check that grass is running
  running <- check_running()
  if(!running) stop("No active GRASS session. Program halted.")
  
  # Check out_type
  if(!out_type %in% c("binary", "unary","none")) stop("Invalid option for argument out_type. Must be either 'binary', 'unary', or 'none'.")
  
  # Reclassify based on out_type
  if(out_type == "binary"){
    # Ones for stream
    # Zeros for non-stream
    binary(stream, out, overwrite)
  } 
  if(out_type == "none"){
    # NoData for stream
    none(stream, out, overwrite)
  }
  if(out_type == "unary"){
    # Ones for stream
    unary(stream, out, overwrite)
  }
  
  # Return nothing 
  invisible()
  
}