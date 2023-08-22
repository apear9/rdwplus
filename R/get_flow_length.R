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
#' 
#' # Burn dem
#' burn_in(dem = "dem.tif", stream = "streams_binary.tif",
#'         out = "dem_burn.tif", burn = 10, overwrite = TRUE)
#' 
#' # Fill sinks
#' fill_sinks(dem = "dem_burn.tif", out_dem = "dem_fill.tif", out_fd = "fd1.tif", overwrite = TRUE)
#' 
#' # Derive flow accumulation and direction grids
#' derive_flow(dem = "dem_fill.tif", flow_dir = "fdir.tif",
#'             flow_acc = "facc.tif", overwrite = TRUE)
#' 
#' # Derive watershed
#' get_watersheds(sites = "site", flow_dir = "fdir.tif", out = "wshed.tif", overwrite = T)
#' 
#' # Set mask
#' set_mask("wshed.tif")
#' 
#' # Get flow length
#' get_flow_length(
#'   str_rast = "streams_rast.tif",
#'   flow_dir = "fdir.tif",
#'   out = "flowlength.tif",
#'   to_outlet = TRUE,
#'   overwrite = TRUE
#' )
#' 
#' # Plot
#' plot_GRASS("flowlength.tif", col = topo.colors(15))
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