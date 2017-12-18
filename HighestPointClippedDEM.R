
require(rgdal)
require("R.utils")
require(raster)
require(maptools)
require(SDMTools)
require(RColorBrewer)
require(rgeos)

setwd("C:/Users/carbon-gis/Documents/BCP_Data/Projects/Zam_Rufunsa/Raster/Infrastructure/Repeater/")

a<-raster("ConservancyDEM_UTM35S.tif")
a<-raster("four_clip.tiff")


ab<-cellStats(a, stat='max', na.rm=TRUE, asSample=TRUE)-1

p = rasterToPoints(a, fun=function(x){x > ab})
p<-as.data.frame(p)

coordinates(p) <- ~x+y

writeOGR(obj=p,dsn=".","HighestPointConservancy",driver="ESRI Shapefile")
