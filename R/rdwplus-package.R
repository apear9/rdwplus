#' An Implementation of IDW-PLUS (Inverse Distance Weighted Percent Land Use for Streams) in R
#' 
#' Use R to call the hydrological toolboxes and functions in GRASS GIS to compute spatially explicit land-use metrics for stream survey sites. The package includes functions for preprocessing digital elevation and streams data, and one function to compute all the spatially explicit land use metrics described in Peterson et al. (2011) Freshwater Biology, 56(3), 590-610. 
#' 
#' @keywords internal 
"_PACKAGE"
#' @importFrom stars read_stars
#' @importFrom sf read_sf st_coordinates st_drop_geometry write_sf
#' @importFrom stringr str_split
#' @import rgrass
#' @importFrom methods is
#' @importFrom utils read.csv write.csv
NULL
## NULL