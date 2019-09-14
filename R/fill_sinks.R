#' Fill sinks in a digital elevation model (DEM)
#' @description A sink is a depression in a DEM. Water flows into these depressions but not out of them. These depressions, although often real features of landscapes, are problematic for flow direction and accumulation algorithms. Therefore, it is common practice to remove these depressions. This function removes depressions (sinks) in a DEM. Note that this function calls \code{r.hydrodem}, which is a GRASS GIS add-on. It can be installed through the GRASS GUI. 
#' @param dem The name of a DEM in the current GRASS mapset.
#' @param out Name of the output, which is a hydrologically corrected (sink-filled) DEM.
#' @param flags Optional. A vector of flags that should be passed to \code{r.hydrodem}. See details for more on the possible flags.
#' @param ... Optional additional parameters to \code{r.hydrodem}.
#' @return  Nothing. A file with the name \code{out} will be created in the current GRASS mapset.
#' @details 
#' 
#' The following flags may be supplied (as strings):
#' 
#' \itemize{
#'     \item "a" The nuclear option. Vigorously remove all sinks.
#'     \item "overwrite" The output files may overwrite existing ones.
#'     \item "verbose" Lots of module output.
#'     \item "quiet" Barely any module output.
#' }
#' 
#' @export
fill_sinks <- function(dem, out, flags, ...){
  
  # Check that GRASS is running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Run r.hydrodem
  if(missing(flags)){
    execGRASS(
      "r.hydrodem",
      parameters = list(
        input = dem,
        output = out,
        ...
      )
    )
  } else {
    execGRASS(
      "r.hydrodem",
      flags = flags,
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