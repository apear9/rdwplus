zonal_table <- function(inmap, inlu, outtab){
  flags <- c("overwrite",  "t", "g")
  
  execGRASS("r.univar",
            flags = flags,
            parameters = list(
              map = inmap, 
              zones = inlu, 
              output = outtab, 
              separator = "comma"
            )
  )
}