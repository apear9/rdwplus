#' Convert a raster to integer format
#' @description Given a raster in float, double or any other format, this function will convert it to integer format. This can be important because it is often an unstated requirement of GRASS modules such as the one for zonal statistics. 
#' @param x A raster layer in the current GRASS mapset.
#' @return Nothing. A raster with the same name as \code{x} (it may overwrite it) but without the file extension, if one exists.
#' @export
convert_to_integer <- function(x){
  
  x <- basename(x) # doubt this is necessary but just to be safe
  x_dash <- delete_file_ext(x)
  command <- paste0(x_dash, " = int(", x, ")")
  rast_calc(command)
  invisible()
  
}