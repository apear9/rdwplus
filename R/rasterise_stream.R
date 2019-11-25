#' Turn a shapefile of stream edges into a raster
#' @description Given a shapefile of lines representing the channels of a stream network, this function will return a rasterised version of the shapefile. The raster will have the parameters of the current GRASS mapset.
#' @param streams A file name for a shapefile of stream edges in the current GRASS mapset.
#' @param out The filename of the output. 
#' @param overwrite A logical indicating whether the output is allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @param max_memory Max memory used in memory swap mode (MB). Defaults to \code{300}.
#' @param ... Additional arguments to \code{v.to.rast}.
#' @return Nothing. A file will be written to \code{out}. A raster with the name \code{basename(out)} will be written to the current GRASS mapset.
#' @examples 
#' \donttest{
#' if(!check_running()){
#' ## Initialise session
#' if(.Platform$OS.type == "windows"){
#'   my_grass <- "C:/Program Files/GRASS GIS 7.6"
#' } else {
#'   my_grass <- "/usr/lib/grass76/"
#' }
#' initGRASS(gisBase = my_grass, override = TRUE, mapset = "PERMANENT")
#' 
#' ## Load data set
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' stream_shp <- system.file("extdata", "streams.shp", package = "rdwplus")
#' 
#' set_envir(dem)
#' 
#' vector_to_mapset(vectors =  stream_shp)
#' 
#' ## Create binary stream
#' rasterise_stream("streams", "streams_rast.tif", overwrite = TRUE)
#' 
#' ## Plot
#' plot_GRASS("streams_rast.tif", col = topo.colors(2))
#' }
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