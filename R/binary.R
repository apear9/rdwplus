binary <- function(x, o, overwrite = FALSE){
  expr_calc <- paste0(o, " = if(isnull(", x,"), 0, 1)")
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  execGRASS(
    "r.mapcalc",
    flags = flags,
    parameters = list(expression = expr_calc)
  )
}