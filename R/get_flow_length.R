#' Derive a flow length to streams and outlets
#' @description Given a (hydrologically corrected, see \code{\link{fill_sinks}}) DEM, this function produces a flow accumulation grid which shows the upstream area that flows into each cell in the DEM. Note that this function calls \code{r.stream.distance}, which is a GRASS GIS add-on. It can be installed through the GRASS GUI.
#' @param str_rast Rasterized unary streams file.
#' @param flow_dir Flow direction raster.
#' @param out A file name for the output raster of flow lengths.
#' @param to_outlet Calculate parameters for outlets flag. Defaults to \code{FALSE} for streams.
#' @param overwrite Overwrite flag. Defaults to \code{FALSE}.
#' @param max_memory Max memory used in memory swap mode (MB). Defaults to \code{300}.
#' @return Nothing. A file with the name \code{out} will be written to GRASS's current workspace.
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
#' raster_to_mapset(rasters = dem, as_integer = FALSE)
#' vector_to_mapset(vectors = c(sites, stream_shp))
#' 
#' # Create binary stream
#' rasterise_stream("streams", "streams_rast.tif", overwrite = TRUE)
#' reclassify_streams("streams_rast.tif", "streams_binary.tif", 
#' out_type = "binary", overwrite = TRUE)
#' 
#' # Burn dem 
#' burn_in(dem = "dem.tif", stream = "streams_binary.tif",
#'  out = "dem_burn.tif", burn = 10, overwrite = TRUE)
#' 
#' # Fill sinks
#' fill_sinks(dem = "dem_burn.tif", out = "dem_fill.tif", size = 1, overwrite = TRUE)
#' 
#' # Derive flow accumulation and direction grids
#' derive_flow(dem = "dem_fill.tif", flow_dir = "fdir.tif",
#'  flow_acc = "facc.tif", overwrite = TRUE)
#' 
#' # Snap sites to pour points (based on flow accumulation)
#' snap_sites(sites = "site", flow_acc = "facc.tif", max_move = 2, 
#' out = "snapsite.shp", overwrite = TRUE)
#' 
#' # Get pour points / outlets as raster cells 
#' rowID <- 1
#' site_coords <- readVECT("site")
#' coords_i <- site_coords@coords[rowID, 1:2]
#' coords_i_out <- paste0("pour_point_", rowID)
#' coord_to_raster(coords_i, coords_i_out, TRUE)
#' 
#' # Name for flow length raster
#' current_flow_out <- paste0("flowlenOut_", rowID, ".tif")
#' 
#' # Create it
#' get_flow_length(str_rast = coords_i_out, 
#' flow_dir = "fdir.tif", 
#' out = current_flow_out, 
#' to_outlet = TRUE, 
#' overwrite = TRUE)
#' 
#' # Plot 
#' plot_GRASS(current_flow_out, col = topo.colors(15))
#' }
#' @export
get_flow_length <- function(str_rast, flow_dir, out, to_outlet = FALSE, overwrite = FALSE, max_memory = 300){
  
  # Check whether GRASS running
  if(!check_running()) stop("There is no active GRASS session. Program halted.")
  
  # Define flags
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  if(to_outlet) flags <- c(flags, "o")

  execGRASS(
    "r.stream.distance",
    flags = flags,
    parameters = list(
      stream_rast = str_rast,
      direction = flow_dir,
      distance = out,
      memory = max_memory
    )
  )

}