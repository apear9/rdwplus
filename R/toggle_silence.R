#' Toggle between silence on and silence off
#' @description This function detects whether output suppression is on or off, and switches it to its opposite state. Under one setting, this function can be used as an off-switch for the GRASS message/warning/error suppression enforced via the use of \code{silence(value = TRUE)}.
#' @param stay_off A logical indicating whether output suppression should be kept off once it is turned off. That is, if this function is called but output suppression is already off, then for \code{stay_off=TRUE} output suppression will simply remain off. Defaults to \code{TRUE}.
#' @return A logical indicating whether output suppression is active.
#' @examples 
#' ## Is silence toggled? 
#' toggle_silence(T) 
#' 
#' ## Is silence NOT toggled?
#' toggle_silence(F)
#' @export
toggle_silence <- function(stay_off = TRUE){
  current_state <- silence()
  if(stay_off){
    if(current_state){
      current_state <- silence(FALSE)
    }
  } else {
    current_state <- silence(!current_state)
  }
  return(current_state)
}