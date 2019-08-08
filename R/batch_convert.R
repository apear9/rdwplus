#' Convert all files of a certain type to SAGA format
#' @description Given a file extension, this function converts all files with that file extension in the current working directory into SAGA format. 
#' @param signature A file extension as a string. It is recommended that this string end in a `$` character.
#' @return Nothing. Files with the same name as the inputs (but with different file extensions) will be available in the current working directory.
#' @export
batch_convert <- function(signature){
  in_files <- dir(getwd(), signature, full.names = TRUE)
  out_files <- gsub(signature, ".sdat", in_files)
  convert_to_sgrd(in_files, out_files)
  invisible()
}