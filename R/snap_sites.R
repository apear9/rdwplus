#' A function to snap sites in a shapefile to a stream network
#' @description This function takes a set of survey site locations and makes sure that they are coincident with the stream network dataset.
#' @param sites File name for a shapefile containing the locations of the survey sites or a \code{SpatialPoints*} object representing the same thing.
#' @param streams File name for a shapefile containing the edges of the stream network or a \code{SpatialLines*} object representing the same thing.
#' @param max_move The maximum distance in map units that any site can be moved to snap it to the streams.
#' @param out The output file path. 
#' @param overwrite Whether the output should be allowed to overwrite any existing files. Defaults to \code{FALSE}.
#' @return Nothing. Note that a shapefile of snapped survey sites will be written to the file \code{out} and a shapefile called \code{basename(out)} will be imported into the GRASS mapset.
#' @export 
snap_sites <- function(sites, streams, max_move, out, overwrite = FALSE){
  invisible()
}