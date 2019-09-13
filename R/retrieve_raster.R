#' Write a layer from a GRASS mapset to file
#' @description This function writes a GRASS mapset raster to file.
#' @param layer The name of the raster in the GRASS mapset that is to be written out.
#' @param out_layer The name of the file to be created, with the relevant file extension.
#' @return Nothing.
#' @export
retrieve_raster <- function(layer, out_layer){
  
  # Check that GRASS is running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Check that both input lengths the same
  n_layers <- length(layer)
  n_outs   <- length(out_layer)
  if(n_layers != n_outs) stop("Number of inputs and outputs must be the same.")
  
  # Loop over in/out
  for(i in 1:n_layers){
    execGRASS(
      'r.out.gdal', 
      parameters = list(
        input = layer[i],
        output = out_layer[i]
      )
    )
  }
  
  # Return nothing
  invisible()
  
}