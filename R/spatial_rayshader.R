#' Restore rayshader to input array
#'
#' Rebuild rayshader RGB array to match its input.
#'
#' @param shade rayshader array (built from 'ras')
#' @param ras input raster
#' @export
#' @examples
#' library(rayshader)
#' monterey_dem <- raster(system.file("extdata/monterey/monterey_dem.tif", package = "montereybayshader"))
#' r <- aggregate(monterey_dem, fact = 4)
#' r <- resample(r, raster(extent(r), nrows = 256, ncols = 206))
#' mdem <- t(as.matrix(r))
#' qm <- quadmesh::quadmesh(r)
#'
#' ## run any rayshader code here
#' sh <- mdem  %>%
#' sphere_shade(texture = "imhof1") %>%
#' add_shadow(ray_shade(mdem,zscale=200)) %>%
#' add_shadow(ambient_shade(mdem,zscale=200)) %>%
#' rayshade_raster(r)
#'
#' library(rgl)
#' shade3d(qm, col = rep(rayshade_to_hex(sh), each = 4))
#' aspect3d(1, 1, .1)
rayshade_raster <- function(shade, ras) {
  ## restore the shader data to match original data
  ## because rs interpolation resizes the inputs (by 2 rows/cols)
  br <- raster::setExtent(raster::brick(shade), raster::extent(ras))
  #as.array(raster::brick(raster::resample(br[[1]], ras), raster::resample(br[[2]], ras), raster::resample(br[[3]], ras)))
  raster::as.array(raster::resample(br, ras))
}




