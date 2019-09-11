get_raster_attr <- function(x){
  
  # check x is RasterLayer
  ras <- is_raster_layer(x)
  if(!ras) stop("x is not a Raster* object")
  
  # extract attributes
  ext <- x@extent
  xrs <- xres(x)
  yrs <- yres(x)
  up__ <- ext@ymax
  down <- ext@ymin
  left <- ext@xmin
  rite <- ext@xmax
  
  # return as list
  list(
    res = c(xrs, yrs),
    u = up__,
    d = down,
    l = left,
    r = rite
  )
  
}