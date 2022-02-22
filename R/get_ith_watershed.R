#' Delineate watershed for a survey site
#' @description This function delineates a watershed around the \code{i}-th site from a set of survey sites.
#' @param sites A set of sites in the current GRASS mapset.
#' @param i Which site should be used to delineate the watershed.
#' @param flow_dir The name of a flow direction grid in the current GRASS mapset.
#' @param out The name of the output raster. A raster with the name \code{basename(out)} will be imported into the GRASS mapset. If \code{write_file} is true, then a file with the name \code{out} will be written into the user's current working directory.
#' @param write_file A logical indicating whether the output file should be stored as a file in the user's current working directory. Defaults to \code{FALSE}.
#' @param overwrite A logical indicating whether the output should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @param lessmem A logical indicating whether to use the less memory modified watershed module. Defaults to \code{FALSE}. 
#' @return Nothing. A raster file with the name \code{out} may be written to file if you have set the \code{write_file} argument accordingly. A raster with the name \code{basename(out)} will be imported into the current GRASS mapset. 
#' @export
get_ith_watershed <- function(sites, i, flow_dir, out, write_file = FALSE, overwrite = FALSE, lessmem = FALSE){
  
  # Check whether GRASS running
  if(!check_running()) stop("There is no active GRASS session. Program halted.")
  
  # Retrieve sites and then read in as sf
  tmp_file <- paste0(tempfile(), ".shp")
  retrieve_vector(sites, tmp_file) # don't think it's necessary to set overwrite for a temp file
  sites_sf <- read_sf(tmp_file)
  
  # Get coordinates as df
  coord_sf <- st_coordinates(sites_sf)
  
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
        output = out,
        coordinates = coord_sf[i,]
      )
    )
  } else {
    # Execute GRASS command 
    execGRASS(
      "r.wateroutlet.lessmem",
      flags = flags,
      parameters = list(
        input = flow_dir,
        output = out,
        coordinates = coord_sf[i,]
      )
    )
  }
  
  
  invisible() 
}