delete_file_ext <- function(x){
  gsub(".[A-Za-z]{1,10}$", "", x)
}