#' Write a raster layer from the current GRASS mapset to file
#' @description This function writes a GRASS mapset raster to file.
#' @param layer The name of the raster in the GRASS mapset that is to be written out.
#' @param out_layer The name of the file to be created, with the relevant file extension.
#' @param overwrite A logical indicating whether the output from this function should be allowed to overwrite any existing files. Defaults to \code{FALSE}.
#' @param ... Additional arguments to \code{r.out.gdal}.
#' @return Nothing.
#' @examples \donttest{ 
#' \dontrun{ 
#' 
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
#' 
#' set_envir(dem)
#' raster_to_mapset(rasters = dem, as_integer = FALSE)
#' 
#' ## Retrieve raster 
#' retrieve_raster("dem.tif", out_layer = "retrieved_dem.tif", overwrite = TRUE)
#' 
#' }
#' }
#' }
#' @export
retrieve_raster <- function(layer, out_layer, overwrite = FALSE, ...){
  
  # Check that GRASS is running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Check that both input lengths the same
  n_layers <- length(layer)
  n_outs   <- length(out_layer)
  if(n_layers != n_outs) stop("Number of inputs and outputs must be the same.")
  
  # Loop over in/out
  if(overwrite){
    for(i in 1:n_layers){
      execGRASS(
        'r.out.gdal', 
        flags = c("overwrite", "quiet"),
        parameters = list(
          input = layer[i],
          output = out_layer[i],
          ...
        )
      )
    }
  } else {
    for(i in 1:n_layers){
      execGRASS(
        'r.out.gdal', 
        flags = c("quiet"),
        parameters = list(
          input = layer[i],
          output = out_layer[i],
          ...
        )
      )
    }
  }
  
  # Return nothing
  invisible()
  
}