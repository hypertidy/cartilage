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

# library(anglr)
# plot3d(copy_down(QUAD(monterey_dem), monterey_dem))


library(rayshader)
mdem_raster <- aggregate(monterey_dem, fact = 4)
## can't see what the orientation is yet, rayshader works transpose to raster
## (image is transposed and flipped rel to raster)
#a <- matrix(raster::extract(mdem,raster::extent(mdem),buffer=1000),
#       nrow=ncol(mdem),ncol=nrow(mdem))
#b <- t(as.matrix(mdem))
mdem <- t(as.matrix(mdem_raster))


#mdem <- as.matrix(monterey_dem)
sh <- mdem  %>%
  sphere_shade(texture = "imhof1") %>%
  add_shadow(ray_shade(mdem,zscale=200)) %>%
  add_shadow(ambient_shade(mdem,zscale=200))

## run the rayshader plot AFTER the generic one as it modifies the context

rgdal::writeGDAL(as(brick(sh * 256), "SpatialGridDataFrame"), "texture.png", driver = "PNG")
qm <- quadmesh::quadmesh(monterey_dem)
library(rgl)

## the texture coords are the centres, just scaled  see link for more general re-mapping
## https://gist.github.com/mdsumner/dc80283de50bb23ff7681b14768b9367#file-rgl_texture-r
qm$texcoords <- t(xyFromCell(setExtent(monterey_dem, extent(0, 1, 0, 1)),
                           cellFromXY(monterey_dem, t(qm$vb[1:2, ]))))
library(rgl)


## because we are in real coordinates we can add other objects
cst <- rnaturalearth::ne_coastline(scale = 10, returnclass = "sf")
cst_local <- raster::intersect(as(sf::st_transform(cst, raster::projection(monterey_dem)), "Spatial"),
                  spex::spex(monterey_dem))

## put in mesh (segments) form
cst_sc <- silicate::SC(cst_local)
library(anglr)



#rgl.clear()
#rgl.open()
shade3d(qm, texture = "texture.png", col = "white", specular = "black")
aspect3d(1, 1, .2)

plot3d(cst_sc, add = TRUE, lwd = 7, col = "black")
axes3d()
#light3d(theta = 0, phi = 30)


## can we add to the rayshader default scene?

## map cst_local into raw index space
cst_mat <- cst_sc
cst_mat$vertex[c("xi", "yi")] <- tibble::as_tibble(xyFromCell(setExtent(mdem_raster, extent(1, ncol(mdem_raster), 1, nrow(mdem_raster))),
                                         cellFromXY(mdem_raster, as.matrix(cst_mat$vertex[c("x_", "y_")]))))
library(dplyr)
cst_mat$vertex <- cst_mat$vertex  %>%
  ## XZY for rgl.surface (but also flipped in Y)
  dplyr::mutate(x_ = xi, y_ = 20, z_ = nrow(mdem_raster) - yi + 1)

## run the rayshader plotting
#rgl.open()
plot_3d(sh, mdem)
## remember that rgl.surface is x, z, y
aspect3d(1, 0.3, 1)
plot3d(cst_mat, add = TRUE, lwd = 10, col = "black")

## TODO
## 1. make a scene with both anglr rayshader DEM
## 2. add lower region of coastline as triangulated mesh (from a different DEM source?)
## 3. Add a dismo map (or similar) to the triangulated part of the scene
## 4. Add OSM data network

## 5. make a triangulation version of local polyon areas, copy_down from DEM


## DONE 6. Emulate coastline addition in rayshader space by converting to matrix coords
