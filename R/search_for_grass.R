#' Find GRASS installations
#' @description This function finds the path to potential GRASS installations. Warning: this function works by brute force, so it may take a few minutes to find potential GRASS installations.
#' @return A vector of file paths to potential GRASS installations.
#' @export
search_for_grass <- function(){
  
  potential <- dir("C:/", "GRASS GIS", include.dirs = T, full.names = T, recursive = T)
  dirs <- file.info(potential)$isdir
  potential[dirs]
  
  
}