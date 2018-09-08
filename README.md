
<!-- README.md is generated from README.Rmd. Please edit that file -->
cartilage
=========

The goal of cartilage is to blend rayshader image forms with absolute coordinates in rgl.

This is very much a work in progress. See functions `sphere`, `ray`, `lamb` and `ambient`, which expect a raster and provide the same interfaces as the corresponding `rayshader` `*_shade` functions. Be careful not to input very large data, keep to something like 300\*300 or so unless you outlandishly keen (we'll add helpers). The output of functions is the data use to build the scene, but we don't have helpers for those yet.

Feedback welcome!

Installation
------------

Install from github with

``` r
devtools::install_github("hypertidy/cartilage")
```

Getting raster data ...
-----------------------

(... at reasonable resolution)

The 'raster' package has a pretty efficient 'aggregate' function, and 'rgdal' can read data at lower resolution than native using the 'output.dim' argument of 'readGDAL' - the [stars](https://github.com/r-spatial/stars.git) project aims to supersede both packages and provide the raster sf. Our favourite method currently is to use [lazyraster](https://github.com/hypertidy/lazyraster.git) which can read directly from a file via GDAL into a raster of a desired resolution, with helpers for setting an extent prior to reading any data.

The output of cartilage functions is the data used to build the scene, but we don't have helpers for those yet. A related idea is being pursued in [SOmap](https://github.com/Maschette/SOmap.git) for Antarctica maps.

Please note that the 'cartilage' project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.

'cartilage' was originally named 'montereybayshader', as it was motivated by getting a shareable data set and settled on Monterey Bay. The original code was just to plot rayshader products in absolute coordinates, or to mesh other products into a rayshader scene. Some older notes are in data-raw/.
