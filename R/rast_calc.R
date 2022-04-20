#' Raster calculator (wrapper for "r.mapcalc")
#' @param ex A valid raster calculator expression for GRASS.
#' @param overwrite Defaults to \code{TRUE}.
#' @return Nothing.
#' @export
rast_calc <- function(ex, overwrite = TRUE){
  
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  execGRASS(
    "r.mapcalc",
    flags = flags,
    parameters = list(
      expression = ex
    )
  )
  
}