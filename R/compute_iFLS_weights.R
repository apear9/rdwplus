#' Compute iFLS weights
#' @description Compute an iFLO weight raster outside of the \code{compute_metrics()} function.
#' @param streams Pour point raster containing a single pour point (i.e., the outlet).
#' @param null_streams A streams raster with NoData for the stream cells and 1s everywhere else
#' @param flow_dir A flow direction raster.
#' @param out_flow_length Name of the output flow length raster.
#' @param out_iFLS Name of the output weights raster.
#' @param out_iFLS_no_stream Name of the output weights raster excluding cells on the stream line (ignored inf \code{remove_streams = FALSE}). 
#' @param watershed Watershed raster to use as a mask for the flow-path calculations. This is optional for the iFLS weight calculations.
#' @param idwp An inverse distance weighting power. This should be negative. The value \code{idwp = -1} is the default.
#' @param remove_streams A logical indicating whether cells corresponding to the stream line should be removed from the weights raster. Defaults to \code{FALSE}.
#' @param ... Optional extra arguments to \code{get_flow_length()}.
#' @return Nothing.
#' @export
compute_iFLS_weights <- function(streams, null_streams, flow_dir, out_flow_length, out_iFLS, out_iFLS_no_stream, watershed, idwp, remove_streams, ...){
  
  # Set mask if watershed arg is given
  if(!missing(watershed)){
    
    # Set mask
    set_mask(watershed)
    
    # Clear mask on exit
    on.exit(clear_mask())
    
  }
  
  # Get cell resolution
  resolution <- as.numeric(get_region_parms()$ewres)
  
  # Flow lengths
  get_flow_length(str_rast = streams, flow_dir = flow_dir, out = out_flow_length, to_outlet = FALSE, ...)
  
  # Remove stream cells if necessary
  if(remove_streams){
    subtract_streams_command <- paste0(out_iFLS_no_stream, " = (", out_flow_length, " * ", null_streams, " + 1 - ", resolution, ")^", idwp)
    rast_calc(subtract_streams_command)
  } 
  
  # iFLO weights
  iFLS_weights_command <- paste0(out_iFLS, " = ( ", out_flow_length, " + 1)^", idwp)
  rast_calc(iFLS_weights_command)
  
  # No output
  invisible()
  
}