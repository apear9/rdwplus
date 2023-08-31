#' Delineate watersheds for survey sites
#' @description This function delineates watersheds around a set of survey sites.
#' @param sites A file path to a shapefile of points.
#' @param flow_dir The name of a flow direction grid in the current GRASS mapset.
#' @param out The names of the output watershed rasters. 
#' @param overwrite A logical indicating whether the output should be allowed to overwrite existing files. Defaults to \code{FALSE}.
#' @param lessmem A logical indicating whether to use the less memory modified watershed module. Defaults to \code{FALSE}. If set to \code{TRUE}, the \code{r.wateroutlet.lessmem} extension module must be installed. It can be installed using the GRASS GUI.
#' @return Nothing. A raster file with the name \code{out} may be written to file if you have set the \code{write_file} argument accordingly. A raster with the name \code{basename(out)} will be imported into the current GRASS mapset. 
#' @examples
#' # Will only run if GRASS is running
#' if(check_running()){
#' # Retrieve paths to data sets
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' lus <- system.file("extdata", "landuse.tif", package = "rdwplus")
#' sts <- system.file("extdata", "site.shp", package = "rdwplus")
#' stm <- system.file("extdata", "streams.shp", package = "rdwplus")
#' 
#' # Set environment
#' set_envir(dem)
#' 
#' # Get other data sets (stream layer, sites, land use, etc.)
#' raster_to_mapset(lus)
#' vector_to_mapset(c(stm, sts))
#' 
#' # Reclassify streams
#' out_stream <- paste0(tempdir(), "/streams.tif")
#' rasterise_stream("streams", out_stream, TRUE)
#' reclassify_streams("streams.tif", "streams01.tif", overwrite = TRUE)
#' 
#' # Burn in the streams to the DEM
#' burn_in("dem.tif", "streams01.tif", "burndem.tif", overwrite = TRUE)
#' 
#' # Fill dem
#' fill_sinks("burndem.tif", "filldem.tif", "fd1.tif", "sinks.tif", overwrite = TRUE)
#' 
#' # Derive flow direction and accumulation grids
#' derive_flow("dem.tif", "fd.tif", "fa.tif", overwrite = T)
#' 
#' # Derive a new stream raster from the FA grid
#' derive_streams("dem.tif", "fa.tif", "new_stm.tif", "new_stm", min_acc = 200, overwrite = T)
#' 
#' # Recode streams
#' reclassify_streams("new_stm.tif", "null_stm.tif", "none")
#' 
#' # Snap sites to streams and flow accumulation
#' snap_sites("site", "new_stm.tif", "fa.tif", 2, "snapsite", T)
#' 
#' # Get watersheds
#' get_watersheds("snapsite", "fd.tif", "wshed.tif", T)
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
      outname_i <- out[i]
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
      outname_i <- out[i]
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