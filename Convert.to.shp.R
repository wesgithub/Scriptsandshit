#Script to convert gps coordinates in csv file to shapefile

library(sp)
library(rgdal)
a<-read.csv(file="PointInterpretation_coordinates.csv")
coordinates(a) <- c("X", "Y")
proj4string(a) <- CRS("+proj=utm +zone=35 +ellps=WGS84 +datum=WGS84 +units=m +no_defs +towgs84=0,0,0")
writeOGR(a, dsn="PointInterpretation_coordinates.shp", "PointInterpretation_coordinates", driver="ESRI Shapefile")