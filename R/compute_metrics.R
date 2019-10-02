#' Compute spatially explicit watershed attributes
#' @description Workhorse function for rdwplus. This function computes the spatially explicit landuse metrics in IDW-PLUS.
#' @param metrics A character vector. This vector specifies which metric(s) should be calculated. Your options are lumped, iFLO, iFLS, iEDO, iEDS, HAiFLO and HAiFLS. The default is to calculate all except for lumped, iEDO and iEDS.
#' @param landuse Names of landuse or landcover rasters in the current GRASS mapset for which spatially explicit watershed metrics should be computed.
#' @param sites A shapefile of sites; either a file path to the shapefile or a \code{SpatialPoints*} object.
#' @param elevation File name of a filled (hydrologically-conditioned) digital elevation model in the current GRASS mapset.
#' @param flow_dir A 'Deterministic 8' (D8) flow direction grid derived from \code{derive_flow}.
#' @param flow_acc File name of a flow accumulation grid derived from \code{derive_flow} in the current GRASS mapset.
#' @param streams File name of a streams raster in the current GRASS mapset. Optional if you are not asking for the iFLS, iEDS, and/or HAiFLS metrics.
#' @param idwp The inverse distance weighting parameter. Default is \code{-1}.
#' @param max_memory Max memory used in memory swap mode (MB). Defaults to \code{300}.
#' @param lessmem A logical indicating whether to use the less memory modified watershed module. Defaults to \code{FALSE}. 
#' @return A SpatialPointsDataFrame object, which is the \code{sites} argument with a modified attribute table. The table will contain the new land use metrics. 
#' @export
compute_metrics <- function(
  metrics = c("iFLO", "iFLS", "HAiFLO", "HAiFLS"),
  landuse,
  sites,
  elevation,
  flow_dir,
  flow_acc,
  streams,
  idwp = -1, 
  max_memory = 300,
  lessmem = FALSE
){
  
  # Check inputs
  no_stream <- missing(streams)
  is_stream <- length(grep("S", metrics)) > 0
  if(no_stream & is_stream) stop("You need to provide a stream raster in order to compute either of the iFLS and HAiFLS metrics.")
  
  # Check sites, import as shapefile if it is not one already 
  if(!is_sppoints(sites)) sites <- shapefile(sites)
  
  # Derive null streams if any metrics require it
  if(is_stream){
    # Retrieve the streams and reclassify them
    streams_convert <- paste(paste0("stream", sample(0:9, 5, TRUE)), collapse = "")
    streams_convert <- paste0(tempdir(), "/", streams_convert, ".tif")
    retrieve_raster(streams, streams_convert, overwrite = TRUE)
    # Generate random name to minimise risk of overwriting anything important
    rand_name <- paste(paste0(sample(letters, 5, TRUE), sample(0:9, 5, TRUE)), collapse = "")
    rand_name <- paste0(tempdir(), "/", rand_name, ".tif")
    # Create streams raster with null in stream
    reclassify_streams(streams_convert, rand_name, "none", TRUE, max_memory = max_memory)
    rand_name <- basename(rand_name)
  }
  
  # Initialise empty list to store results
  # List structure:
  # Top level -- land use types [x length(landuse)]
  # Second level -- metrics [x length(metrics)]
  result_metrics <- vector("list", length(landuse))
  names(result_metrics) <- basename(landuse)
  # Create lists for second level
  metrics_list <- vector("list", length(metrics))
  names(metrics_list) <- metrics
  # Loop to insert
  for(a in 1:length(result_metrics)){
    result_metrics[[a]] <- metrics_list
  }
  
  # Main loop for metric computation per site
  for(rowID in 1:nrow(sites@data)){
    
    # # Just to be safe. Like really really safe.
    # # It can lead to problems if mask from last iteration still on. 
    # clear_mask()
    
    # Compute current site's watershed
    current_watershed <- paste0("watershed_", rowID, ".tif")
    get_watershed(sites, rowID, flow_dir, current_watershed, FALSE, TRUE, lessmem = lessmem)
    
    # Compute lumped metric if requested
    if(any(metrics == "lumped")){
      
      # Compute stat in loop over land use
      for(lu_idx in 1:length(landuse)){
        
        # Compute numbers of cells in and out of landuse
        lumped_table <- paste0(tempdir(), "/lumped_table.csv")
        zonal_table(current_watershed, landuse[lu_idx], lumped_table)
        
        # Import table
        lumped_table <- read.csv(lumped_table)
        
        # Compute statistics
        counts <- lumped_table$non_null_cells
        zone <- lumped_table$zone
        result_metrics[[lu_idx]]$lumped[rowID] <- 100 * (1 - counts[1]/sum(counts))
        
      }
      
      
    }
    
    # Get pour points / outlets as raster cells 
    coords_i <- sites@coords[rowID, 1:2]
    coords_i_out <- paste0("pour_point_", rowID)
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
      
      # Compute iEDO metric by looping over land use rasters
      for(lu_idx in 1:length(landuse)){
        
        # Compute table of statistics
        iEDO_table <- paste0(tempdir(), "/iEDO_table.csv")
        zonal_table("wEDO", landuse[lu_idx], iEDO_table)
        
        # Get result table
        iEDO_table <- read.csv(iEDO_table)
        
        # Extract out statistics
        sums <- iEDO_table$sum
        zone <- iEDO_table$zone
        
        # Insert iEDO metric for this row
        result_metrics[[lu_idx]]$iEDO[rowID] <- 100*(1 - sums[1]/sum(sums))
        
      }
      
    }
    
    if(any(metrics == "iEDS")){
      
      # Compute distance
      iEDS_distance <- "iEDS_distance"
      get_distance(streams, iEDS_distance, TRUE)
      
      # Take out the stream line
      subtract_streams_command <- paste0("iEDS_distanc2 = ", iEDS_distance, " * ", rand_name)
      rast_calc(subtract_streams_command)
      
      # Compute inverse distance weight
      iEDS_weights_command <- paste0("wEDS = (iEDS_distanc2 + 1)^", idwp)
      rast_calc(iEDS_weights_command)
      
      # Compute iEDS metric by looping over landuse rasters
      for(lu_idx in 1:length(landuse)){
        
        # Get table of statistics
        iEDS_table <- paste0(tempdir(), "/iEDS_table.csv")
        zonal_table("wEDS", landuse[lu_idx], iEDS_table)
        
        # Get result table
        iEDS_table <- read.csv(iEDS_table)
        
        # Extract out statistics
        sums <- iEDS_table$sum
        zone <- iEDS_table$zone
        
        # Insert iEDS metric for this row
        result_metrics[[lu_idx]]$iEDS[rowID] <- 100*(1 - sums[1]/sum(sums))
        
      }
      
    }
    
    # Compute iFLO weights
    if(any(c("HAiFLO", "iFLO") %in% metrics)){
      
      # Name for flow length raster
      current_flow_out <- paste0("flowlenOut_", rowID, ".tif")
      
      # Compute it
      get_flow_length(str_rast = coords_i_out, flow_dir = flow_dir, out = current_flow_out, to_outlet = TRUE, overwrite = TRUE, max_memory = max_memory)
      
      # Compute iFLO weights for real
      iFLO_weights_command <- paste0("wFLO = ( ", current_flow_out, " + 1)^", idwp)
      rast_calc(iFLO_weights_command)
      
    }
    
    # Compute iFLS weights
    if(any(c("HAiFLS", "iFLS") %in% metrics)){
      
      # Temporary file name
      current_flow_str <- paste0("flow_str_", rowID, ".tif")
      
      # Compute flow length
      get_flow_length(str_rast = streams, flow_dir = flow_dir, out = current_flow_str, to_outlet = FALSE, overwrite = TRUE, max_memory = max_memory)
      subtract_streams_command <- paste0("current_flow_str2 = ", current_flow_str, " * ", rand_name)
      rast_calc(subtract_streams_command)
      
      # Compute iFLS weights for real
      iFLS_weights_command <- paste0("wFLS = (current_flow_str2 + 1)^", idwp)
      rast_calc(iFLS_weights_command)
      
    }
    
    # Compute iFLO metric in full if needed
    if(any(metrics == "iFLO")){
      
      for(lu_idx in 1:length(landuse)){
        
        # Compute table
        iFLO_table <- paste0(tempdir(), "/iFLO_table.csv")
        zonal_table("wFLO", landuse[lu_idx], iFLO_table)
        
        # Get result table
        iFLO_table <- read.csv(iFLO_table)
        
        # Extract out statistics
        sums <- iFLO_table$sum
        zone <- iFLO_table$zone
        
        # Insert HAiFLO metric for this row
        result_metrics[[lu_idx]]$iFLO[rowID] <- 100*(1 - sums[1]/sum(sums))
        
      }
      
    }
    
    # Compute iFLS metric in full if needed
    if(any(metrics == "iFLS")){
      
      # Loop over land use rasters to compute metrics
      for(lu_idx in 1:length(landuse)){
        
        # Compute table
        iFLS_table <- paste0(tempdir(), "/iFLS_table.csv")
        zonal_table("wFLS", landuse[lu_idx], iFLS_table)
        
        # Get result table
        iFLS_table <- read.csv(iFLS_table)
        
        # Extract out statistics
        sums <- iFLS_table$sum
        zone <- iFLS_table$zone
        
        # Insert HAiFLS metric for this row
        result_metrics[[lu_idx]]$iFLS[rowID] <- 100*(1 - sums[1]/sum(sums))
        
      }
      
    }
    
    # Compute HAiFLO weights if needed
    if(any(metrics == "HAiFLO")){
      
      # Compute hydrologically active weights
      rast_calc(paste0("HA_iFLO = ( ", flow_acc, " + 1 )*wFLO"))
      
      # Loop through land use rasters to compute HAiFLO metrics
      for(lu_idx in 1:length(landuse)){
        
        # Compute zonal stats as table
        HA_iFLO_table <- paste0(tempdir(), "/HA_iFLO_table.csv")
        zonal_table("HA_iFLO", landuse[lu_idx], HA_iFLO_table)
        
        # Get result table
        HA_iFLO_table <- read.csv(HA_iFLO_table)
        
        # Extract out statistics
        sums <- HA_iFLO_table$sum
        zone <- HA_iFLO_table$zone
        
        # Insert HAiFLO metric for this row
        result_metrics[[lu_idx]]$HAiFLO[rowID] <- 100*(1 - sums[1]/sum(sums))
        
      }
      
    }
    
    # Compute HAiFLS weights if needed
    if(any(metrics == "HAiFLS")){
      
      # Compute hydrologically active weights
      rast_calc(paste0("HA_iFLS = ( ", flow_acc, " + 1 )*wFLS"))
      
      # Loop through land use rasters to compute HAiFLS metrics
      for(lu_idx in 1:length(landuse)){
        
        # Compute zonal stats as table
        HA_iFLS_table <- paste0(tempdir(), "/HA_iFLS_table.csv")
        zonal_table("HA_iFLS", landuse[lu_idx], HA_iFLS_table)
        
        # Get result table
        HA_iFLS_table <- read.csv(HA_iFLS_table)
        
        # Extract out statistics
        sums <- HA_iFLS_table$sum
        zone <- HA_iFLS_table$zone
        
        # Insert HAiFLS metric for this row
        result_metrics[[lu_idx]]$HAiFLS[rowID] <- 100*(1 - sums[1]/sum(sums))
        
      }
      
    }
    
    # Remove mask
    clear_mask() 
    
  }
  
  # Create data frame with land use x metrics
  full_data <- matrix(
    as.numeric(rownames(sites@data)), 
    nrow(sites@data), 
    1
  )
  colnames(full_data) <- "ID"
  for(lu_idx in 1:length(landuse)){
    temp_data <- do.call(cbind, result_metrics[[lu_idx]])
    column_nm <- colnames(temp_data)
    to_attach <- delete_file_ext(landuse[lu_idx])
    colnames(temp_data) <- paste(column_nm, to_attach, sep = "_")
    full_data <- cbind(full_data, temp_data)
  }
  full_data <- as.data.frame(full_data)
  
  # Return data frame with site metrics immediately
  return(full_data)
  
}