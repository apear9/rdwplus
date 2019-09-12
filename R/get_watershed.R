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
  invisible() 
}