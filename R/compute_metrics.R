#' Compute spatially explicit watershed land use percentages
#' @description Workhorse function for rdwplus. This function computes the spatially explicit landuse metrics in IDW-PLUS.
#' @param metrics A character vector. This vector specifies which metric(s) should be calculated. Your options are iFLO, iFLS, iEDO, iEDS, HAiFLO and HAiFLS. The default is to calculate all except for iEDO and iEDS.
#' @param landuse Pointer(s) to land use rasters for which the land use metrics should be computed.
#' @param fields A character vector giving the names of the new fields to be created in the sites' attribute table to store the land use metrics. The default is a combination of the metric names and land use raster names. 
#' @param sites Pointer to a shapefile of sites.
#' @param elevation A filled (flow-corrected) digital elevation model.
#' @param flow_dir A 'Deterministic 8' (D8) flow direction grid derived from \code{elevation}.
#' @param flow_acc A flow accumulation grid derived from \code{flow_dir}.
#' @param streams A pointer to a streams raster where non-stream cells are coded as 1 and stream cells are coded as NA / NoData. Optional if you are not asking for the iFLS, iEDS, and/or HAiFLS metrics.
#' @return A SpatialPointsDataFrame object, which is the \code{sites} argument with a modified attribute table. The table will contain the new land use metrics. 
#' @export
compute_metrics <- function(
  metrics = c("iFLO", "iFLS", "HAiFLO", "HAiFLS"),
  landuse,
  fields = paste(metrics, landuse, sep = "_"),
  sites,
  elevation,
  flow_dir,
  flow_acc,
  streams
){
  
  # Check inputs
  no_stream <- missing(streams)
  is_stream <- length(grep("S", metrics)) > 0
  if(no_stream & is_stream) stop("You need to provide a stream raster in order to compute either of the iFLS and HAiFLS metrics.")
  
  invisible()
  
}