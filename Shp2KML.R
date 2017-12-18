# Read shapefile into R and convert each geometry to kml kml saved to local HD

library(rgdal)
library(sp)

wd <- "C:/Users/RobertsJo/Documents/FAO_Rome_2017/Data/GIS/General/Vector/AGO_adm_shp/"
setwd(wd)

cnt <- readOGR(dsn = ".",layer = "AGO_adm1")
c.cnt<-cnt[, c(3,5)]

i <- 1
for (i in 1:length(c.cnt@data[,1])){
  a<-c.cnt[i,]  
  writeOGR(a, paste(a@data[,2],".kml", sep=""), layer="a", driver="KML")
  print(paste((a@data[,2]),".kml", sep=""))
  }
















