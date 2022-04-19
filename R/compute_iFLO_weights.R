#' Compute iFLO weights
#' @description Compute an iFLO weight raster outside of the \code{compute_metrics()} function.
#' @param pp Pour point raster containing a single pour point (i.e., the outlet).
#' @param null_streams A streams raster with NoData for the stream cells and 1s everywhere else
#' @param fd A flow direction raster.
#' @param out_flow_length Name of the output flow length raster.
#' @param out_no_stream Name of the output flow length raster with streams removed (ignored if \code{remove_streams = FALSE}).
#' @param out_iFLO Name of the output weights raster.
#' @param idwp An inverse distance weighting power. This should be negative. The value \code{idwp = -1} is the default.
#' @param remove_streams A logical indicating whether cells corresponding to the stream line should be removed from the weights raster. Defaults to \code{FALSE}.
#' @return Nothing.
#' @export
compute_iFLO_weights <- function(pp, null_streams, fd, out_flow_length, out_no_stream, out_iFLO, idwp = -1, remove_streams = FALSE, ...){
  # pp - pour point as rasterised x-y coordinate
  # null_streams - streams raster with NoData for the stream cells and 1s everywhere else
  # fd - flow direction grid
  # idwp - inverse distance weighting power
  # remove streams - whether stream cells should be removed
  # out_flow_length - name of distance raster
  # out_no_stream - name of distance raster without outlet, redundant if remove_streams is FALSE
  # out_iFLO - name of output weights raster
  
  # Flow lengths
  get_flow_length(str_rast = pp, flow_dir = flow_dir, out = out_flow_length, to_outlet = TRUE, ...)
  
  # Remove outlet cell if necessary
  if(remove_streams){
    subtract_streams_command <- paste0(out_no_stream, " = ", out_flow_length, " * ", null_streams)
    rast_calc(subtract_streams_command)
  } else {
    out_no_stream <- out_flow_length
  }
  
  # iFLO weights
  iFLO_weights_command <- paste0(out_iFLO, " = ( ", out_no_stream, " + 1)^", idwp)
  
  # Output line
  rast_calc(iFLO_weights_command)
  
}