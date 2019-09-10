derive_flow <- function(){
  
  # Check that grass is running
  running <- check_running()
  if(!running) stop("No active GRASS session. Program halted.")
  
  # Otherwise proceed
  execGRASS()
  
  invisible()
}