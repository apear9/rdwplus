#' Derive a flow length to streams and outlets
#' @description Given a (hydrologically corrected, see \code{\link{fill_sinks}}) DEM, this function produces a flow accumulation grid which shows the upstream area that flows into each cell in the DEM.
#' @param dem A file path to the hydrologically corrected DEM, with .sgrd extension.
#' @param out A file name for the output raster of flow lengths.
#' @param overwrite Overwrite flag. Defaults to \code{FALSE}.
#' @return Nothing. A file with the name \code{out} will be written to SAGA's current workspace.
#' @export
get_flow_length <- function(dem, out, overwrite = FALSE){
  
  # Check whether GRASS running
  if(!check_running()) stop("There is no active GRASS session. Program halted.")
  
  # Define flags
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  
  execGRASS(
    "r.flow",
    flags = flags,
    parameters = list(
      elevation = dem,
      flowlength = out
    )
  )

}