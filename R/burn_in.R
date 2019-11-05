#' Burn in streams to a digital elevation model
#' @description Burning-in streams (also called 'drainage reinforcement') ensures flow direction and accumulation grids based on the digital elevation model will correctly identify the stream path.
#' @param dem Digital elevation model raster in the GRASS mapset. 
#' @param stream Binary stream raster in the GRASS mapset. 
#' @param out Name of output to be crated in the GRASS mapset. 
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
  
  # If dem and stream are file paths, then import them as rasters
  # if(is.character(dem)) dem <- raster(dem)
  # if(is.character(stream)) stream <- raster(stream)
  
  # Input checking
  # check_dem <- is_raster_layer(dem)
  # check_stm <- is_raster_layer(stream)   
  # if(!check_dem) stop("dem is not a Raster* object")
  # if(!check_stm) stop("stream is not a Raster* object")
  
  # More input checking
  # check_stm <- is_binary_raster(stream)
  # if(!check_stm) stop("stream is not a binary raster.")
  
  # Burn in the stream
  # burned <- dem - burn * stream
  
  # Write raster to file
  # writeRaster(burned, out, overwrite = overwrite)
  # raster_to_mapset(out, overwrite = overwrite, max_memory = max_memory)

  # Return nothing
  invisible()
  
}
