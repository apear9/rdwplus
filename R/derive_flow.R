#' Obtain flow direction and accumulation over a digital elevation model (DEM)
#' @description This function computes flow direction and accumulation (among other things) from a DEM. This is done using the \code{r.watershed} tool in GRASS.
#' @param dem A digital elevation model that has been hydrologically corrected.
#' @param flow_dir The name of the output flow direction file in the current GRASS mapset.
#' @param flow_acc The name of the output flow accumulation file in the current GRASS mapset.
#' @param d8  A logical indicating whether D8 flow direction should be used. If \code{FALSE}, multiple flow direction is allowed. Defaults to \code{TRUE}.
#' @param overwrite A logical indicating whether any of the outputs should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @param max_memory Max memory used in memory swap mode (MB). Defaults to \code{300}.
#' @param ... Additional arguments to \code{r.watershed}. 
#' @return Nothing. Files are written in the current GRASS mapset.
#' @examples
#' if(check_running()){
#' # Load data set
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' stream_shp <- system.file("extdata", "streams.shp", package = "rdwplus")
#' 
#' # Set environment parameters and import data to GRASS
#' set_envir(dem)
#' vector_to_mapset(vectors = c(stream_shp))
#' 
#' # Create binary stream
#' out_name <- paste0(tempdir(), "/streams_rast.tif")
#' rasterise_stream("streams", out_name, overwrite = TRUE)
#' reclassify_streams("streams_rast.tif", "streams_binary.tif", 
#' out_type = "binary", overwrite = TRUE)
#' 
#' # Burn dem 
#' burn_in(dem = "dem.tif", stream = "streams_binary.tif", out = "dem_burn.tif",
#'  burn = 10, overwrite = TRUE)
#' 
#' # Fill sinks
#' fill_sinks(dem = "dem_burn.tif", out_dem =  "dem_fill.tif", out_fd = "fd1.tif", overwrite = TRUE)
#' 
#' # Derive flow accumulation and direction grids
#' derive_flow(dem = "dem_fill.tif", 
#' flow_dir = "fdir.tif", 
#' flow_acc = "facc.tif", 
#' overwrite = TRUE)
#' 
#' # Plot
#' plot_GRASS("fdir.tif", col = topo.colors(6))
#' plot_GRASS("facc.tif", col = topo.colors(6))
#' }
#' @export
derive_flow <- function(dem, flow_dir, flow_acc, d8 = TRUE, overwrite = FALSE, max_memory = 300, ...){
  
  # Check that grass is running
  running <- check_running()
  if(!running) stop("No active GRASS session. Program halted.")
  
  # Use the following flags 
  flags <- c("a") # forces all flow accumulations to be positive
  if(d8){
    flags <- c(flags, "s")
  }
  if(overwrite){
    flags <- c(flags, "overwrite")
  }
  
  # Otherwise proceed
  execGRASS(
    "r.watershed",
    flags = flags,
    parameters = list(
      elevation = dem,
      drainage = flow_dir,
      accumulation = flow_acc,
      memory = max_memory
    )
  )
  
  # Return nothing
  invisible()
}