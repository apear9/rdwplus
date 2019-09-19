#' Obtain flow direction and accumulation over a digital elevation model (DEM)
#' @description This function computes flow direction and accumulation (among other things) from a DEM. This is done using the \code{r.terraflow} tool in GRASS.
#' @param dem A digital elevation model that has been hydrologically corrected.
#' @param flow_dir The name of the output flow direction file in the current GRASS mapset.
#' @param flow_acc The name of the output flow accumulation file in the current GRASS mapset.
#' @param overwrite Whether any of the outputs should be allowed to overwrite existing files.
#' @param ... Additional arguments to \code{r.watershed}. 
#' @return Nothing. Files are written in the current GRASS mapset.
#' @export
derive_flow <- function(dem, flow_dir, flow_acc, overwrite = FALSE, ...){
  
  # Check that grass is running
  running <- check_running()
  if(!running) stop("No active GRASS session. Program halted.")
  
  # Use the following flags 
  flags <- "s" 
  if(overwrite){
    flags <- c(flags, "overwrite")
  }
  
  # Otherwise proceed
  # execGRASS(
  #   "r.terraflow",
  #   flags = flags,
  #   parameters = list(
  #     elevation = dem,
  #     filled = paste("out", basename(dem), sep = "__"),
  #     direction = flow_dir,
  #     accumulation = flow_acc,
  #     swatershed = sinks,
  #     tci = flow_tci,
  #     ...
  #   )
  # )
  execGRASS(
    "r.watershed",
    flags = flags,
    parameters = list(
      elevation = dem,
      drainage = flow_dir,
      accumulation = flow_acc
    )
  )
  
  # Return nothing
  invisible()
}