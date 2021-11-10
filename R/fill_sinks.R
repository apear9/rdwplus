#' Fill sinks in a digital elevation model (DEM)
#' @description A sink is a depression in a DEM. Water flows into these depressions but does not flow out of them. These depressions, although often real features of landscapes, are problematic for flow direction and accumulation algorithms. Therefore, it is common practice to remove these depressions. This function removes depressions (sinks) in a DEM. Note that this function calls \code{r.hydrodem}, which is a GRASS GIS add-on. It can be installed through the GRASS GUI. 
#' @param dem The name of a DEM in the current GRASS mapset.
#' @param out Name of the output, which is a hydrologically corrected (sink-filled) DEM.
#' @param overwrite A logical indicating whether the output should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @param ... Optional additional parameters to \code{r.fill.dir}.
#' @return  Nothing. A file with the name \code{out} will be created in the current GRASS mapset.
#' @examples 
#' # Will only run if GRASS is running
#' if(check_running()){
#' 
#' }
#' @export
fill_sinks <- function(dem, out, overwrite = FALSE, ...){
  
  # Check that GRASS is running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Run r.fill.dir
  if(overwrite){
    execGRASS(
      "r.fill.dir",
      flags = "overwrite",
      parameters = list(
        input = dem,
        output = out,
        ...
      )
    )
  } else {
    execGRASS(
      "r.fill.dir",
      parameters = list(
        input = dem,
        output = out,
        ...
      )
    )
  }
  
  # Return nothing
  invisible()
  
}