compute_iFLS_weights <- function(fd, stream, null_stream, out1, out2, out3, ...){
  # fd - flow direction grid
  # stream - stream grid with NoData for non-stream cells
  # null_stream - stream grid with NoData for the stream cells
  # out1, out2, out3 - various output names
  
  # Compute flow length
  get_flow_length(str_rast = stream, flow_dir = fd, out = out1, to_outlet = FALSE, ...)
  subtract_streams_command <- paste0(out2, " = ", out1, " * ", null_stream)
  rast_calc(subtract_streams_command)
  
  # Compute iFLS weights for real
  iFLS_weights_command <- paste0(out3, " = (", out2, " + 1)^", idwp)
  rast_calc(iFLS_weights_command)
  
}