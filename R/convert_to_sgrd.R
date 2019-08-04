#' Facilitate the conversion of files to SAGA format
#' @description The SAGA modules called in this package require files to be in SAGA format, so this function calls GDAL to convert any non-SAGA files to the required format.
#' @param in_file A vector of strings, which are file paths to existing files.
#' @param out_file A vector of strings, which are file paths to the output files.
#' @return Nothing. The files will be saved wherever is indicated in out_file.
#' @export
convert_to_sgrd <- function(in_file, out_file){
  
  # Check inputs
  l1 <- length(in_file)
  l2 <- length(out_file)
  if(l1 != l2) stop("The number of inputs and outputs must be the same.")
  
  # in loop, run gdal_translate
  for(i in 1:l1){
    gdal_translate(in_file[i], out_file[i], of = "SAGA")
  }
  
  # return nothing
  invisible()
  
}