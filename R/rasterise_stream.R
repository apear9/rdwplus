#' Turn a shapefile of stream edges into a raster
#' @description Given a shapefile of lines representing the channels of a stream network, this function will return a rasterised version of the shapefile. The raster will have the parameters of the current GRASS mapset.
#' @param streams A file name for a shapefile of stream edges in the current GRASS mapset.
#' @param out The filename of the output. 
#' @param overwrite A logical indicating whether the output is allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @param max_memory Max memory used in memory swap mode (MB). Defaults to \code{300}.
#' @param ... Additional arguments to \code{v.to.rast}.
#' @return Nothing. A file will be written to \code{out}. Note that \code{out} can be a full file path to any location in your file system. A raster with the name \code{basename(out)} will be written to the current GRASS mapset.
#' @examples
#' # Will only run if GRASS is running
#' if(check_running()){
#' # Load data set
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' stream_shp <- system.file("extdata", "streams.shp", package = "rdwplus")
#' 
#' # Set environment parameters and import data to GRASS
#' set_envir(dem)
#' vector_to_mapset(vectors =  stream_shp)
#' 
#' # Create rasterised stream
#' out_name <- paste0(tempdir(), "/streams_rast.tif")
#' rasterise_stream("streams", out_name, overwrite = TRUE)
#' 
#' # Plot
#' plot_GRASS("streams_rast.tif", col = topo.colors(2))
#' 
#' }
#' @export
rasterise_stream <- function(streams, out, overwrite = FALSE, max_memory = 300, ...){
  
  # Check if a GRASS session exists
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Run grass function
  grass_out <- basename(out)
  if(overwrite){
    execGRASS(
      "v.to.rast",
      flags = "overwrite",
      parameters = list(
        input = streams,
        type = "line",
        output = grass_out,
        use = "val",
        value = 1,
        memory = max_memory,
        ...
      )
    )
  } else {
    execGRASS(
      "v.to.rast",
      parameters = list(
        input = streams,
        type = "line",
        output = grass_out,
        use = "val",
        value = 1,
        memory = max_memory,
        ...
      )
    )
  }
  
  # Write out to file
  retrieve_raster(grass_out, out, overwrite = overwrite)
  
  # Return nothing
  invisible()
}