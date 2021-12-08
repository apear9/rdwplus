#' Delineate watersheds for survey sites
#' @description This function delineates watersheds around a set of survey sites.
#' @param sites A file path to a shapefile of points or a \code{SpatialPoints*} object.
#' @param flow_dir The name of a flow direction grid in the current GRASS mapset.
#' @param out The base name of the output rasters. Watershed rasters with the name \code{basename(out)} will be imported into the GRASS mapset. If \code{write_file} is true, then a file with the name \code{out} will be written into the user's current working directory.
#' @param overwrite A logical indicating whether the output should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @param lessmem A logical indicating whether to use the less memory modified watershed module. Defaults to \code{FALSE}. If set to \code{TRUE}, the \code{r.wateroutlet.lessmem} extension module must be installed. It can be installed using the GRASS GUI.
#' @return Nothing. A raster file with the name \code{out} may be written to file if you have set the \code{write_file} argument accordingly. A raster with the name \code{basename(out)} will be imported into the current GRASS mapset. 
#' @examples
#' # Will only run if GRASS is running
#' if(check_running()){
#' }
#' @export
get_watersheds <- function(sites, flow_dir, out, overwrite = FALSE, lessmem = FALSE){
  
  # Check whether GRASS running
  if(!check_running()) stop("There is no active GRASS session. Program halted.")
  
  # Retrieve sites and then read in as sf
  tmp_file <- paste0(tempfile(), ".shp")
  retrieve_vector(sites, tmp_file) # don't think it's necessary to set overwrite for a temp file
  sites_sf <- read_sf(tmp_file)
  
  # Get coordinates as df
  coord_sf <- st_coordinates(sites_sf)
  n_sites <- nrow(coord_sf)
  
  # Define flags
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  
  if(!lessmem){
    for(i in 1:n_sites){
      # Out name
      outname_i <- insert_before_file_ext(basename(out), i)
      # Execute GRASS command
      execGRASS(
        "r.water.outlet",
        flags = flags,
        parameters = list(
          input = flow_dir,
          output = outname_i,
          coordinates = coord_sf[i,]
        )
      )
    }
  } else {
    for(i in 1:n_sites){
      # Out name
      outname_i <- insert_before_file_ext(basename(out), i)
      # Execute GRASS command 
      execGRASS(
        "r.wateroutlet.lessmem",
        flags = flags,
        parameters = list(
          input = flow_dir,
          output = outname_i,
          coordinates = coord_sf[i,]
        )
      )
    }
  }
  
  # Return nothing
  invisible() 
  
}