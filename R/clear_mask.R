#' Clear current raster mask
#' @description This function has no parameters. It can be used to clear an existing raster mask.
#' @examples 
#' if(check_running()) clear_mask()
#' @export
clear_mask <- function(){
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  check_for_mask <- execGRASS("g.list", type = 'raster', intern = T)
  if("MASK" %in% check_for_mask){
    execGRASS(
      "r.mask",
      flags = "r"
    )
  } 
}
