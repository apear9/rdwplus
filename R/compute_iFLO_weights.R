compute_iFLO_weights <- function(pp, fd, idwp, out1, out2, ...){
  # pp -- pour point as x-y coordinate
  # fd -- flow direction grid
  
  # Flow lengths
  get_flow_length(str_rast = coords_i_out, flow_dir = flow_dir, out = out1, to_outlet = TRUE, ...)
  
  # iFLO weights
  iFLO_weights_command <- paste0(out2, " = ( ", out1, " + 1)^", idwp)
  
  # Output line
  rast_calc(iFLO_weights_command)
  
}