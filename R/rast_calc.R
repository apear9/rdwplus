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