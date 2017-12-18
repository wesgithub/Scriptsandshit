#R program to perform the Kriging interpolation of the lidar intensity and 
#height data
#Wesley Roberts
#06/02/2009
#Stellenbosch
#NRE

library(automap)
library(gstat)
library(maptools)
library(rgdal)
library(lattice)

a <- read.csv("preprocessing_pts.csv", header=TRUE)
b <- subset(a, H>15)

coordinates(b) <-~ X+Y

x.range <- as.integer(range(b@coords[,1]))
y.range <- as.integer(range(b@coords[,2]))


grd <- expand.grid(x=seq(from=x.range[1], to=x.range[2], by=0.5),y=seq(from=y.range[1], to=y.range[2], by=0.5))
coordinates(grd) <-~ x+y
gridded(grd) <- TRUE

height_1_1 = autoKrige(H~1, b, grd, model=c("Sph"), block=c(1,1))
writeGDAL(height_1_1$krige_output, fname="AreaOne_4_ht.tiff", drivername ="GTiff", type = "Float32")

intensity_1_1 = autoKrige(I~1, b, grd, model=c("Sph"), block=c(1,1))
writeGDAL(height_1_1$krige_output, fname="AreaOne_4_Int.tiff", drivername ="GTiff", type = "Float32")
