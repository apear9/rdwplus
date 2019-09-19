#' Turn coordinates of outlets into rasters
#' @description Given a set of coordinates in space (x, y), this function will return a rasterised version of that point in space.
#' @param outlet A single pair of Easting, Northing or long, lat coordinates as a numeric vector. 
#' @param out The file name of the output outlet raster in the current GRASS mapset.
#' @param overwrite Whether the output files should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @return Nothing.
#' @export
coord_to_raster <- function(outlet, out, overwrite = FALSE){
  
  # Set flags
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  
  # Convert coords to text
  text <- paste(outlet, collapse = ",")
  
  # Convert coords to point
  point <- paste0("point_", basename(out))
  execGRASS(
    "v.in.ascii",
    flags = flags,
    parameters = list(
      input = text,
      output = point,
      separator = ","
    )
  )
  # Convert point to raster
  execGRASS(
    "v.to.rast",
    flags = flags,
    parameters = list(
      input = point,
      output = basename(out),
      use = "cat"
    )
  )
  
  # Return nothing
  invisible()
}