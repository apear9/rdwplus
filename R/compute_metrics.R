#' Compute spatially explicit watershed land use percentages
#' @description Workhorse function for rdwplus. This function computes the spatially explicit landuse metrics in IDW-PLUS.
#' @param metrics A character vector. This vector specifies which metric(s) should be calculated. Your options are lumped, iFLO, iFLS, iEDO, iEDS, HAiFLO and HAiFLS. The default is to calculate all except for lumped, iEDO and iEDS.
#' @param landuse Names of landuse or landcover rasters in the current GRASS mapset for which spatially explicit watershed metrics should be computed.
#' @param fields A character vector giving the names of the new fields to be created in the sites' attribute table to store the land use metrics. The default is a combination of the metric names and land use raster names. 
#' @param sites A shapefile of sites; either a file path to the shapefile or a \code{SpatialPoints*} object.
#' @param elevation File name of a filled (hydrologically-conditioned) digital elevation model in the current GRASS mapset.
#' @param flow_dir A 'Deterministic 8' (D8) flow direction grid derived from \code{derive_flow}.
#' @param flow_acc File name of a flow accumulation grid derived from \code{derive_flow} in the current GRASS mapset.
#' @param streams File name of a streams raster in the current GRASS mapset. Optional if you are not asking for the iFLS, iEDS, and/or HAiFLS metrics.
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
  
  # Check sites, import as shapefile if it is not one already 
  if(!is_sppoints(sites)){sites <- shapefile(sites)}
  
  # Initialise empty list to store results
  # List structure:
  # Top level -- land use types [x length(landuse)]
  # Second level -- metrics [x length(metrics)]
  result_metrics <- vector("list", length(landuse))
  # Create lists for second level
  metrics_list <- vector("list", length(metrics))
  names(metrics_list) <- metrics
  # Loop to insert
  for(a in 1:length(result_metrics)){
    result_metrics[[a]] <- metrics_list
  }
  
  # Temporarily hard-coded
  # lu_idx integer index
  lu_idx <- 1
  
  for(rowID in 1:nrow(sites@data)){
    
    # Compute current site's watershed
    current_watershed <- paste0("watershed_", rowID, ".tif")
    get_watershed(sites, rowID, flow_dir, current_watershed, TRUE, TRUE)
    
    # Compute lumped metric if requested
    if(only(c("iEDO", "iEDS", "iFLO", "iFLS", "HAiFLO", "HAiFLS"), "lumped", metrics)){
      # Yet to come
      # Proper placement TBA
      invisible()
    }
    
    # Mask to this watershed for following operations
    set_mask(basename(current_watershed))
    
    # Compute iFLO weights
    if(any(c("HAiFLO", "iFLO") %in% metrics)){
      current_flowOut <- paste0("flowlenOut_", rowID, ".tif")
      
      get_flow_length(str_rast = streams, flow_dir = flow_dir, out = current_flowOut, to_outlet = T, overwrite = T)
      
      rast_calc(paste0("wFLO = ( ", current_flowOut, " + 1)^", idwp))
      
    }
    
    # Compute iFLS weights
    if(any(c("HAiFLS", "iFLS") %in% metrics)){
      
      current_flowStr <- paste0("flowlenOut_", rowID, ".tif")
      
      get_flow_length(str_rast = streams, flow_dir = flow_dir, out = current_flowStr, to_outlet = F, overwrite = T)
    
    }
    
    # Compute HAiFLO weights if needed
    if(any(metrics == "HAiFLO")){
      
      # Compute hydrologically active weights
      rast_calc(paste0("HA_iFLO = ( ", flow_acc, " + 1 )*wFLO"))
      
      # Compute zonal stats as table
      HA_iFLO_table <- paste0(tempdir(), "\\HA_iFLO_table.csv")
      zonal_table("HA_iFLO", landuse, HA_iFLO_table)
      
      # Get result table
      HA_iFLO_table <- read.csv(HA_iFLO_table)
      
      # Extract out statistics
      sums <- HA_iFLO_table$sum
      zone <- HA_iFLO_table$zone
      
      # Insert HAiFLO metric for this row
      result_metrics[[lu_idx]]$HAiFLO[rowID] <- 100*sums[1]/sum(sums)
      
    }
    
    # Remove mask
    clear_mask()
    
  }
  return(result_metrics)
}