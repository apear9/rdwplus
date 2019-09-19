#' A function to snap sites in a shapefile to a stream network
#' @description This function takes a set of survey site locations and makes sure that they are coincident with the stream network dataset.
#' @param sites File name for a shapefile containing the locations of the survey sites in the current GRASS mapset.
#' @param flow_acc File name for a flow accumulation raster in the current GRASS mapset.
#' @param max_move The maximum distance in map units that any site can be moved to snap it to the flow accumulation grid.
#' @param out The output file path. 
#' @param overwrite Whether the output should be allowed to overwrite any existing files. Defaults to \code{FALSE}.
#' @param ... Additional arguments to \code{r.stream.snap}.
#' @return Nothing. Note that a shapefile of snapped survey sites will be written to the file \code{out} and a shapefile called \code{basename(out)} will be imported into the GRASS mapset.
#' @export 
snap_sites <- function(sites, flow_acc, max_move, out, overwrite = FALSE, ...){
  
  # Check if a GRASS session exists
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Call GRASS function
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  grass_out <- basename(out)
  grass_out <- gsub(".shp", "", grass_out)
  execGRASS(
    "r.stream.snap",
    flags = flags,
    parameters = list(
      input = sites,
      output = grass_out,
      accumulation = flow_acc,
      radius = max_move,
      ...
    )
  )
  
  # Retrieve vector
  retrieve_vector(grass_out, out, overwrite = overwrite)
  
  # Return nothing
  invisible()

}