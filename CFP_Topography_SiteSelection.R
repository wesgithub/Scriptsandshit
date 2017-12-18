

require(rgdal)
require("R.utils")
require(raster)
require(maptools)
require(SDMTools)
require(RColorBrewer)

setwd("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/SiteSelectionScratch")

# Read in the shapefile #
c1<-readOGR(dsn="C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Vector/site_selection",layer="GMA_Luangwa")
slope="test_SL.tif"
dd=data.frame(matrix(nrow=4, ncol=23))
# Begin the for loop used to interogate each location #
print("Starting the first for loop")

i=1
for (i in 1:length(c1)) {
  d<-c1[c1$cat==i,]
  plot(d)
  #print(c$cat[i]) testing purposes#
  #Read in raster containing slope data#
  print(i)
  b<-raster(slope)
  e<-crop(b,d)
  f<-mask(e,d)
  #calculate percentage of area for each slope class#
  #print("calculated percentage slope",i)
  g<-as.data.frame(freq(f))
  h<-subset(g, value<4&value>0)  
  flt<-round(h[1,2]/(h[1,2]+h[2,2]+h[3,2])*100,2)
  hll<-round(h[2,2]/(h[1,2]+h[2,2]+h[3,2])*100,2)
  mtn<-round(h[3,2]/(h[1,2]+h[2,2]+h[3,2])*100,2)
  tmp<-c(i,flt,hll,mtn)
  dd[[i]]<-tmp
}

ee<-as.data.frame(t(dd))
names(ee)<-c("ID","flt","hll","mtn")


c2<-c1
c2@data=data.frame(c1@data, ee[match(c1@data$cat, ee$ID),])
writeOGR(obj=c2,dsn=".","Slope_CFP",driver="ESRI Shapefile")


