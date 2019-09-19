rast_calc <- function(ex, overwrite = TRUE){
  
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