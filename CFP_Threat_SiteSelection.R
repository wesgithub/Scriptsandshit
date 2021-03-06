require(rgdal)
require("R.utils")
require(raster)
require(maptools)
require(SDMTools)
require(RColorBrewer)

setwd("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/USFS_ChangeDetection_Data/scratch")
c1<-readOGR(dsn="C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Vector/site_selection",layer="GMA_Luangwa")
threat<-"Combined_USFS_Hansen_dilate_cross_3x3_close_ball_5x5_sieve_15_8.tif"
dd=data.frame(matrix(nrow=23, ncol=1))
names(dd)<-c("P_Threat")
dd$ID<-1:23
print("Starting the for loop")

i=1
for (i in 1:length(c1)) {
  d<-c1[c1$cat==i,]
  plot(d)
  b<-raster(threat)
  e<-crop(b,d)
  f<-mask(e,d)
  g<-as.data.frame(freq(f))
  h<-round(g[2,2]/g[1,2]*100,2)
  dd[i,1]<-h
  i=i+1
}

c2<-c1
c2@data=data.frame(c1@data, dd[match(c1@data$cat, dd$ID),])
writeOGR(obj=c2,dsn="./vectors","Threat_Percent_Change",driver="ESRI Shapefile")
