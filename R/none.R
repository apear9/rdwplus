none <- function(x, o, overwrite = FALSE){
  expr_calc <- paste0(o, " = if(isnull(", x,"), 1, null())")
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  execGRASS(
    "r.mapcalc",
    flags = flags,
    parameters = list(expression = expr_calc)
  )
}