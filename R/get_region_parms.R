get_region_parms <- function(){
  if(!check_running()) stop("No GRASS session active. Program halted.")
  output <- execGRASS("g.region", flags = "p", intern = TRUE)
  split_output <- stringr::str_split(output, ":")
  list_output <- lapply(
    1:length(split_output), 
    function(x, y) gsub("  ", "", y[[x]][2]), 
    y = split_output
  )
  names(list_output) <- unlist(lapply(1:length(split_output), function(x, y) y[[x]][1], y = split_output))
  return(list_output)
}
