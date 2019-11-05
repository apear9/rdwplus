#' Burn in streams to a digital elevation model
#' @description Burning-in streams (also called 'drainage reinforcement') ensures flow direction and accumulation grids based on the digital elevation model will correctly identify the stream path.
#' @param dem Digital elevation model raster in the GRASS mapset. 
#' @param stream Binary stream raster in the GRASS mapset. 
#' @param out Name of output to be created in the GRASS mapset. 
#' @param burn The magnitude of the drainage reinforcement in elevation units. Defaults to \code{10} elevation units.
#' @param overwrite A logical indicating whether the file \code{out} should be overwritten in the mapset and on disk. Defaults to \code{FALSE}.
#' @return Nothing. A raster with the name \code{out} will be written to the current GRASS mapset.
#' @export 
burn_in <- function(dem, stream, out, burn = 10, overwrite = FALSE){
  
  # Check that grass is running
  running <- check_running()
  if(!running) stop("No active GRASS session. Program halted.")
  
  # Create command to run
  exec_cmd <- paste0(out, " = ", dem, " - ", burn, " * ", stream)
  
  # Run command with flags
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  execGRASS(
    "r.mapcalc",
    flags = flags,
    parameters = list(expression = exec_cmd)
  )

  # Return nothing
  invisible()
  
}
