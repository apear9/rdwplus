#' Extract streams from a flow accumulation raster
#' @description Derive a set of stream lines from a flow accumulation raster.
#' @param flow_acc Name of the flow accumulation raster in the current GRASS mapset.
#' @param out File path to the output vector dataset of stream lines. Should be WITHOUT .shp extension. 
#' @param min_acc The minimum accumulation value (in upstream cells) that a cell needs to have in order to be classified as a stream. Defaults to \code{1000}.
#' @param min_length The minimum length of a stream segment in cells. Defaults to \code{0}.
#' @param overwrite A logical indicating whether the output should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @param ... Additional arguments to \code{r.stream.extract}.
#' @return Nothing. A file with the name \code{paste0(out, ".shp")} will be created and a vector dataset with the name \code{basename(out)} will appear in the current GRASS mapset. 
#' @export
derive_streams <- function(flow_acc, out, min_acc = 1e3, min_length = 0, overwrite = FALSE, ...){
  
  # Check for GRASS instance
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Set flags
  flags <- c("quiet")
  if(overwrite) flags <- c(flags, "overwrite")
  
  # Execute GRASS function
  out_grass <- basename(out)
  execGRASS(
    "r.stream.extract",
    flags = flags,
    parameters = list(
      accumulation = flow_acc,
      stream_length = min_length,
      threshold = min_acc,
      stream_vector = out_grass,
      ...
    )
  )
  
  # Get as shapefile
  out_shp <- paste0(out, ".shp")
  retrieve_vector(out_grass, out_shp, overwrite = overwrite)
   
}