#' Find GRASS installations
#' @description This function finds the path to potential GRASS installations. Warning: this function works by brute force, so it may take a few minutes to find potential GRASS installations.
#' @param guide An optional guide folder to search.
#' @return A vector of file paths to potential GRASS installations.
#' @examples 
#' \dontrun{ 
#' 
#' my_grass <- search_for_grass()
#' my_grass
#' 
#' }
#' @export
search_for_grass <- function(guide){
  if(missing(guide)){
    if(.Platform$OS.type == 'windows') {
      potential <- dir("C:/", "GRASS GIS", include.dirs = T, full.names = T, recursive = T)
    } else {
      potential <- dir("/usr", "grass", include.dirs = T, full.names = T, recursive = T)
    }
  }else{
    potential <- dir(guide, "GRASS GIS", include.dirs = T, full.names = T, recursive = T)
  }
  dirs <- file.info(potential)$isdir
  potential[dirs]
}