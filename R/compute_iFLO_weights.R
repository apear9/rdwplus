#' Compute iFLO weights
#' @description Compute an iFLO weight raster outside of the \code{compute_metrics()} function.
#' @param pour_point Pour point raster containing a single pour point (i.e., the outlet).
#' @param watershed Watershed raster to use as a mask for the flow-path calculations.
#' @param null_streams A streams raster with NoData for the stream cells and 1s everywhere else
#' @param fd A flow direction raster.
#' @param out_flow_length Name of the output flow length raster.
#' @param out_iFLO Name of the output weights raster.
#' @param out_iFLO_no_stream Name of the output weights raster excluding cells on the stream line (ignored inf \code{remove_streams = FALSE}). 
#' @param idwp An inverse distance weighting power. This should be negative. The value \code{idwp = -1} is the default.
#' @param remove_streams A logical indicating whether cells corresponding to the stream line should be removed from the weights raster. Defaults to \code{FALSE}.
#' @return Nothing.
#' @export
compute_iFLO_weights <- function(pour_point, watershed, null_streams, fd, out_flow_length, out_iFLO, out_iFLO_no_stream, idwp = -1, remove_streams = FALSE, ...){

  # Set mask
  set_mask(watershed)
  
  # Clear mask on exit
  on.exit(clear_mask())
    
  # Flow lengths
  get_flow_length(str_rast = pour_point, flow_dir = flow_dir, out = out_flow_length, to_outlet = TRUE, ...)

  # iFLO weights
  iFLO_weights_command <- paste0(out_iFLO, " = ( ", out_flow_length, " + 1)^", idwp)
  rast_calc(iFLO_weights_command)
    
  # Remove stream cells if necessary
  if(remove_streams){
    subtract_streams_command <- paste0(out_iFLO_no_stream, " = ", out_iFLO, " * ", null_streams)
    rast_calc(subtract_streams_command)
  } 
  
  # No output
  invisible()

  
}