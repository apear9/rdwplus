#' Turn a shapefile of stream edges into a raster
#' @description Given a shapefile of lines representing the channels of a stream network, this function will return a rasterised version of the shapefile. The raster will have the parameters of the current GRASS mapset.
#' @param streams A file name for a shapefile of stream edges in the current GRASS mapset.
#' @param out The filename of the output. 
#' @param overwrite A logical indicating whether the output is allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @param max_memory Max memory used in memory swap mode (MB). Defaults to \code{300}.
#' @param ... Additional arguments to \code{v.to.rast}.
#' @return Nothing. A file will be written to \code{out}. A raster with the name \code{basename(out)} will be written to the current GRASS mapset.
#' @export
rasterise_stream <- function(streams, out, overwrite = FALSE, max_memory = 300, ...){
  
  # Check if a GRASS session exists
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Check if streams is spatial lines
  # if(!is_splines(streams)) streams <- shapefile(streams)
  
  # Check reference raster is a RasterLayer
  # if(!is_raster_layer(reference_raster)) reference_raster <- raster(reference_raster)
  
  # Check valid method
  # if(!method %in% c("unary", "binary")) stop("Invalid method specified. Either write 'unary' or 'binary'. See the documentation for further details.")
  
  # Mask, etc.
  # reference_raster[] <- 1
  # if(method == "unary"){
  #   streams_raster <- mask(reference_raster, streams, inverse = TRUE)
  # } else {
  #   streams_raster <- mask(reference_raster, streams)
  #   streams_raster[is.na(streams_raster[])] <- 0
  # }
  grass_out <- basename(out)
  if(overwrite){
    execGRASS(
      "v.to.rast",
      flags = "overwrite",
      parameters = list(
        input = streams,
        type = "line",
        output = grass_out,
        use = "val",
        value = 1,
        memory = max_memory,
        ...
      )
    )
  } else {
    execGRASS(
      "v.to.rast",
      parameters = list(
        input = streams,
        type = "line",
        output = grass_out,
        use = "val",
        value = 1,
        memory = max_memory,
        ...
      )
    )
  }
  
  # Write out to file
  retrieve_raster(grass_out, out, overwrite = overwrite)
  
  # Return nothing
  invisible()
}