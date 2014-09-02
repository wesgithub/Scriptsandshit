

require(rgdal)
require(R.utils)
require(raster)
require(maptools)
require(SDMTools)
require(RColorBrewer)
library(raster)
setwd("C:/Users/carbon-gis/Documents/BCP_Data/Projects/EasternZambia_USAID/Vector/site_selection/EP_DistrictLevelLoss")

# Read in Shapefile and strip out data not required also re-project to UTM36s
c1<-readOGR(dsn="C:/Users/carbon-gis/Documents/BCP_Data/Projects/EasternZambia_USAID/Vector/administration",layer="Eastern_Province_Districts")
c2<-spTransform(c1, CRS("+proj=utm +zone=36 +south +datum=WGS84 +units=m +no_defs"))


# Assign the location of the 
def<-"C:/Users/carbon-gis/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/Hansen_Global_Forest_Change/Loss/Mosaic_Clip_Hansen_GFC2013_loss_UTM36S.tif"

dd=data.frame(matrix(nrow=8, ncol=3))
# Begin the for loop used to interogate each location #
print("Starting the first for loop")

i=1
for (i in 1:length(c2)) {
  d<-c2[c2$OBJECTID==i,]
  plot(d)
  #print(c$cat[i]) testing purposes#
  #Read in raster containing slope data#
  print(i)
  b<-raster(def)
  e<-crop(b,d)
  f<-mask(e,d)
  #calculate percentage of area for each slope class# 7258827
  #print("calculated percentage slope",i)
  g<-as.data.frame(freq(f))
  h<-subset(g, value<4&value>=0)
  j<-(h[2,2]/(h[1,2]+h[2,2]))*100
  tmp<-c(i,round(j,2),round(j/12,2))
  dd[i,]<-tmp
  i=i+1
}

ee<-as.data.frame(dd)
names(ee)<-c("ID","H_Tot","H_Rte")


c2<-c1
c2@data=data.frame(c1@data, ee[match(c1@data$OBJECTID, ee$ID),])
names(c2@data)<-c("OBJECTID","ID","NAME1","def.90_00","def.00_10","90.00_annu","00.10_annu","AREA","PERIMETER","Area_ha","ID_","H_Tot","H_Rte")
writeOGR(obj=c2,dsn=".","Hansen_Deforestation_Ep_Districts_02-09-24",driver="ESRI Shapefile")
