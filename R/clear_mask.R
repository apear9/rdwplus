clear_mask <- function(){
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  execGRASS(
    "r.mask",
    flags = "r"
  )
}