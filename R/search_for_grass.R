#' Find GRASS installations
#' @description This function finds the path to potential GRASS installations. It does so in a very crude way; that is, by searching for directories that match the string \code{'GRASS'}.  
#' 
#' Warning: this function works by brute force, so it may take a few minutes to find potential GRASS installations.
#' 
#' Note: This is not guaranteed to work. It is not hard to find the path to your computer's GRASS installation yourself. This is the preferred course of action.
#'  
#' @param guide Optional. A specific folder to search in for the GRASS installation.
#' @return A vector of file paths to potential GRASS installations.
#' @examples 
#' \dontrun{ 
#' 
#' # Not run because this takes a few minutes
#' my_grass <- search_for_grass()
#' my_grass
#' 
#' }
#' @export
search_for_grass <- function(guide){
  if(missing(guide)){
    if(.Platform$OS.type == 'windows') {
      potential <- dir("C:/", "GRASS", include.dirs = T, full.names = T, recursive = T)
    } else {
      potential <- dir("/usr", "GRASS", include.dirs = T, full.names = T, recursive = T)
    }
  }else{
    potential <- dir(guide, "GRASS", include.dirs = T, full.names = T, recursive = T)
  }
  dirs <- file.info(potential)$isdir
  potential[dirs]
}