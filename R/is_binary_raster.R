is_binary_raster <- function(x){
  check <- is_raster_layer(x)
  if(!check) stop("x is not a Raster* object.")
  n_unique <- length(unique(x))
  n_unique == 2 # need this to check binary
}