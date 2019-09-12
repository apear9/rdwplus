#' Derive a flow accumulation grid from a digital elevation model (DEM) under the D8 flow direction algorithm
#' @description Given a (hydrologically corrected, see \code{\link{fill_sinks}}) DEM, this function produces a flow accumulation grid which shows the upstream area that flows into each cell in the DEM.
#' @param dem A file path to the hydrologically corrected DEM, with .sgrd extension.
#' @param out A file name for the output flow accumulation grid, with .sgrd extension.
#' @param ... Optional arguments to \code{rsaga.geoprocessor}.
#' @return Nothing. A file with the name \code{out} will be written to SAGA's current workspace.
#' @export
get_flowaccumulation <- function(dem, out, ...){
  
  # Check inputs
  dem_exists <- file.exists(dem)
  if(!dem_exists) stop(paste0("The file ", dem, " appears not to exist at that location. Please check, then try again."))
  

  
  
  # Return nothing
  invisible()
  
}