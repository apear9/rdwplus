#' Set a raster mask
#' @param x Raster to use as a mask
#' @param inverse Whether the inverse of the raster should be used as the mask. Defaults to \code{FALSE}.
#' @param overwrite Whether the existing mask should be overwritten. Defaults to \code{TRUE}.
#' @param ... Optional. Additional parameters for r.mask. 
#' @return Nothing.
#' @examples
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
set_mask <- function(x, inverse = FALSE, overwrite = TRUE, ...){
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  if(inverse) flags <- c(flags, "i")
  execGRASS(
    "r.mask",
    parameters = list(
      raster = x,
      ...
    )
  )
  
}