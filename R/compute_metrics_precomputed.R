#' Compute spatially explicit watershed attributes for survey sites on streams
#' @description Workhorse function for \code{rdwplus}. This function computes the spatially explicit landuse metrics in IDW-Plus (Peterson and Pearse, 2017). In contrast to \code{compute_metrics()}, this version of the function assumes most of the intermediate data layers (i.e., flow path distance and inverse-distance weight rasters) have been precomputed.
#' @param metrics A character vector. This vector specifies which metric(s) should be calculated. Your options are lumped, iFLO, iFLS, iEDO, iEDS, HAiFLO and HAiFLS. The default is to calculate the lumped, iFLO, iFLS, HAiFLO, and HAiFLS metrics.
#' @param landuse Names of landuse or landcover rasters in the current GRASS mapset. These can be continuous (e.g., percentage cover or NDVI) or binary, with a value of 1 for cells with a particular land use category and a value of 0 otherwise. 
#' @param sites A set of survey sites in the current GRASS mapset. 
#' @param out_fields A character vector of output field names to store the metrics. Note that \code{length(out_fields)} must be the same as \code{length(landuse) * length(metrics)}.
#' @param watersheds A vector of watershed raster names in the current GRASS mapset.
#' @param flow_dir Name of a flow direction raster produced by \code{derive_flow} in the current GRASS mapset.
#' @param flow_acc Name of a flow accumulation raster produced by \code{derive_flow} in the current GRASS mapset.
#' @param iEDO_weights A vector of names of iEDO weight rasters in the GRASS mapset.
#' @param iFLO_weights A vector of names of iFLO weight rasters in the GRASS mapset.
#' @param HAiFLO_weights A vector of names of HAiFLO weight rasters in the GRASS mapset.
#' @param iEDS_weights A vector of names of iEDS weight rasters in the GRASS mapset.
#' @param iFLS_weights A vector of names of iFLS weight rasters in the GRASS mapset.
#' @param HAiFLS_weights A vector of names of HAiFLS weight rasters in the GRASS mapset.
#' @param percentage A logical indicating whether the result should be expressed as a percentage. Defaults to \code{TRUE}. Set to \code{FALSE} if the landuse/landcover raster is continuous.
#' @param max_memory Max memory used in memory swap mode (MB). Defaults to \code{300}.
#' @return A \code{sf} object of the snapped survey sites that also contains the computed landscape metrics. 
#' @references 
#' Peterson, E.E. & Pearse, A.R. (2017). IDW-Plus: An ArcGIS toolset for calculating spatially explicit watershed attributes for survey sites. \emph{JAWRA}, \emph{53}(5), 1241-1249.  
#' @examples 
#' # Will only run if GRASS is running
#' # You should load rdwplus and initialise GRASS via the initGRASS function
#' if(check_running()){
#' Retrieve paths to data sets
#' dem <- system.file("extdata", "dem.tif", package = "rdwplus")
#' lus <- system.file("extdata", "landuse.tif", package = "rdwplus")
#' sts <- system.file("extdata", "site.shp", package = "rdwplus")
#' stm <- system.file("extdata", "streams.shp", package = "rdwplus")
#' 
#' # Set environment
#' set_envir(dem)
#' 
#' # Get other data sets (stream layer, sites, land use, etc.)
#' raster_to_mapset(lus)
#' vector_to_mapset(c(stm, sts))
#' 
#' # Reclassify streams
#' out_stream <- paste0(tempdir(), "/streams.tif")
#' rasterise_stream("streams", out_stream, TRUE)
#' reclassify_streams("streams.tif", "streams01.tif", overwrite = TRUE)
#' 
#' # Burn in the streams to the DEM
#' burn_in("dem.tif", "streams01.tif", "burndem.tif", overwrite = TRUE)
#' 
#' # Fill dem
#' fill_sinks("burndem.tif", "filldem.tif", "fd1.tif", "sinks.tif", overwrite = TRUE)
#' 
#' # Derive flow direction and accumulation grids
#' derive_flow("dem.tif", "fd.tif", "fa.tif", overwrite = T)
#' 
#' # Derive a new stream raster from the FA grid
#' derive_streams("dem.tif", "fa.tif", "new_stm.tif", "new_stm", min_acc = 200, overwrite = T)
#' 
#' # Recode streams
#' reclassify_streams("new_stm.tif", "null_stm.tif", "none")
#' 
#' # Snap sites to streams and flow accumulation
#' snap_sites("site", "new_stm.tif", "fa.tif", 2, "snapsite", T)
#' 
#' # Get watersheds
#' get_watersheds("snapsite", "fd.tif", "wshed.tif", T)
#' 
#' #  Get pour points
#' coord_to_raster("snapsite", which = 1, out = "pour_point")
#' 
#' # Get iFLO weights
#' compute_iFLO_weights("pour_point", "wshed.tif", "null_stm.tif", "fd.tif", "fl_outlet.tif", "iFLO_weights.tif", idwp = -1, remove_streams = FALSE)
#' 
#' # Get iFLS weights
#' compute_iFLS_weights("new_stm.tif", "null_stm.tif", "fd.tif", "fl_streams.tif", "iFLS_weights.tif", idwp = -1, watershed = "wshed.tif", remove_streams = FALSE, overwrite = T)
#' 
#' # Compute metrics for this site
#' compute_metrics_precomputed(
#'   metrics = c("iFLO", "iFLS"),
#'   landuse = "landuse.tif",
#'   sites = "snapsite",
#'   out_fields = c("iFLO", "iFLS"),
#'   watersheds = "wshed.tif",
#'   iFLO_weights = "iFLO_weights.tif",
#'   iFLS_weights = "iFLS_weights.tif",
#'   flow_dir = "fd.tif",
#'   flow_acc = "fa.tif"
#' )
#' }
#' @export
compute_metrics_precomputed <- function(
  metrics = c("lumped", "iFLO", "iFLS", "HAiFLO", "HAiFLS"),
  landuse,
  sites,
  out_fields,
  watersheds,
  flow_dir,
  flow_acc,
  iEDO_weights,
  iFLO_weights,
  HAiFLO_weights,
  iEDS_weights,
  iFLS_weights,
  HAiFLS_weights,
  percentage = TRUE,
  max_memory = 300
){
  
  # Clear mask if function throws error... this is the cause of the NaN issue
  on.exit(clear_mask())
  
  # Check inputs
  no_iEDO <- missing(iEDO_weights)
  no_iFLO <- missing(iFLO_weights)
  no_iEDS <- missing(iEDS_weights)
  no_iFLS <- missing(iFLS_weights)
  no_HAiFLO <- missing(HAiFLO_weights)
  no_HAiFLS <- missing(HAiFLS_weights)
  if(no_iEDO & ("iEDO" %in% metrics)) stop("iEDO_weights must be specified.")
  if(no_iFLO & ("iFLO" %in% metrics)) stop("iFLO_weights must be specified.")
  if(no_iEDS & ("iEDS" %in% metrics)) stop("iEDS_weights must be specified.")
  if(no_iFLS & ("iFLS" %in% metrics)) stop("iFLS_weights must be specified.")
  if(no_HAiFLO & ("HAiFLO" %in% metrics)) stop("HAiFLO_weights must be specified.")
  if(no_HAiFLS & ("HAiFLS" %in% metrics)) stop("HAiFLS_weights must be specified.")
  
  # no_stream <- missing(streams)
  # is_stream <- length(grep("S", metrics)) > 0
  # if(no_stream & is_stream) stop("You need to provide a stream raster in order to compute either of the iFLS and HAiFLS metrics.")
  
  # Check sites, import as sf  
  sites_tmp <- tempfile(fileext = ".shp")
  retrieve_vector(sites, sites_tmp)
  sites_sf <- read_sf(sites_tmp)
  
  # Get number of sites
  n_sites <- nrow(sites_sf)
  
  # # Check length of output fields
  # if(length(out_fields) != length(metrics) * length(landuse)) stop("Please enter the correct number of output fields.")
  
  # # Get coordinates
  # all_coordinates <- st_coordinates(sites_sf)
  # n_sites <- nrow(all_coordinates)
  
  # # Derive null streams if any metrics require it
  # if(is_stream & remove_streams){
  #   
  #   # Generate random name to minimise risk of overwriting anything important
  #   rand_name <- basename(paste0(tempfile(), ".tif"))
  #   
  #   # Create streams raster with null in stream
  #   reclassify_streams(streams, rand_name, "none", TRUE)
  #   
  #   # Print message
  #   message(paste0(Sys.time(), ": stream reclassification"))
  # 
  # }

  # Initialise empty list to store results
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
  for(rowID in 1:n_sites){
    
    # Print dialogue to user
    message(paste0(Sys.time(), ": rowID : ", rowID))
    
    # Get current watershed
    current_watershed <- watersheds[rowID]
    
    # Compute lumped metric if requested
    if(any(metrics == "lumped")){
      
      # Compute stat in loop over land use
      for(lu_idx in 1:length(landuse)){
        
        # Compute numbers of cells in and out of landuse
        lumped_table <- tempfile(fileext = ".csv")
        # zonal_table(current_watershed, landuse[lu_idx], lumped_table)
        zonal_table(landuse[lu_idx], current_watershed, lumped_table)
        
        # Import table
        lumped_table <- read.csv(lumped_table)
        
        # # Compute statistics
        # counts <- lumped_table$non_null_cells
        # zone <- lumped_table$zone
        # zonw <- which(zone == 1)
        # if(length(zone) > 1){
        #   result_metrics[[lu_idx]]$lumped[rowID] <- 100 * counts[zonw]/sum(counts)
        # } else {
        #   100 * zone # zone is either zero or 1, so this works 
        # }
        
        # Compute statistic as average
        result_metrics[[lu_idx]]$lumped[rowID] <- lumped_table$mean
        
      }
      
    }
    
    # Get pour points / outlets as raster cells 
    coords_i_out <- basename(tempfile())
    coord_to_raster(sites, rowID, coords_i_out, TRUE)
    
    # Mask to this watershed for following operations
    set_mask(basename(current_watershed))
    
    # Compute iEDO weights
    if(any(metrics == "iEDO")){
      
      # # Compute distance
      # iEDO_distance <- "iEDO_distance"
      # get_distance(coords_i_out, iEDO_distance, TRUE)
      # 
      # # Compute inverse distance weight
      # iEDO_weights_command <- paste0("wEDO = ( ", iEDO_distance, " + 1)^", idwp)
      # rast_calc(iEDO_weights_command)
      
      # Get weight for current iteration
      iEDO_weight <- iEDO_weights[rowID]
      
      # Compute iEDO metric by looping over land use rasters
      for(lu_idx in 1:length(landuse)){
        
        # Compute weight * land use
        iEDO_numerator_command <- paste0("iEDO_numerator = ,", iEDO_weight, " * ", landuse[lu_idx])
        rast_calc(iEDO_numerator_command)
        
        # Compute table of statistics
        iEDO_table <- tempfile(fileext = ".csv")
        iEDO_numerator_table <- tempfile(fileext = ".csv")
        zonal_table(iEDO_weight, watersheds[rowID], iEDO_table)
        zonal_table("iEDO_numerator", watersheds[rowID], iEDO_numerator_table)
        
        # Get result table
        iEDO_table <- read.csv(iEDO_table)
        iEDO_numerator_table <- read.csv(iEDO_numerator_table)
        
        # Extract out statistics
        denom <- iEDO_table$sum
        numer <- iEDO_numerator_table$sum
        
        # Get result
        result_metrics[[lu_idx]]$iEDO[rowID] <- numer/denom
        
      }
      
      # Print message
      message(paste0( Sys.time(), ": rowID : ", rowID, " : iEDO finished"))
    
    }
    
    if(any(metrics == "iEDS")){
      
      # # Compute distance
      # iEDS_distance <- "iEDS_distance"
      # get_distance(streams, iEDS_distance, TRUE)
      # 
      # # Take out the stream line
      # if(remove_streams){
      #   subtract_streams_command <- paste0("iEDS_distance = ", iEDS_distance, " * ", rand_name)
      #   rast_calc(subtract_streams_command)
      # } 
      
      # # Compute inverse distance weight
      # iEDS_weights_command <- paste0("wEDS = (iEDS_distance + 1)^", idwp)
      # rast_calc(iEDS_weights_command)
      
      iEDS_weight <- iEDS_weights[rowID]
      
      # Compute iEDS metric by looping over landuse rasters
      for(lu_idx in 1:length(landuse)){
        
        # Compute weight * landuse
        iEDS_numerator_command <- paste0("iEDS_numerator = ", iEDS_weight, " * ", landuse[lu_idx])
        rast_calc(iEDS_numerator_command)
        
        # Get table of statistics
        iEDS_table <- tempfile(fileext = ".csv")
        iEDS_numerator_table <- tempfile(fileext = ".csv")
        zonal_table(iEDS_weight, watersheds[rowID], iEDS_table)
        zonal_table("iEDS_numerator", watersheds[rowID], iEDS_numerator_table)
        
        # Get result table
        iEDS_table <- read.csv(iEDS_table)
        iEDS_numerator_table <- read.csv(iEDS_numerator_table)
        
        # Extract out statistics
        denom <- iEDS_table$sum
        numer <- iEDS_numerator_table$sum
        
        # Get result
        result_metrics[[lu_idx]]$iEDS[rowID] <- numer/denom
        
      }
      
      # Print message
      message(paste0(Sys.time(), ": rowID : ", rowID, " : iEDS finished"))
      
    }
    
    # # Compute iFLO weights
    # if(any(c("HAiFLO", "iFLO") %in% metrics)){
    #   
    #   # Name for flow length raster
    #   current_flow_out <- paste0("flowlenOut_", rowID, ".tif")
    #   
    #   # Compute it
    #   get_flow_length(str_rast = coords_i_out, flow_dir = flow_dir, out = current_flow_out, to_outlet = TRUE, overwrite = TRUE, max_memory = max_memory)
    #   
    #   # Compute iFLO weights for real
    #   iFLO_weights_command <- paste0("wFLO = ( ", current_flow_out, " + 1)^", idwp)
    #   rast_calc(iFLO_weights_command)
    #   
    #   # Print message
    #   message(paste0(Sys.time(), ": rowID : ", rowID, " : FLO weights finished"))
    #   
    # }
    # 
    # # Compute iFLS weights
    # if(any(c("HAiFLS", "iFLS") %in% metrics)){
    #   
    #   # Temporary file name
    #   current_flow_str <- paste0("flow_str_", rowID, ".tif")
    #   
    #   # Compute flow length
    #   get_flow_length(str_rast = streams, flow_dir = flow_dir, out = current_flow_str, to_outlet = FALSE, overwrite = TRUE, max_memory = max_memory)
    #   if(remove_streams){
    #     subtract_streams_command <- paste0(current_flow_str, " = ", current_flow_str, " * ", rand_name)
    #     rast_calc(subtract_streams_command)
    #   }
    #   
    #   # Compute iFLS weights for real
    #   iFLS_weights_command <- paste0("wFLS = (", current_flow_str, " + 1)^", idwp)
    #   rast_calc(iFLS_weights_command)
    #   message(paste0(Sys.time(), ": rowID : ", rowID, " : FLS weights finished"))
    #   
    # }
    
    # Compute iFLO metric in full if needed
    if(any(metrics == "iFLO")){
      
      # Get current iFLO weight
      iFLO_weight <- iFLO_weights[rowID]
      
      # Loop over land use rasters
      for(lu_idx in 1:length(landuse)){
        
        # Get iFLO * landuse
        iFLO_numerator_command <- paste0("iFLO_numerator = ", iFLO_weight, " * ", landuse[lu_idx])
        rast_calc(iFLO_numerator_command)
        
        # Compute table
        iFLO_table <- tempfile(fileext = ".csv")
        iFLO_numerator_table <- tempfile(fileext = ".csv")
        zonal_table(iFLO_weight, watersheds[rowID], iFLO_table)
        zonal_table("iFLO_numerator", watersheds[rowID], iFLO_numerator_table)
        
        # Get result table
        iFLO_table <- read.csv(iFLO_table)
        iFLO_numerator_table <- read.csv(iFLO_numerator_table)
        
        # Extract out statistics
        denom <- iFLO_table$sum
        numer <- iFLO_numerator_table$sum
        
        # Get result
        result_metrics[[lu_idx]]$iFLO[rowID] <- numer/denom
        
      }
      
      message(paste0(Sys.time(), ": rowID : ", rowID, " : iFLO finished"))
      
    }
    
    # Compute iFLS metric in full if needed
    if(any(metrics == "iFLS")){
      
      # Get current weight raster
      iFLS_weight <- iFLS_weights[rowID]
      
      # Loop over land use rasters to compute metrics
      for(lu_idx in 1:length(landuse)){
        
        # Get iFLS * landuse
        iFLS_numerator_command <- paste0("iFLS_numerator = ", iFLS_weight, " * ", landuse[lu_idx])
        rast_calc(iFLS_numerator_command)
        
        # Compute table
        iFLS_table <- tempfile(fileext = ".csv")
        iFLS_numerator_table  <- tempfile(fileext = ".csv")
        
        zonal_table(iFLS_weight, watersheds[rowID], iFLS_table)
        zonal_table("iFLS_numerator", watersheds[rowID], iFLS_numerator_table)
        
        # Get result table
        iFLS_table <- read.csv(iFLS_table)
        iFLS_numerator_table <- read.csv(iFLS_numerator_table)
        
        # Extract out statistics
        denom <- iFLS_table$sum
        numer <- iFLS_numerator_table$sum

        # Get result        
        result_metrics[[lu_idx]]$iFLS[rowID] <- numer/denom
        
      }
      
      message(paste0(Sys.time(), ": rowID : ", rowID, " : iFLS finished"))
      
    }
    
    # Compute HAiFLO weights if needed
    if(any(metrics == "HAiFLO")){
      
      # Get current HAiFLO weight
      HAiFLO_weight <- HAiFLO_weights[rowID]
      
      # Loop through land use rasters to compute HAiFLO metrics
      for(lu_idx in 1:length(landuse)){
        
        # Compute HAiFLO * landuse
        rast_calc(paste0("HA_iFLO_numerator =", HAiFLO_weight, " * ", landuse[lu_idx]))
        
        # Compute zonal stats as table
        HA_iFLO_table <- tempfile(fileext = ".csv")
        HA_iFLO_numerator_table <- tempfile(fileext = ".csv")
        zonal_table(HAiFLO_weight, watersheds[rowID], HA_iFLO_table)
        zonal_table("HA_iFLO_numerator", watersheds[rowID], HA_iFLO_numerator_table)
        
        # Get result table
        HA_iFLO_table <- read.csv(HA_iFLO_table)
        HA_iFLO_numerator_table <- read.csv(HA_iFLO_numerator_table)
        
        # Extract out statistics
        denom <- HA_iFLO_table$sum
        numer <- HA_iFLO_numerator_table$sum
        
        # Compute metric
        result_metrics[[lu_idx]]$HAiFLO[rowID] <- numer/denom
        
      }
      
      message(paste0(Sys.time(), ": rowID : ", rowID, " : HAiFLO finished"))
    
    }
    
    # Compute HAiFLS weights if needed
    if(any(metrics == "HAiFLS")){
      
      # Get current HAiFLS weight
      HAiFLS_weight <- HAiFLS_weights[rowID]
      
      # Loop through land use rasters to compute HAiFLS metrics
      for(lu_idx in 1:length(landuse)){
        
        # Compyte HA_iFLS * landuse
        rast_calc(paste0("HA_iFLS_numerator =", HAiFLS_weight, " * ", landuse[lu_idx]))
        
        # Compute zonal stats as table
        HA_iFLS_table <- tempfile(fileext = ".csv")
        HA_iFLS_numerator_table <- tempfile(fileext = ".csv")
        zonal_table(HAiFLS_weight, watersheds[rowID], HA_iFLS_table)
        zonal_table("HA_iFLS_numerator", watersheds[rowID], HA_iFLS_numerator_table)
        
        # Get result table
        HA_iFLS_table <- read.csv(HA_iFLS_table)
        HA_iFLS_numerator_table <- read.csv(HA_iFLS_numerator_table)
        
        # Extract out statistics
        denom <- HA_iFLS_table$sum
        numer <- HA_iFLS_numerator_table$sum
        
        # Compute metric
        result_metrics[[lu_idx]]$HAiFLS[rowID] <- numer/denom

      }
      message(paste0(Sys.time(), ": rowID : ", rowID, " : HAiFLS finished"))
    }
    
    # Remove mask
    clear_mask() 
    
  }
  
  # Create data frame with land use x metrics
  full_data <- matrix(
    as.numeric(rownames(sites_sf)), 
    nrow(sites_sf), 
    1
  )
  colnames(full_data) <- "rowID"
  for(lu_idx in 1:length(landuse)){
    temp_data <- do.call(cbind, result_metrics[[lu_idx]])
    column_nm <- colnames(temp_data)
    # colnames(temp_data) <- out_fields
    full_data <- cbind(full_data, temp_data)
  }
  colnames(full_data)[2:ncol(full_data)] <- out_fields
  full_data <- as.data.frame(full_data)
  if(percentage) full_data[,2:ncol(full_data)] <- 100 * full_data[,2:ncol(full_data)]
  
  # Return as sf object
  full_data <- cbind(sites_sf, full_data)
  
  # Print message
  message(paste0(Sys.time(), ": Successfully completed computing metrics"))
  
  # Return data frame with site metrics immediately
  return(full_data)
  
}