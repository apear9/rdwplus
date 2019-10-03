#' A function to plot a raster from the current GRASS mapset
#' @description Given the name of a raster in the current GRASS mapset, this function will plot it as a \code{RasterLayer} object.
#' @param x The name of an object in the current GRASS mapset.
#' @param out_x Optional. If supplied, the function makes a call to \code{\link{retrieve_raster}} and writes out the raster to the file path \code{out_x}. Otherwise the function will write the layer to \code{tempdir}.
#' @param ... Additional arguments to \code{plot}.
#' @return Nothing.
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