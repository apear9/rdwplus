#' Import rasters into GRASS mapset
#' @description GRASS can only deal with raster and vector data in a GRASS mapset. This function takes external vectors and imports them into the current GRASS mapset.
#' @param vectors A character vector of filenames of shapefiles to import.
#' @param overwrite A logical indicating whether the overwrite flag should be used. Defaults to \code{FALSE}.
#' @param ... Additional arguments to \code{v.import}.
#' @return A vector of vector layer names in the GRASS mapset.
#' @export
vector_to_mapset <- function(vectors, overwrite = FALSE, ...){
  
  # Check that GRASS is running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  # Check how many rasters
  n_vector <- length(vectors)
  
  # Loop over rasters
  outs <- c()
  for(i in 1:n_vector){
    cur_name <- vectors[i]
    outs[i] <- out_name <- basename(cur_name)
    if(overwrite){
      execGRASS(
        "v.import",
        flags = "overwrite",
        parameters = list(
          input = cur_name,
          output = out_name,
          ...
        )
      )
    } else {
      execGRASS(
        "v.import",
        parameters = list(
          input = cur_name,
          output = out_name,
          ...
        )
      )
    }
    
  }
  
  # Return names
  outs
  
}