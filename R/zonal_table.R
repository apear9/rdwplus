zonal_table <- function(inmap, inlu, outtab){
  flags <- c("overwrite")
  
  execGRASS("r.univar",
            flags = flags,
            parameters = list(
              map = inmap, 
              zones = landuse, 
              output = outtab, 
              separator = "comma"
            )
  )
}