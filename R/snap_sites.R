#' A function to snap sites in a shapefile to a stream network
#' @description This function takes a set of survey site locations and makes sure that they are coincident with the stream network dataset.
#' @param sites File name for a shapefile containing the locations of the survey sites or a \code{SpatialPoints*} object representing the same thing.
#' @param streams File name for a shapefile containing the edges of the stream network or a \code{SpatialLines*} object representing the same thing.
#' @param max_move The maximum distance in map units that any site can be moved to snap it to the streams.
#' @param out The output file path. 
#' @param overwrite Whether the output should be allowed to overwrite any existing files. Defaults to \code{FALSE}.
#' @param ... Additional arguments to \code{v.import}.
#' @return Nothing. Note that a shapefile of snapped survey sites will be written to the file \code{out} and a shapefile called \code{basename(out)} will be imported into the GRASS mapset.
#' @export 
snap_sites <- function(sites, streams, max_move, out, overwrite = FALSE, ...){
  
  # Check if a GRASS session exists
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Check if sites is spatial points
  if(!is_sppoints(sites)) sites <- shapefile(sites)
  
  # Check if streams is spatial lines
  if(!is_splines(streams)) streams <- shapefile(streams)
  
  # Record attributes of sites shapefile
  shp_attr <- names(sites@data)
  
  # Snap sites to streams shapefile
  snapped <- snapPointsToLines(sites, streams, maxDist = max_move, withAttrs = TRUE)
  
  # Delete extra fields added by called to snap points
  snapped@data <- snapped@data[, shp_attr]
  
  # Write out to file
  shapefile(snapped, filename = out, overwrite = overwrite)
  
  # Import to mapset
  vector_to_mapset(out, overwrite, ...)
  
  # Return nothing
  invisible()
}