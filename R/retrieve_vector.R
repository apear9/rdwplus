#' Write a vector layer from the current GRASS mapset to file
#' @description This function writes a GRASS mapset vector layer (like a shapefile) to file.
#' @param layer The name of the vector layer in the GRASS mapset that is to be written out.
#' @param out_layer The name of the shapefile to be created (with .shp file extension).
#' @param overwrite A logical indicating whether the output from this function should be allowed to overwrite any existing files. Defaults to \code{FALSE}.
#' @param ... Additional arguments to \code{v.out.ogr}.
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
#' stream_shp <- system.file("extdata", "streams.shp", package = "rdwplus")
#' 
#' set_envir(dem)
#' vector_to_mapset(vectors = stream_shp)
#' 
#' ## Retrieve raster 
#' retrieve_vector("streams", out_layer = "retrieved_streams.shp", overwrite = TRUE)
#' 
#' }
#' }
#' }
#' @export
retrieve_vector <- function(layer, out_layer, overwrite = FALSE, ...){
  
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
        'v.out.ogr', 
        flags = c("overwrite", "quiet"),
        parameters = list(
          input = layer[i],
          output = out_layer[i],
          format = "ESRI_Shapefile",
          ...
        )
      )
    }
  } else {
    for(i in 1:n_layers){
      execGRASS(
        'v.out.ogr', 
        flags = c("quiet"),
        parameters = list(
          input = layer[i],
          output = out_layer[i],
          format = "ESRI_Shapefile",
          ...
        )
      )
    }
  }
  
  # Return nothing
  invisible()
  
}