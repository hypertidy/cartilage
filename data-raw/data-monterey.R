##u <- "https://www.ngdc.noaa.gov/thredds/fileServer/regional/monterey_bay_P080_2018.nc"
u <- "https://www.ngdc.noaa.gov/thredds/fileServer/regional/monterey_13_mhw_2012.nc"
f <- here::here("data-raw", basename(u))
if (!file.exists(f)) curl::curl_download(u, f)

monterey_dem0 <- raster::raster(f)
library(raster)
## original rayshader used seq(1, 8001, by = 20) and seq(1001, 9001, by = 20)
target <- projectExtent(crop(raster(monterey_dem0), extent(monterey_dem0, 1, 8001, 1001, 9001)),
                        "+proj=lcc +lon_0=-122 +lat_0=36.45 +lat_1=36.7 +lat_2=37.2 +datum=WGS84")
extent(target) <- spex::buffer_extent(target, 80)
res(target) <- 80

monterey_dem <- projectRaster(monterey_dem0, target)
monterey_dem[] <- as.integer(values(monterey_dem))
dataType(monterey_dem) <- "INT2S"
writeRaster(monterey_dem, "inst/extdata/monterey/monterey_dem.tif", datatype = "INT2S", options = c("COMPRESS=DEFLATE"))
