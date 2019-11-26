#' A function to plot a raster from a file name
#' @description Given a path to a file raster, this function will plot it as a \code{RasterLayer} object.
#' @param x A file path to a raster stored on disk. Can also be a \code{Raster*} object.
#' @param ... Additional arguments to \code{plot}.
#' @return Nothing.
#' @examples 
#' \dontrun{
#' # Load data set file path
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' # Plot
#' plot_layer(dem)
#' }
#' @export
plot_layer <- function(x, ...){
  
  # Check class of input
  if(!is_raster_layer(x)) x <- try(raster(x))
  if(is_error(x)){
    stop("Could not import the argument x as a RasterLayer")
  }
  
  # Display raster
  plot(x, ...)
  
}