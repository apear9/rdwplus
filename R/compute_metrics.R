#' Compute spatially explicit watershed attributes
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
    
    # Get pour points / outlets as raster cells 
    coords_i <- sites@coords[i, 1:2]
    coords_i_out <- paste0("pour_point_", i, ".tif")
    coord_to_raster(coords_i, coords_i_out, TRUE)
    
    # Mask to this watershed for following operations
    set_mask(basename(current_watershed))
    
    # Compute iEDO weights
    
    if(any(metrics == "iEDO")){
      
      # Compute distance
      iEDO_distance <- "iEDO_distance"
      get_distance(coords_i_out, iEDO_distance, TRUE)
      
      # Compute inverse distance weight
      iEDO_weights_command <- paste0("wEDO = ( ", iEDO_distance, " + 1)^", idwp)
      rast_calc(iEDO_weights_command)
      
      # Compute iEDO metric
      iEDO_table <- paste0(tempdir(), "\\iEDO_table.csv")
      zonal_table("wEDO", landuse, iEDO_table)
      
      # Get result table
      iEDO_table <- read.csv(iEDO_table)
      
      # Extract out statistics
      sums <- iEDO_table$sum
      zone <- iEDO_table$zone
      
      # Insert iEDO metric for this row
      result_metrics[[lu_idx]]$iEDO[rowID] <- 100*sums[1]/sum(sums)
      
    }
    
    if(any(metrics == "iEDS")){
      
      # Compute distance
      iEDS_distance <- "iEDS_distance"
      get_distance(streams, iEDS_distance, TRUE)
      
      # Compute inverse distance weight
      iEDS_weights_command <- paste0("wEDO = ( ", iEDS_distance, " + 1)^", idwp)
      rast_calc(iEDS_weights_command)
      
      # Compute iEDS metric
      iEDS_table <- paste0(tempdir(), "\\iEDS_table.csv")
      zonal_table("wEDO", landuse, iEDS_table)
      
      # Get result table
      iEDS_table <- read.csv(iEDS_table)
      
      # Extract out statistics
      sums <- iEDS_table$sum
      zone <- iEDS_table$zone
      
      # Insert iEDS metric for this row
      result_metrics[[lu_idx]]$iEDS[rowID] <- 100*sums[1]/sum(sums)
      
    }
    
    # Compute iFLO weights
    if(any(c("HAiFLO", "iFLO") %in% metrics)){
      
      
      # Name for flow length raster
      current_flow_out <- paste0("flowlenOut_", rowID, ".tif")
      
      # Compute it
      get_flow_length(str_rast = streams, flow_dir = flow_dir, out = current_flowOut, to_outlet = TRUE, overwrite = TRUE)
      
      # Compute iFLO weights for real
      iFLO_weights_command <- paste0("wFLO = ( ", current_flow_out, " + 1)^", idwp)
      rast_calc(iFLO_weights_command)
      
    }
    
    # Compute iFLS weights
    if(any(c("HAiFLS", "iFLS") %in% metrics)){
      
      # Temporary file name
      current_flow_str <- paste0("flowlenOut_", rowID, ".tif")
      
      # Compute flow length
      get_flow_length(str_rast = streams, flow_dir = flow_dir, out = current_flowStr, to_outlet = FALSE, overwrite = TRUE)
      
      # Compute iFLS weights for real
      iFLS_weights_command <- paste0("wFLS = (", current_flow_str, " + 1)^", idwp)
      rast_calc(iFLS_weights_command)
      
    }
    
    # Compute iFLO metric in full if needed
    if(any(metrics == "iFLO")){
      
      # Compute table
      iFLO_table <- paste0(tempdir(), "\\iFLO_table.csv")
      zonal_table("iFLO", landuse, iFLO_table)
      
      # Get result table
      iFLO_table <- read.csv(iFLO_table)
      
      # Extract out statistics
      sums <- iFLO_table$sum
      zone <- iFLO_table$zone
      
      # Insert HAiFLO metric for this row
      result_metrics[[lu_idx]]$iFLO[rowID] <- 100*sums[1]/sum(sums)
      
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
  
  # Only while testing, return list immediately
  return(result_metrics)
  
}