#' Compute Euclidean distance to a survey site or stream line within a watershed
#' @description This function is needed to compute Euclidean distance from a feature of interest in a watershed raster.
#' @param target File name of the watershed outlet or streams (as a raster) in the current GRASS mapset.
#' @param out File path for the result to be written.
#' @param overwrite A logical indicating whether the outputs of this function should be allowed to overwrite existing files.
#' @return Nothing. A file with the name \code{basename(out)} will be created in the current GRASS mapset. 
#' @examples 
#' # Will only run if a GRASS session is initialised
#' if(check_running()){
#' # Load data set
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' sites <- system.file("extdata", "site.shp", package = "rdwplus")
#' stream_shp <- system.file("extdata", "streams.shp", package = "rdwplus")
#' 
#' set_envir(dem)
#' raster_to_mapset(rasters = dem, as_integer = FALSE)
#' vector_to_mapset(vectors = c(sites, stream_shp))
#' 
#' # Create binary stream
#' rasterise_stream("streams", "streams_rast.tif", overwrite = TRUE)
#' reclassify_streams("streams_rast.tif", "streams_binary.tif",
#'  out_type = "binary", overwrite = TRUE)
#' 
#' # Burn dem 
#' burn_in(dem = "dem.tif", stream = "streams_binary.tif", 
#' out = "dem_burn.tif", burn = 10, overwrite = TRUE)
#' 
#' # Fill sinks
#' fill_sinks(dem = "dem_burn.tif", out = "dem_fill.tif", size = 1, overwrite = TRUE)
#' 
#' # Derive flow accumulation and direction grids
#' derive_flow(dem = "dem_fill.tif", flow_dir = "fdir.tif", 
#' flow_acc = "facc.tif", overwrite = TRUE)
#' 
#' # Snap sites to pour points (based on flow accumulation)
#' snap_sites(sites = "site", flow_acc = "facc.tif", max_move = 2,
#'  out = "snapsite.shp", overwrite = TRUE)
#' 
#' # Compute current site's watershed
#' rowID <- 1
#' current_watershed <- paste0("watershed_", rowID, ".tif")
#' get_watershed(sites = "snapsite.shp",
#' i =  rowID, 
#' flow_dir = "fdir.tif", 
#' out = current_watershed, 
#' write_file = FALSE, 
#' overwrite = TRUE)
#' 
#' # Get pour points / outlets as raster cells 
#' site_coords <- readVECT("site")
#' coords_i <- site_coords@coords[rowID, 1:2]
#' coords_i_out <- paste0("pour_point_", rowID)
#' coord_to_raster(coords_i, coords_i_out, TRUE)
#' 
#' # Mask to this watershed for following operations
#' set_mask(basename(current_watershed))
#' 
#' # Compute iEDO distance (example from compute_metrics)
#' iEDO_distance <- "iEDO_distance"
#' get_distance(coords_i_out, iEDO_distance, TRUE)
#' 
#' clear_mask()
#' 
#' # Plot
#' plot_GRASS(iEDO_distance)
#' 
#' }
#' @export
get_distance <- function(target, out, overwrite = FALSE){
  
  # Check grass is running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Set flags
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  
  # Execute GRASS command
  execGRASS(
    "r.grow.distance",
    flags = flags,
    parameters = list(
      input = target,
      distance = basename(out),
      metric = "euclidean"
    )
  )
  
  # Return nothing
  invisible()
  
}