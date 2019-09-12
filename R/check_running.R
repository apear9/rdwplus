#' Check whether a valid GRASS session is running
#' @description This function is mostly used internally by other functions in the package. However, users may call this function to check whether they have correctly established a GRASS session prior to using the other functions in the package.
#' @return A logical. The logical indicates whether a valid GRASS session is currently running.
#' @examples 
#' 
#' check_running()
#' 
#' @export
check_running <- function(){
  info <- get.GIS_LOCK()
  nchar(info) > 0
}