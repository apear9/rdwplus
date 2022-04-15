zeros_to_nodata <- function(x, o, overwrite = FALSE){
  expr_calc <- paste0(o, " = if(", x, ",", x, ", null())")
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  execGRASS(
    "r.mapcalc",
    flags = flags,
    parameters = list(expression = expr_calc)
  )
}