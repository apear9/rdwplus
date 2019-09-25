#' Import rasters into GRASS mapset
#' @description GRASS can only deal with raster and vector data in a GRASS mapset. This function takes external rasters and imports them into the current GRASS mapset.
#' @param rasters A character vector of filenames of rasters to import.
#' @param overwrite A logical indicating whether the overwrite flag should be used. Defaults to \code{FALSE}.
#' @param ... Additional arguments to \code{r.import}.
#' @return A vector of raster layer names in the GRASS mapset.
#' @export
raster_to_mapset <- function(rasters, overwrite = FALSE, ...){
  
  # Check that GRASS is running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Check how many rasters
  n_raster <- length(rasters)
  
  # Check ovewrite setting
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  
  # Loop over rasters
  outs <- c()
  for(i in 1:n_raster){
    cur_name <- rasters[i]
    outs[i] <- out_name <- basename(cur_name)
    execGRASS(
      "r.import",
      flags = flags,
      parameters = list(
        input = cur_name,
        output = out_name,
        ...
      )
    )
  }
  
  # Return names of mapset objects
  outs
  
}