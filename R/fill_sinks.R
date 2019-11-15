#' Fill sinks in a digital elevation model (DEM)
#' @description A sink is a depression in a DEM. Water flows into these depressions but not out of them. These depressions, although often real features of landscapes, are problematic for flow direction and accumulation algorithms. Therefore, it is common practice to remove these depressions. This function removes depressions (sinks) in a DEM. Note that this function calls \code{r.hydrodem}, which is a GRASS GIS add-on. It can be installed through the GRASS GUI. 
#' @param dem The name of a DEM in the current GRASS mapset.
#' @param out Name of the output, which is a hydrologically corrected (sink-filled) DEM.
#' @param flags Optional. A vector of flags that should be passed to \code{r.hydrodem}. See details for more on the possible flags.
#' @param overwrite A logical indicating whether the output should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @param max_memory Max memory used in memory swap mode (MB). Defaults to \code{300}.
#' @param ... Optional additional parameters to \code{r.hydrodem}.
#' @return  Nothing. A file with the name \code{out} will be created in the current GRASS mapset.
#' @details 
#' 
#' The following flags may be supplied (as strings):
#' 
#' \itemize{
#'     \item "a": The nuclear option. Vigorously remove all sinks.
#'     \item "verbose": Lots of module output.
#'     \item "quiet": Barely any module output.
#' }
#' 
#' @export
fill_sinks <- function(dem, out, flags, overwrite = FALSE, max_memory = 300, ...){
  
  # Check that GRASS is running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Run r.hydrodem
  if(missing(flags)){
    if(overwrite){
      execGRASS(
        "r.hydrodem",
        flags = "overwrite",
        parameters = list(
          input = dem,
          output = out,
          memory = max_memory,
          ...
        )
      )
    } else {
      execGRASS(
        "r.hydrodem",
        parameters = list(
          input = dem,
          output = out,
          memory = max_memory,
          ...
        )
      )
    }
  } else {
    if(overwrite) flags <- c(flags, "overwrite")
    execGRASS(
      "r.hydrodem",
      flags = flags,
      parameters = list(
        input = dem,
        output = out,
        memory = max_memory,
        ...
      )
    )
  }
  
  # Return nothing
  invisible()
  
}