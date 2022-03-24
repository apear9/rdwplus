#' Extract streams from a flow accumulation raster
#' @description Derive a raster and a vector layer of stream lines from a flow accumulation raster.
#' @param dem Name of an elevation raster in the current GRASS mapset.
#' @param flow_acc Name of a flow accumulation raster in the current GRASS mapset.
#' @param out_vect Name of the output vector dataset of stream lines. Should be WITHOUT .shp extension. 
#' @param out_rast Name of the output raster dataset of stream lines. File extensions should not matter.
#' @param min_acc The minimum accumulation value that a cell needs to be classified as a stream. Defaults to \code{1000}.
#' @param min_length The minimum length of a stream segment in cells. Defaults to \code{0}.
#' @param overwrite A logical indicating whether the output should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @param ... Additional arguments to \code{r.stream.extract}.
#' @return Nothing. A vector dataset with the name \code{basename(out)} will appear in the current GRASS mapset. 
#' @examples  
#' # Will only run if GRASS is running
#' if(check_running()){
#' }
#' @export
derive_streams <- function(dem, flow_acc, out_rast, out_vect, min_acc = 1e3, min_length = 0, overwrite = FALSE, ...){
  
  # Check for GRASS instance
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Set flags
  flags <- c("quiet")
  if(overwrite) flags <- c(flags, "overwrite")
  
  # Execute GRASS function
  execGRASS(
    "r.stream.extract",
    flags = flags,
    parameters = list(
      elevation = dem,
      accumulation = flow_acc,
      stream_length = min_length,
      threshold = min_acc,
      stream_vector = out_vect,
      stream_raster = out_rast,
      ...
    )
  )
   
}