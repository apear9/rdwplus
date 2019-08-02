is_raster_layer <- function(x){
  length(grep("Raster", class(x))) > 0
}