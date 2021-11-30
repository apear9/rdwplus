#' A function to snap sites survey sites to a stream raster
#' @description This function takes a set of survey site locations and makes sure that they are coincident with the point nearest the stream line within a specified distance. This is equivalent to snapping sites to a stream network. Note that this function calls \code{r.stream.snap}, which is a GRASS GIS add-on. It can be installed through the GRASS GUI.
#'
#' @param sites File name for a shapefile containing the locations of the survey sites in the current GRASS mapset.
#' @param flow_acc Name of a flow accumulation raster in the current GRASS mapset. 
#' @param max_move The maximum distance in cells that any site can be moved to snap it to the flow accumulation grid.
#' @param out Name of the output in the current GRASS mapset 
#' @param overwrite Whether the output should be allowed to overwrite any existing files. Defaults to \code{FALSE}.
#' @param max_memory Max memory (in) used in memory swap mode. Defaults to \code{300} Mb.
#' @param ... Additional arguments to \code{r.stream.snap}.
#' 
#' @return Nothing.
#' @export 
snap_to_flow <- function(sites, flow_acc, max_move, out, overwrite = FALSE, max_memory = 300, ...){
  
  # Check if a GRASS session exists
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Call GRASS function
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  execGRASS(
    "r.stream.snap",
    flags = flags,
    parameters = list(
      input = sites,
      accumulation = streams, 
      output = out,
      radius = max_move,
      memory = max_memory,
      ...
    )
  )
  
  # Return nothing
  invisible()
  
}