#' Delineate watershed for a survey site
#' @description This function delineates a watershed around the \code{i}th site from a set of survey sites.
#' @param sites A \code{SpatialPoints*} object.
#' @param i An integer which indexes one row of the sites' attribute table.
#' @param dem Pointer to a hydrologically-corrected digital elevation model.
#' @param out The name of the output file, with NO file extension.
#' @param R A logical indicating whether a RasterLayer should be returned in R. Defaults to \code{TRUE}.
#' @return A SAGA raster with basename \code{out}. Possibly also a \code{RasterLayer} object. 
#' @export
get_watershed <- function(sites, i, dem, out, R = TRUE){
  
  # Site coordinates
  coords <- sites@coords
  xi <- coords[i, 1]
  yi <- coords[i, 2]
  # Watershed processor
  rsaga.geoprocessor(
    "ta_hydrology", 
    4, 
    param = list(
      # Assumes the pour point is EXACT
      TARGET_PT_X = xi,
      TARGET_PT_Y = yi,
      ELEVATION = dem,
      AREA = paste0(out, ".sgrd"),
      METHOD = "Deterministic 8"
    )
  )
  
  # Return if needed
  if(R){
    raster(paste0(out, ".sdat"))
  } else {
    invisible()
  }
  
}