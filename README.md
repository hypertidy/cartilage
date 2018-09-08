
<!-- README.md is generated from README.Rmd. Please edit that file -->
cartilage
=========

The goal of cartilage is to blend rayshader image forms with absolute coordinates in rgl.

This is very much a work in progress. See functions `sphere`, `ray`, `lamb` and `ambient`, which expect a raster and provide the same interfaces as the corresponding `rayshader` `*_shade` functions. Be careful not to input very large data, keep to something like 300\*300 or so unless you outlandishly keen (we'll add helpers). The output of functions is the data use to build the scene, but we don't have helpers for those yet.

Install from github with

``` r
devtools::install_github("hypertidy/cartilage")
```

Feedback welcome!

Please note that the 'cartilage' project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.
