#' Delineate watershed for a survey site
#' @description This function delineates a watershed around the \code{i}th site from a set of survey sites.
#' @param sites A file path to a shapefile of points or a \code{SpatialPoints*} object.
#' @param i An integer which indexes one row of the sites' attribute table.
#' @param flow_dir The name of a flow direction grid in the current GRASS mapset.
#' @param out The name of the output raster. A raster with the name \code{basename(out)} will be imported into the GRASS mapset. If \code{write_file} is true, then a file with the name \code{out} will be written into the user's current working directory.
#' @param write_file A logical indicating whether the output file should be stored as a file in the user's current working directory. Defaults to \code{FALSE}.
#' @param overwrite A logical indicating whether the output should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @param lessmem A logical indicating whether to use the less memory modified watershed module. Defaults to \code{FALSE}. 
#' @return Nothing. A raster file with the name \code{out} may be written to the current working directory and one with the name \code{basename(out)} will be imported into the current GRASS mapset. 
#' @export
get_watershed <- function(sites, i, flow_dir, out, write_file = FALSE, overwrite = FALSE, lessmem = FALSE){
  
  # Check whether GRASS running
  if(!check_running()) stop("There is no active GRASS session. Program halted.")
  
  # Check whether sites is a SpatialPoints
  if(!is_sppoints(sites)) sites <- shapefile(sites)
  
  # Get ith row of coordinate table 
  cds <- sites@coords[i,1:2] # sometimes the table will have three coordinates?

  # Get x and y
  x <- cds[1]
  y <- cds[2]
  
  # Define flags
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  
  if(!lessmem){
  # Execute GRASS command
  execGRASS(
    "r.water.outlet",
    flags = flags,
    parameters = list(
      input = flow_dir,
      output = basename(out),
      coordinates = c(x, y)
    )
  )} else {
    # Execute GRASS command 
    execGRASS(
      "r.wateroutlet.lessmem",
      flags = flags,
      parameters = list(
        input = flow_dir,
        output = basename(out),
        coordinates = c(x, y)))
  }
  
  # Export outside of mapset if requested
  if(write_file){
    retrieve_raster(
      basename(out),
      out, 
      overwrite
    )
  }
    
  invisible() 
}