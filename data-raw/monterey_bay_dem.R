#u <- "https://www.ngdc.noaa.gov/thredds/fileServer/regional/monterey_bay_P080_2018.nc"
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

# library(anglr)
# plot3d(copy_down(QUAD(monterey_dem), monterey_dem))


library(rayshader)
mdem <- aggregate(monterey_dem, fact = 4) %>%  as.matrix()
#mdem <- as.matrix(monterey_dem)
sh <- mdem  %>%
  sphere_shade(texture = "imhof1")

## can't see what the orientation is yet, rayshader works in something different
rgdal::writeGDAL(as(flip(brick(sh * 256), "x"), "SpatialGridDataFrame"), "texture.png", driver = "PNG")
qm <- quadmesh::quadmesh(monterey_dem)
library(rgl)

## the texture coords are the centres, just scaled  see link for more general re-mapping
## https://gist.github.com/mdsumner/dc80283de50bb23ff7681b14768b9367#file-rgl_texture-r
qm$texcoords <- t(xyFromCell(setExtent(monterey_dem, extent(0, 1, 0, 1)),
                           cellFromXY(monterey_dem, t(qm$vb[1:2, ]))))
library(rgl)
shade3d(qm, texture = "texture.png", col = "white")
