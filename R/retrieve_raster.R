#' Write a raster layer from the current GRASS mapset to file
#' @description This function writes a GRASS mapset raster to file.
#' @param layer The name of the raster in the GRASS mapset that is to be written out.
#' @param out_layer The name of the file to be created, with the relevant file extension.
#' @param overwrite A logical indicating whether the output from this function should be allowed to overwrite any existing files. Defaults to \code{FALSE}.
#' @param max_memory Max memory used in memory swap mode (MB). Defaults to \code{300}.
#' @param ... Additional arguments to \code{r.out.gdal}.
#' @return Nothing.
#' @export
retrieve_raster <- function(layer, out_layer, overwrite = FALSE, max_memory = 300, ...){
  
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
          max_memory = max_memory,
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
          max_memory = max_memory,
          ...
        )
      )
    }
  }
  
  # Return nothing
  invisible()
  
}