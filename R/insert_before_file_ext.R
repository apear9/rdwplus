insert_before_file_ext <- function(x, i){
  gsub("(.[A-Za-z]{1,10}$)", paste0(i, "\\1"), x)
}