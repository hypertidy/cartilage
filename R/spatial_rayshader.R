
# hillshade:
#
# add_shadow
# add_water
# plot_map
# save_png
#
# heightmap:
#
# ambient_shade
# lamb_shade
# ray_shade
# sphere_shade
#
# calculate_normal
# detect_water
#
# hillshade, heightmap:
# plot_3d
#


plot_extra <- function(x, ras) {

}
raster_to_heightmap <- function(x) {
  t(raster::as.matrix(x))
}


plot_hillshade <- function(rr, hs, add = FALSE) {
  qm <- quadmesh::quadmesh(rr, z = rr)
  if (!add) rgl::rgl.clear()
  rgl::shade3d(qm, col = rep(rayshade_to_hex(hs), each = 4))

  rgl::aspect3d(1, 1, .1)
  invisible(list(quadmesh = qm, hillshade = hs, raster = rr))

}
#' @export
ambient <- function(x, anglebreaks = seq(1, 46, 15), sunbreaks = 12,
                    maxsearch = 20, multicore = FALSE, zscale = 1, cache_mask = NULL,
                    shadow_cache = NULL, progbar = TRUE, ..., extra = NULL) {
  UseMethod("ambient")
}
#' @export
lamb <- function(x, rayangle = 45, sunangle = 315, zscale = 1,
                 zero_negative = TRUE, ..., extra = NULL) {
  UseMethod("lamb")
}

ray <- function(x, anglebreaks = seq(40, 50, 1), sunangle = 315,
                maxsearch = 100, lambert = TRUE, zscale = 1, multicore = FALSE,
                cache_mask = NULL, shadow_cache = NULL, progbar = TRUE, ..., extra = NULL) {
  UseMethod("ray")
}

sphere <- function(x, sunangle = 315, texture = "imhof1", normalvectors = NULL,
                   zscale = 1, progbar = TRUE, ..., extra = NULL) {
  UseMethod("sphere")
}
#
# ray.BasicRaster <- function(x, anglebreaks = seq(40, 50, 1), sunangle = 315,
#                             maxsearch = 100, lambert = TRUE, zscale = 1, multicore = FALSE,
#                             cache_mask = NULL, shadow_cache = NULL, progbar = TRUE, ..., extra = NULL) {
#
#   hm <- raster_to_heightmap(x)
#   print("building shader")
#   hillshade <- rayshader::ray_shade(hm, heightmap = hm, anglebreaks = anglebreaks,
#                                     lambert = lambert, zscale = zscale, multicore = multicore,
#                                     cache_mask = cache_mask, shadow_cache = shadow_cache,
#                                     progbar = progbar, ...)
#   print("shading done!")
#
# ##  hillshade <- set0(hillshade)
#   plot_hillshade(x, hillshade, add = add)
# }

#' @export
lamb.BasicRaster <- function(x, rayangle = 45, sunangle = 315, zscale = 1,
                 zero_negative = TRUE, ..., extra = NULL, add = FALSE) {

  hm <- raster_to_heightmap(x)
  print("building shader")
  hillshade <- rayshader::lamb_shade(hm, rayangle = rayangle, sunangle = sunangle, zscale = zscale,
                                     zero_negative = zero_negative, ...)
  print("shading done!")
  set0 <- function(x) {
    x[is.na(x)] <- 0
    x
  }
  hillshade <- set0(hillshade)
 plot_hillshade(x, hillshade, add = add)
}
#' @export
ambient.BasicRaster <- function(x, anglebreaks = seq(1, 46, 15), sunbreaks = 12,
                                maxsearch = 20, multicore = FALSE, zscale = 1, cache_mask = NULL,
                                shadow_cache = NULL, progbar = TRUE, ..., extra = NULL, add = FALSE) {

  hm <- raster_to_heightmap(x)
  print("building shader")
  hillshade <- rayshader::ambient_shade(hm, anglebreaks = anglebreaks, sunbreaks = sunbreaks,
                                        maxsearch = maxsearch, multicore = multicore, zscale = zscale, cache_mask = cache_mask,
                                        shadow_cache = shadow_cache, progbar = progbar, ...)
  print("shading done!")
  plot_hillshade(x, hillshade, add = add)
}


