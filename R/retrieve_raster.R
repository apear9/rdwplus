#' Write a layer from a GRASS mapset to file
#' @description This function writes a GRASS mapset raster to file.
#' @param layer The name of the raster in the GRASS mapset that is to be written out.
#' @param out_layer The name of the file to be created. If this is a filename only (i.e. no folder is specified in the file path), it will be written to the current working directory.
#' @return Nothing.
#' @export
retrieve_raster <- function(layer, out_layer){
  
  # Check that GRASS is running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Check whether we need to attach the working directory to file name
  if(basename(out_layer) != out_layer) out_layer <- paste(getwd(), out_layer, sep = "/")
  
  execGRASS(
    'r.out.gdal', 
    parameters = list(
      input = layer,
      output = out_layer
    )
  )
  
  # Return nothing
  invisible()
  
}