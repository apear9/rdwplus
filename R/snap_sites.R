#' A function to snap sites in a shapefile to a stream grid
#' @description This function takes a set of survey site locations and makes sure that they are coincident with the point nearest the stream line within a specified distance. This is equivalent to snapping sites to a stream network. Note that this function calls \code{r.stream.snap}, which is a GRASS GIS add-on. It can be installed through the GRASS GUI.
#'
#' @param sites File name for a shapefile containing the locations of the survey sites in the current GRASS mapset.
#' @param streams File name for a binary streams raster in the current GRASS mapset. Snaps points to closest point on stream line. Defaults to NULL. 
#' @param flow_acc File name for a flow accumulation raster in the current GRASS mapset. Flow accumulation will snap to largest accumulation point. Defaults to NULL. 
#' @param max_move The maximum distance in cells that any site can be moved to snap it to the flow accumulation grid.
#' @param out The output file path. 
#' @param overwrite Whether the output should be allowed to overwrite any existing files. Defaults to \code{FALSE}.
#' @param max_memory Max memory used in memory swap mode (MB). Defaults to \code{300}.
#' @param use_sp Logical to use 'sf' or 'stars' classes for vector objects. Defaults to \code{TRUE} to use 'stars' class.
#' @param ... Additional arguments to \code{r.stream.snap}.
#' 
#' @return Nothing. Note that a shapefile of snapped survey sites will be written to the location \code{out} and a shapefile called \code{basename(out)} will be imported into the GRASS mapset.
#' @examples 
#' # Will only run if GRASS is running
#' if(check_running()){
#' # Load data set
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' sites <- system.file("extdata", "site.shp", package = "rdwplus")
#' stream_shp <- system.file("extdata", "streams.shp", package = "rdwplus")
#' 
#' # Set environment parameters and import data to GRASS
#' set_envir(dem)
#' raster_to_mapset(rasters = c(dem), as_integer = c(FALSE))
#' vector_to_mapset(vectors = c(sites, stream_shp))
#' 
#' # Create binary stream
#' out_name <- paste0(tempdir(), "/streams_rast.tif")
#' rasterise_stream("streams", out_name, overwrite = TRUE)
#' reclassify_streams("streams_rast.tif", "streams_binary.tif", 
#' out_type = "binary", overwrite = TRUE)
#' 
#' # Snap sites to pour points (based on flow accumulation)
#' out_snap <- paste0(tempdir(), "/snapsite.shp")
#' snap_sites(sites = "site", streams = "streams_binary.tif", max_move = 2, 
#' out = out_snap, overwrite = TRUE)
#' 
#' }
#' @export 
snap_sites <- function(sites, streams = NULL, flow_acc = NULL, max_move, out, overwrite = FALSE, max_memory = 300, use_sp = TRUE, ...){
  
  # Check if a GRASS session exists
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Check classes for vector objects in R
  if(use_sp) rgrass7::use_sp() else rgrass7::use_sf()
  
  # Call GRASS function
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  grass_out <- basename(out)
  grass_out <- gsub(".shp", "", grass_out)
  
  if(!is.null(streams) & is.null(flow_acc)){
    execGRASS(
      "r.stream.snap",
      flags = flags,
      parameters = list(
        input = sites,
        stream_rast = streams, 
        output = grass_out,
        radius = max_move,
        memory = max_memory,
        ...
      )
    )} else if(is.null(streams) & !is.null(flow_acc)){
      execGRASS(
        "r.stream.snap",
        flags = flags,
        parameters = list(
          input = sites,
          accumulation = flow_acc, 
          output = grass_out,
          radius = max_move,
          memory = max_memory,
          ...
        ))} else {
          stop("There are no streams or flow accumulation")
        }
  
  # Read in sites and grass out as vector points
  sites <- readVECT(sites)
  grass_out <- readVECT(grass_out)
  
  # Calculate distances between original and snapped, add to grass_out
  grass_out$SnapDist <- pointDistance(sites, grass_out)
  
  # Export shapefile (maybe use v.out.ogr)
  raster::shapefile(x = grass_out, filename = out, overwrite = overwrite)
  vector_to_mapset(out, overwrite = overwrite)
  
  # Return nothing
  invisible()
  
}