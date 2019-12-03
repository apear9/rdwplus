#' Function to suppress messages, warnings, errors from GRASS commands
#' @description Prevents the printing GRASS warnings, etc. Use with extreme caution. This is only helpful IF AND ONLY IF you are SURE that any printed messages, warnings, and errors are spurious.
#' @param value A logical indicating whether GRASS messages, warnings, errors should be suppressed. Can be missing, and it is missing by default. Choose "TRUE" or "FALSE".
#' @return A logical indicating the current status of the option.
#' @examples
#' 
#' silence(TRUE)
#' silence(FALSE)
#' 
#' @export
silence <- function(value){
  
  # If value is not missing, manipulate option
  if(!missing(value)) set.ignore.stderrOption(value)
  # Then simply get the current value
  get.ignore.stderrOption()
  
}