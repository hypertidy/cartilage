
<!-- README.md is generated from README.Rmd. Please edit that file -->
cartilage
=========

The goal of cartilage is to blend rayshader image forms with absolute coordinates in rgl.

This is very much a work in progress. See functions `sphere`, `ray`, `lamb` and `ambient`, which expect a raster and provide the same interfaces as the corresponding `rayshader` `*_shade` functions. Be careful not to input very large data, keep to something like 300\*300 or so unless you outlandishly keen (we'll add helpers).

The output of functions is the data used to build the scene, and currently includes the `quadmesh`, the `hillshade` and the `raster` - but we don't have helpers for those yet. An internal function plots and constructs this list output.

Feedback welcome!

Installation
------------

Install from github with

``` r
devtools::install_github("hypertidy/cartilage")
```

Example
-------

We use the built-in GeoTIFF file of a reduced resolution Monterey Bay elevation.

``` r
f <- system.file("extdata/monterey/monterey_dem.tif", package= "cartilage")

r <- raster::raster(f)
## reduce the resolution a lot (if you want)
r <- raster::aggregate(r, fact = 6)

library(cartilage)
x <- sphere(r)
rgl::axes3d()
```

Now in in `x$qm` we have the rgl mesh3d form, so we can do some tricks:

``` r
## in x$qm we have the rgl mesh3d form, so we can do some tricks
qm <- x$quadmesh  ## convert to Geocentric coordinates
qm$vb[1:3, ] <- t(proj4::ptransform(t(qm$vb[1:3, ]), raster::projection(r), "+proj=geocent +datum=WGS84"))
rgl::rgl.clear()  
rgl::shade3d(qm)  ## we are now geocentric
library(graticule)
g <- graticule(seq(-127, -113, by = 1), seq(30, 42, by = 1))
g <- silicate::SC(g)  ## hypertidy/silicate
library(anglr)  ## hypertidy/anglr
plot3d(anglr::globe(g), add = TRUE)
rgl::aspect3d(1, 1, 1)
```

Getting raster data ...
-----------------------

(... at reasonable resolution)

The 'raster' package has a pretty efficient 'aggregate' function, and 'rgdal' can read data at lower resolution than native using the 'output.dim' argument of 'readGDAL' - the [stars](https://github.com/r-spatial/stars.git) project aims to supersede both packages and provide the raster sf. Our favourite method currently is to use [lazyraster](https://github.com/hypertidy/lazyraster.git) which can read directly from a file via GDAL into a raster of a desired resolution, with helpers for setting an extent prior to reading any data.

The output of cartilage functions is the data used to build the scene, but we don't have helpers for those yet. A related idea is being pursued in [SOmap](https://github.com/Maschette/SOmap.git) for Antarctica maps.

Please note that the 'cartilage' project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.

'cartilage' was originally named 'montereybayshader', as it was motivated by getting a shareable data set and settled on Monterey Bay. The original code was just to plot rayshader products in absolute coordinates, or to mesh other products into a rayshader scene. Some older notes are in data-raw/.
