#' Ensure SAGA workspace matches R working directory
#' @description By calling this function, you can set SAGA's working directory to the current working directory you have in R.
#' @param ... Additional arguments to \code{rsaga.env}
#' @return A list indicating the current settings for the SAGA environment parameters.
#' @export
rwd_to_swd <- function(...){
  rsaga.env(workspace = getwd(), ...)
}