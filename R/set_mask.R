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