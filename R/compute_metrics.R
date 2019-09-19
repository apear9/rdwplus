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
#' @param idwp The inverse distance weighting parameter. Default is \code{-1}.
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
  streams,
  idwp = -1
){
  
  # Check inputs
  no_stream <- missing(streams)
  is_stream <- length(grep("S", metrics)) > 0
  if(no_stream & is_stream) stop("You need to provide a stream raster in order to compute either of the iFLS and HAiFLS metrics.")
  
  result_metrics <- vector("list",length(landuse))
  # lu_idx integer index
  lu_idx <- 1
  
  for(rowID in 1:nrow(sites@data)){
    
    current_watershed <- paste0("watershed_", rowID, ".tif")
    
    get_watershed(sites, rowID, flow_dir, current_watershed, TRUE, TRUE)
    
    if(any(c("HAiFLO", "iFLO") %in% metrics)){
      current_flowOut <- paste0("flowlenOut_", rowID, ".tif")
      get_flow_length(str_rast = streams, flow_dir = flow_dir, out = current_flowOut, to_outlet = T)
      
      execGRASS("r.mapcalc", 
                flags = flags,
                parameters = list(
                  expression = "wFLO = (current_flowOut + 1)^idwp"
                )
      )
    }
    if(any(c("HAiFLS", "iFLS") %in% metrics)){
      current_flowStr <- paste0("flowlenOut_", rowID, ".tif")
      get_flow_length(str_rast = streams, flow_dir = flow_dir, out = current_flowStr, to_outlet = F)
    }
    
    if(any(metrics == "HAiFLO")){
      execGRASS("r.mapcalc", 
                flags = flags,
                parameters = list(
                  expression = "HA_iFLO = (flow_acc + 1)*wFLO"
                )
      )
      
      HA_iFLO_table <- "HA_iFLO_table.csv"
      
      execGRASS("r.univar",
                flags = flags,
                parameters = list(
                  map = "HA_iFLO", 
                  zones = landuse, 
                  output = HA_iFLO_table, 
                  separator = "comma"
                )
      )
      
      HA_iFLO_table <- read.csv(HA_iFLO_table)
      
      result_metrics[[lu_idx]]$HA_iFLO[rowID] <- 100*HA_iFLO_table[HA_iFLO_table$zone == "1", "sum"]/
        (HA_iFLO_table[HA_iFLO_table$zone == "1", "sum"] + HA_iFLO_table[HA_iFLO_table$zone == "0", "sum"])
      
      
      
    }
    
    
    
    
  }
  return(result_metrics)
}