#' Derive a flow length to streams and outlets
#' @description Given a (hydrologically corrected, see \code{\link{fill_sinks}}) DEM, this function produces a flow accumulation grid which shows the upstream area that flows into each cell in the DEM.
#' @param str_rast Rasterized unary streams file.
#' @param flow_dir Flow direction raster.
#' @param out A file name for the output raster of flow lengths.
#' @param to_outlet Calculate parameters for outlets flag. Defaults to \code{FALSE} for streams.
#' @param overwrite Overwrite flag. Defaults to \code{FALSE}.
#' @param max_memory Max memory used in memory swap mode (MB). Defaults to \code{300}.
#' @return Nothing. A file with the name \code{out} will be written to GRASS's current workspace.
#' @export
get_flow_length <- function(str_rast, flow_dir, out, to_outlet = FALSE, overwrite = FALSE, max_memory = 300){
  
  # Check whether GRASS running
  if(!check_running()) stop("There is no active GRASS session. Program halted.")
  
  # Define flags
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  if(to_outlet) flags <- c(flags, "o")

  execGRASS(
    "r.stream.distance",
    flags = flags,
    parameters = list(
      stream_rast = str_rast,
      direction = flow_dir,
      distance = out,
      memory = max_memory
    )
  )

}