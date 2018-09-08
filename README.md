
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cartilage

The goal of cartilage is to blend rayshader image forms with absolute
coordinates in rgl.

This is very much a work in progress. See functions `lamb` and
`ambient`, which expect a raster. Be careful not to input very large
data (we’ll add helpers), and keep dimensions to something like 300\*300
or so (unless you keen). A local rgl device is highly recommended,
rglwidget works fine but doesn’t scale very well.

Feedback welcome\!

## Installation

Install from github with

``` r
devtools::install_github("hypertidy/cartilage")
```

## Getting raster data …

(… at reasonable resolution)

The ‘raster’ package has a pretty efficient ‘aggregate’ function, and
‘rgdal’ can read data at lower resolution than native using the
‘output.dim’ argument of ‘readGDAL’ - the
[stars](https://github.com/r-spatial/stars.git) project aims to
supersede both packages and provide the raster sf. Our favourite method
currently is to use
[lazyraster](https://github.com/hypertidy/lazyraster.git) which can read
directly from a file via GDAL into a raster of a desired resolution,
with helpers for setting an extent prior to reading any data.

The output of cartilage functions is the data used to build the scene,
but we don’t have helpers for those yet. A related idea is being pursued
in [SOmap](https://github.com/Maschette/SOmap.git) for Antarctica maps.

Please note that the ‘cartilage’ project is released with a [Contributor
Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project,
you agree to abide by its terms.

‘cartilage’ was originally named ‘montereybayshader’, as it was
motivated by getting a shareable data set and settled on Monterey Bay.
The original code was just to plot rayshader products in absolute
coordinates, or to mesh other products into a rayshader scene.

## Older discussion:

Monterey Bay in absolute coordinates X, Y, Z (metres) with Natural Earth
coastline added (*+proj=lcc +lon\_0=-122 +lat\_0=36.45 +lat\_1=36.7
+lat\_2=37.2 +datum=WGS84*).

![Monterey](data-raw/montereybay_abscoords_LCC.png)

Here’s the same scene using plot\_3d and indexing in the NE line in
matrix index space.

![Monterey](data-raw/montereybay_relative_coords.png)

# notes

Working code example is in /data-raw/monterey\_bay\_dem.R and will
download the file locally into data-raw/.

Some challenges:

  - rayshader defaults to matrix index space
  - rayshader uses `rgl.surface` with its X-Z-Y convention (affects
    light3d and aspect3d usage)
  - plot\_3d modifies the properties somehow? (I run anglr code before
    this to avoid)
  - rayshader is t(raster) orientation

Matrix orientation: t(raster) is different from image() as well) though
this works with modifying the data further by caputuring the rayshader
output with brick() to write to PNG.
