#' Convert a raster to integer format
#' @description Given a raster in float, double or any other format, this function will convert it to integer format. This can be important because it is often an unstated requirement of GRASS modules such as the one for zonal statistics. 
#' @param x A raster layer in the current GRASS mapset.
#' @param out Name of the output raster. Avoid names with hyphens.
#' @return Nothing. A raster with the name \code{out} will be added to the current GRASS mapset.
#' @examples 
#' # Will only run if GRASS is running
#' if(check_running()){
#' 
#' # Load data set
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' 
#' # Set environment 
#' set_envir(dem)
#' 
#' # Make an integer-valued version of 'dem.tif'
#' convert_to_integer("dem.tif", "int_dem.tif")
#' 
#' # Compare
#' plot_GRASS("dem.tif")
#' plot_GRASS("int_dem.tif)
#' 
#' }
#' @export
convert_to_integer <- function(x, out){
  
  command <- paste0(out, " = int(", x, ")")
  rast_calc(command)
  invisible()
  
}
