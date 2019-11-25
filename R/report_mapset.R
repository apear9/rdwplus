#' Identify current mapset or list all possible mapsets
#' @description GRASS GIS uses a system of mapsets.
#' @param which One of either 'current' (the default), which causes the function to return the current mapset, or 'possible', which causes the function to list all possible mapsets.
#' @return Nothing.
#' @examples \dontrun{
#' 
#' # Get GRASS installation
#' my_grass <- search_for_grass()[1]
#' 
#' # Create GRASS session
#' initGRASS(my_grass)
#' 
#' # Ask for current mapset
#' report_mapset()
#' 
#' # Ask for possible mapsets
#' report_mapset('possible')
#' 
#' }
#' 
#' @export
report_mapset <- function(which = "current"){
  
  if(!which %in% c("current", "possible")) stop("Invalid 'which' value specified.")
  if(which == 'current'){
    flag <- "p"
  } else {
    flag <- "l"
  }
  execGRASS(
    "g.mapset",
    flags = flag
  )
  invisible()
  
}