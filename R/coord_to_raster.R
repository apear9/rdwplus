#' Turn coordinates of outlets into rasters
#' @description Given a set of coordinates in space (x, y), this function will return a rasterised version of that point in space.
#' @param outlet A single pair of Easting, Northing or long, lat coordinates as a numeric vector. 
#' @param out The file name of the output outlet raster in the current GRASS mapset.
#' @param overwrite Whether the output files should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @return Nothing.
#' @export
coord_to_raster <- function(outlet, out, overwrite = FALSE){
  
  # Check grass running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Set flags
  flags <- c("quiet")
  if(overwrite) flags <- c(flags, "overwrite")
  
  # Convert coords to text
  text <- data.frame(x = outlet[1], y = outlet[2])
  where_temp <- paste0(tempdir(), "/temp_hold_coord.csv")
  write.csv(text, where_temp, row.names = FALSE)
  
  # Convert coords to point
  point <- paste0("point_", basename(out))
  execGRASS(
    "v.in.ascii",
    flags = c(flags, "n"),
    parameters = list(
      input = where_temp,
      output = point,
      separator = ",",
      format = "point",
      skip = 1
    )
  )
  
  # Clean up temporary file
  file.remove(where_temp)
  
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