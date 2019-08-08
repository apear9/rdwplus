#' Reclassify streams into the format required for the land use metric calculations.
#' @description Given a streams raster, this function will either create a binary streams raster (0 for non-stream cells and 1 for stream cells) or a unary streams raster (1 for non-stream cells and NoData for stream cells). 
#' @param stream A streams raster as either a filepath to a raster or a Raster* object.
#' @param out The base name of the output file.
#' @param out_type Either 'binary' or 'unary'. See the Description above.
#' @return Nothing. A file with the name \code{out} will be written to the current working directory.
#' @export
reclassify_streams <- function(stream, out, out_type = "binary"){
  
  # Check out_type
  if(!out_type %in% c("binary", "unary")) stop("Invalid option for argument out_type. Must be either 'binary' or 'unary'.")
  # Check whether input for stream is a string
  if(is.character(stream)) stream <- raster(stream)
  # Otherwise check that it is a Raster* object
  if(!is_raster_layer(stream)) stop("The argument stream must be a Raster* object.")
  
  # Reclassify based on out_type
  if(out_type == "binary"){
    # Ones for stream
    stream[!is.na(stream[])] <- 1
    # Zeros for non-stream
    stream[is.na(stream[])] <- 0
  } else {
    ind <- is.na(stream[])
    # Ones for non-stream
    stream[ind] <- 1
    # NoData otherwise
    stream[!ind] <- NA
  }
  
  # Create new file in SAGA format
  in_file <- paste0(tempdir(), "/", out, ".tif")
  writeRaster(stream, in_file, overwrite = TRUE)
  convert_to_sgrd(in_file, paste0(out, ".sdat"))
  
  # Return nothing 
  invisible()
  
}