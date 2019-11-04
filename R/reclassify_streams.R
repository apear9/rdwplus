#' Reclassify streams into the format required for the land use metric calculations
#' @description Given a streams raster, this function will either create a binary streams raster (0 for non-stream cells and 1 for stream cells) or a unary streams raster (1 for stream cells and NoData for all other cells). Another option is to reclassify the streams raster such that stream cells are given the value NoData and non-stream cells are given the value 1.
#' @param stream A streams raster as either a filepath to a raster or a Raster* object.
#' @param out The output file.
#' @param out_type Either 'binary', 'unary', or 'none'. See the Description above.
#' @param overwrite A logical indicating whether the output should be allowed to overwrite any existing files. Defaults to \code{FALSE}.
#' @param max_memory Max memory used in memory swap mode (MB). Defaults to \code{300}.
#' @return Nothing. A file with the name \code{out} will be written to the current working directory and a raster with the name \code{basename(out)} will be imported into the current GRASS mapset. This raster will have the \code{INT1U} data type. 
#' @export
reclassify_streams <- function(stream, out, out_type = "binary", overwrite = FALSE, max_memory = 300){
  
  # Check that grass is running
  running <- check_running()
  if(!running) stop("No active GRASS session. Program halted.")
  
  # Check out_type
  if(!out_type %in% c("binary", "unary","none")) stop("Invalid option for argument out_type. Must be either 'binary', 'unary', or 'none'.")
  # Check whether input for stream is a string
  # if(is.character(stream)) stream <- raster(stream)
  # Otherwise check that it is a Raster* object
  # if(!is_raster_layer(stream)) stop("The argument stream must be a Raster* object.")
  
  # Reclassify based on out_type
  if(out_type == "binary"){
    # Ones for stream
    # stream[!is.na(stream[])] <- 1
    # Zeros for non-stream
    # stream[is.na(stream[])] <- 0
    binary(stream, out, overwrite)
  } 
  if(out_type == "none"){
    # ind <- !is.na(stream[])
    # NoData for stream
    # stream[ind] <- NA
    # Ones otherwise
    # stream[!ind] <- 1
    none(stream, out, overwrite)
  }
  if(out_type == "unary"){
    ind <- !is.na(stream[])
    # Ones for stream
    # stream[ind] <- 1
    # NoData otherwise
    # stream[!ind] <- NA
    unary(stream, out, overwrite)
  }
  
  # Create new file (LOG1S)
  # writeRaster(x = stream, filename = out, overwrite = overwrite, datatype = "INT1U") 
  # raster_to_mapset(out, overwrite = overwrite, max_memory = max_memory)
  
  # Return nothing 
  invisible()
  
}