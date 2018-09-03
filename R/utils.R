#' Rayshader as RGB vector
#'
#' @param x rayshader array
#'
#' @return vector of hex codes
#' @export
#'
rayshade_to_hex <- function(x) {
  rgb(t(x[,,1]), t(x[,,2]), t(x[,,3]))
}
