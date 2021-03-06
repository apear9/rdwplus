#' A function to plot a raster from the current GRASS mapset
#' @description Given the name of a raster in the current GRASS mapset, this function will plot it as a \code{RasterLayer} object.
#' @param x The name of an object in the current GRASS mapset.
#' @param out_x Optional. If supplied, the function makes a call to \code{\link{retrieve_raster}} and writes out the raster to the file path \code{out_x}. Otherwise the function will write the layer to \code{tempdir}.
#' @param ... Additional arguments to \code{plot}.
#' @return Nothing.
#' @examples
#' # Will only run if GRASS is running
#' if(check_running()){
#' 
#' # Load data set
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' landuse <- system.file("extdata", "landuse.tif", package = "rdwplus")
#' sites <- system.file("extdata", "site.shp", package = "rdwplus")
#' stream_shp <- system.file("extdata", "streams.shp", package = "rdwplus")
#' 
#' # Set environment parameters and import data to GRASS
#' set_envir(dem)
#' raster_to_mapset(rasters = c(dem, landuse), as_integer = c(FALSE, TRUE))
#' vector_to_mapset(vectors = c(sites, stream_shp))
#' 
#' # Rasterise streams and sites
#' rasterise_stream("streams", "streams_rast.tif", overwrite = TRUE)
#' point_to_raster(outlets = "site", out = "sites_rast.tif", overwrite = TRUE)
#' 
#' # Plot
#' # Set number 1
#' par(mfrow = c(1,2))
#' plot_GRASS("dem.tif", col = topo.colors(15))
#' plot_GRASS("sites_rast.tif", col = heat.colors(1), add = TRUE)
#' 
#' # Set number 2
#' plot_GRASS("landuse.tif", col = topo.colors(2))
#' plot_GRASS("streams_rast.tif", col = heat.colors(1), add = TRUE)
#' 
#' # Reset plotting device parameters
#' par(mfrow = c(1, 1))
#' }
#' @export
plot_GRASS <- function(x, out_x, ...){
  
  # Check if GRASS is running
  if(!check_running()) stop("There is currently no valid GRASS session. Program halted.")
  
  # Retrieve the raster from the mapset
  if(missing(out_x)){
    out_x <- paste0(tempdir(), "/", x)
    retrieve_raster(x, out_x, TRUE) # allow overwrite of temporary files
  } else {
    retrieve_raster(x, out_x, FALSE) # but not if actual file location specified
  }
  
  # Load into r
  r <- raster(out_x)

  # Display raster
  plot(r, ...)
  
}