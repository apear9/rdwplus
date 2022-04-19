#' Set a raster mask
#' @param x Raster to use as a mask
#' @param inverse Whether the inverse of the raster should be used as the mask. Defaults to \code{FALSE}.
#' @param overwrite Whether the existing mask should be overwritten. Defaults to \code{TRUE}.
#' @return Nothing.
#' @export
set_mask <- function(x, inverse = FALSE, overwrite = TRUE, ...){
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  if(inverse) flags <- c(flags, "i")
  execGRASS(
    "r.mask",
    parameters = list(
      raster = x,
      ...
    )
  )
  
}