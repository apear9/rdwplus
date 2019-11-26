#' Convert a raster to integer format
#' @description Given a raster in float, double or any other format, this function will convert it to integer format. This can be important because it is often an unstated requirement of GRASS modules such as the one for zonal statistics. 
#' @param x A raster layer in the current GRASS mapset.
#' @return Nothing. A raster with the same name as \code{x} (it may overwrite it) but without the file extension, if one exists.
#' @examples 
#' ## Uncomment and run the following if you haven't already
#' ## set up a GRASS session
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
#' stream_shp <- system.file("extdata", "streams.shp", package = "rdwplus")
#' 
#' # Set environment parameters
#' set_envir(dem)
#' raster_to_mapset(rasters = dem)
#' vector_to_mapset(vectors = stream_shp)
#'  
#' # Rasterise the streams
#' rasterise_stream("streams", "streams_rast.tif", overwrite = TRUE)
#' 
#' ## Convert to integer
#' convert_to_integer("streams_rast.tif")
#' }
#' @export
convert_to_integer <- function(x){
  
  x <- basename(x) # doubt this is necessary but just to be safe
  x_dash <- delete_file_ext(x)
  command <- paste0(x_dash, " = int(", x, ")")
  rast_calc(command)
  invisible()
  
}