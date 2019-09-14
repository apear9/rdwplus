#' Turn a shapefile of stream edges into a raster
#' @description Given a shapefile of lines representing the channels of a stream network, and a reference raster that defines cell resolution and snapping, this function will return a rasterised version of the shapefile.
#' @param streams A file name for a shapefile of stream edges or a SpatialLines* object that represents the same thing.
#' @param reference_raster File path of a raster layer that defines the extent of the study area, as well as the cell resolution and snapping of the output raster. Can also be a \code{Raster*} object.
#' @param out The filename of the output. 
#' @param method A string. The method that should be used to process the stream. The options are "binary" (stream cells = 1, others = 0) or "unary" (stream cells = NoData, others = 1) 
#' @param overwrite A logical indicating whether the output is allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @return Nothing. A file will be written to \code{out}. A raster with the name \code{basename(out)} will be written to the current GRASS mapset.
#' @export
rasterise_stream <- function(streams, reference_raster, out, method = "binary", overwrite = FALSE){
  
  # Check if a GRASS session exists
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Check if streams is spatial lines
  if(!is_splines(streams)) streams <- shapefile(streams)
  
  # Check reference raster is a RasterLayer
  if(!is_raster_layer(reference_raster)) reference_raster <- raster(reference_raster)
  
  # Check valid method
  if(!method %in% c("unary", "binary")) stop("Invalid method specified. Either write 'unary' or 'binary'. See the documentation for further details.")
  
  # Mask, etc.
  reference_raster[] <- 1
  if(method == "unary"){
    streams_raster <- mask(reference_raster, streams, inverse = TRUE)
  } else {
    streams_raster <- mask(reference_raster, streams)
    streams_raster[is.na(streams_raster[])] <- 0
  }
  
  # Write out to file
  writeRaster(streams_raster, out, overwrite = overwrite)
  
  # Import to mapset
  raster_to_mapset(out, overwrite = overwrite)
  
  # Return nothing
  invisible()
}