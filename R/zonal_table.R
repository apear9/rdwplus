zonal_table <- function(inmap, inlu, outtab){
  
  # Set flags
  flags <- c("overwrite",  "t", "g", "quiet")
  
  # Create Zonal table
  execGRASS(
    "r.univar",
    flags = flags,
    parameters = list(
      map = inmap, 
      zones = inlu, 
      output = outtab, 
      separator = "comma"
    )
  )
  
}