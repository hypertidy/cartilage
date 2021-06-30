#' Rayshader as RGB vector
#'
#' @param x rayshader array
#'
#' @return vector of hex codes
#' @export
#' @importFrom grDevices grey rgb
rayshade_to_hex <- function(x) {
  if (length(dim(x)) == 3 ) {
    rgb(t(x[,,1]), t(x[,,2]), t(x[,,3]))
  } else {
    grey(as.vector(x[, ncol(x):1]))
  }
}
