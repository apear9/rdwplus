#' Fill sinks in a digital elevation model (DEM)
#' @description A sink is a depression in a DEM. Water flows into these depressions but not out of them. These depressions, although often real features of landscapes, are problematic for flow direction and accumulation algorithms. Therefore, it is common practice to remove these depressions. This function removes depressions (sinks) in a DEM.
#' @param dem File path to a digital elevation model, in SAGA format (.sgrd extension)
#' @param out Name of the file to be written out, INCLUDING a .sgrd extension. This will be the filled DEM.
#' @param ... Optional additional parameters to \code{rsaga.fill.sinks}. Note that the \code{method} is hard-coded to \code{'xxl.wang.liu.2006'}.
#' @return  Nothing. A file with the name \code{out} will be created in the current working directory.
fill_sinks <- function(dem, out, ...){
  
  # Check that input dem file exists
  dem_exist <- file.exists(dem)
  if(!dem_exist) stop(paste0("It appears that no file called ", dem, " exists.")) 
  
  # If that's all good, we can proceed to call the geoprocessor
  rsaga.fill.sinks(
    in.dem = dem,
    out.dem = out,
    method = "xxl.wang.liu.2006",
    ...
  )
  
  # Return nothing
  invisible()
  
}