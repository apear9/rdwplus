#' Import rasters into GRASS mapset
#' @description GRASS can only deal with raster and vector data in a GRASS mapset. This function takes external rasters and imports them into the current GRASS mapset.
#' @param rasters A character vector of filenames of rasters to import.
#' @param as_integer A logical vector indicating whether each raster should be imported strictly in integer format. Defaults to \code{FALSE}.
#' @param overwrite A logical indicating whether the overwrite flag should be used. If \code{FALSE}, then the corresponding raster is allowed to retain its original format. Defaults to \code{FALSE}. May cause value truncation if improperly used.
#' @param ... Additional arguments to \code{r.import}.
#' @return A vector of raster layer names in the GRASS mapset.
#' @export
raster_to_mapset <- function(rasters, as_integer = rep(FALSE, length(rasters)), overwrite = FALSE, ...){
  
  # Check that GRASS is running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Check how many rasters
  n_raster <- length(rasters)
  n_integs <- length(as_integer)
  if(n_raster != n_integs) stop("Please supply one as_integer logical for each raster.")
  
  # Check ovewrite setting
  flags <- "quiet"
  if(overwrite) flags <- c(flags, "overwrite")
  
  # Loop over rasters
  outs <- c()
  for(i in 1:n_raster){
    cur_name <- rasters[i]
    outs[i] <- out_name <- basename(cur_name)
    if(as_integer[i]) out_name <- paste0("tmp_", out_name)
    execGRASS(
      "r.import",
      flags = flags,
      parameters = list(
        input = cur_name,
        output = out_name,
        ...
      )
    )
    if(as_integer[i]){
      command <- paste0(outs[i], " = int(", out_name, ")")
      rast_calc(command)
    }
  }
  
  # Return names of mapset objects
  outs
  
}