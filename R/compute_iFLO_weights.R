#' Compute iFLO weights
#' @description Compute an iFLO weight raster outside of the \code{compute_metrics()} function.
#' @param pour_point Pour point raster containing a single pour point (i.e., the outlet).
#' @param watershed Watershed raster to use as a mask for the flow-path calculations.
#' @param null_streams A streams raster with NoData for the stream cells and 1s everywhere else
#' @param flow_dir A flow direction raster.
#' @param out_flow_length Name of the output flow length raster.
#' @param out_iFLO Name of the output weights raster.
#' @param out_iFLO_no_stream Name of the output weights raster excluding cells on the stream line (ignored inf \code{remove_streams = FALSE}). 
#' @param idwp An inverse distance weighting power. This should be negative. The value \code{idwp = -1} is the default.
#' @param remove_streams A logical indicating whether cells corresponding to the stream line should be removed from the weights raster. Defaults to \code{FALSE}.
#' @param ... Optional extra arguments to \code{get_flow_length()}.
#' @return Nothing.
#' @examples 
#' if(check_running()){
#' # Retrieve paths to data sets
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' lus <- system.file("extdata", "landuse.tif", package = "rdwplus")
#' sts <- system.file("extdata", "site.shp", package = "rdwplus")
#' stm <- system.file("extdata", "streams.shp", package = "rdwplus")
#' 
#' # Set environment
#' set_envir(dem)
#' 
#' # Get other data sets (stream layer, sites, land use, etc.)
#' raster_to_mapset(lus)
#' vector_to_mapset(c(stm, sts))
#' 
#' # Reclassify streams
#' out_stream <- paste0(tempdir(), "/streams.tif")
#' rasterise_stream("streams", out_stream, TRUE)
#' reclassify_streams("streams.tif", "streams01.tif", overwrite = TRUE)
#' 
#' # Burn in the streams to the DEM
#' burn_in("dem.tif", "streams01.tif", "burndem.tif", overwrite = TRUE)
#' 
#' # Fill dem
#' fill_sinks("burndem.tif", "filldem.tif", "fd1.tif", "sinks.tif", overwrite = TRUE)
#' 
#' # Derive flow direction and accumulation grids
#' derive_flow("dem.tif", "fd.tif", "fa.tif", overwrite = T)
#' 
#' # Derive a new stream raster from the FA grid
#' derive_streams("dem.tif", "fa.tif", "new_stm.tif", "new_stm", min_acc = 200, overwrite = T)
#' 
#' # Recode streams
#' reclassify_streams("new_stm.tif", "null_stm.tif", "none")
#' 
#' # Snap sites to streams and flow accumulation
#' snap_sites("site", "new_stm.tif", "fa.tif", 2, "snapsite", T)
#' 
#' # Get watersheds
#' get_watersheds("snapsite", "fd.tif", "wshed.tif", T)
#' 
#' #  Get pour points
#' coord_to_raster("snapsite", which = 1, out = "pour_point")
#' 
#' # Get iFLO weights
#' compute_iFLO_weights(
#' "pour_point", 
#' "wshed.tif", 
#' "null_stm.tif", 
#' "fd.tif", 
#' "fl_outlet.tif", 
#' "iFLO_weights.tif", 
#' idwp = -1, 
#' remove_streams = FALSE
#' )
#' plot_GRASS("iFLO_weights.tif", col = topo.colors(12))
#' }
#' @export
compute_iFLO_weights <- function(pour_point, watershed, null_streams, flow_dir, out_flow_length, out_iFLO, out_iFLO_no_stream, idwp = -1, remove_streams = FALSE, ...){

  # Set mask
  set_mask(watershed)
  
  # Clear mask on exit
  on.exit(clear_mask())
  
  # Get cell resolution
  resolution <- as.numeric(get_region_parms()$ewres)
    
  # Flow lengths
  get_flow_length(str_rast = pour_point, flow_dir = flow_dir, out = out_flow_length, to_outlet = TRUE, ...)

  # Remove stream cells if necessary
  if(remove_streams){
    subtract_streams_command <- paste0(out_iFLO_no_stream, " = (", out_flow_length, " * ", null_streams, " + 1 - ", resolution, ")^", idwp)
    rast_calc(subtract_streams_command)
  } 
  
  # iFLO weights
  iFLO_weights_command <- paste0(out_iFLO, " = ( ", out_flow_length, " + 1)^", idwp)
  rast_calc(iFLO_weights_command)
    
  # No output
  invisible()

}