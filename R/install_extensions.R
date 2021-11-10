#' Install required extension(s)
#' @description Some functions in the \code{rdwplus} package rely on GRASS extensions that need to be installed prior to use. This function installs those extensions.
#' @return  Nothing. 
#' @details 
#' 
#' This function has no arguments. Simply run it and it will install a pre-set list of GRASS extensions.
#' 
#' Currently, the GRASS extension required are \code{r.stream.snap} and \code{r.wateroutlet.lessmem}.
#' 
#' @examples 
#' # Will only run if GRASS is running
#' if(check_running()){
#'     install_extensions()
#' }
#' @export
install_extensions <- function(){
  
  # Check that GRASS is running
  if(!check_running()) stop("There is no valid GRASS session. Program halted.")
  
  execGRASS("g.extension", parameters = list(extension = "r.stream.snap"))
  execGRASS("g.extension", parameters = list(extension = "r.wateroutlet.lessmem"))
  
  # Return nothing
  invisible()
  
}