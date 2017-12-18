require(rgdal)
require("R.utils")
require(raster)
require(maptools)
require(SDMTools)
require(RColorBrewer)
require(rgeos)
require(sp)
require(PBSmapping)
######################################open vector layer Vector######################################
#C:\Users\carbon-gis\Documents\BCP_Data\Projects\EasternZambia_USAID\Raster\SiteSelectionScratch
a<-file.choose()
b<-basename(a)
b<-substr(b,1,(nchar(b)-4))
c1<-readOGR(dsn=a,layer=b)
c<-dirname(a)
setwd(c)
c2<-spTransform(c1, CRS("+proj=utm +zone=35 +south +datum=WGS84 +units=m +no_defs"))
######################################open raster layer Vector######################################
#C:\Users\carbon-gis\Documents\BCP_Data\Raster_Gen\AA_LU_LC\ZAMBIA 2010\Zambia 2010 IMG Files
ab<-file.choose()
rst<-raster(ab)
######################################Create DF to Store the data######################################
dd=data.frame(matrix(nrow=length(c2), ncol=2))
names(dd)<-c("name","fl")
######################################Processing the Raster data######################################
i=1
for (i in 1:length(c2)){
  print(i)
  cc1<-c2[i,]
  cr<-crop(rst,cc1)
  print("crop complete")
  crm<-mask(cr,cc1)
  print("mask complete")
  crm.d<-as.data.frame(freq(crm))
  crm.d.na<-crm.d[complete.cases(crm.d),]
  lc.sum<-sum(crm.d.na[,2])
  dd[i,1]<-paste(cc1@data$Name)
  dd[i,2]<-round(crm.d.na$count[crm.d.na$value==1]/lc.sum*100,2)
  print(dd)
}

cc<-paste(b,"_ForestCover",sep="")

c2@data=data.frame(c2@data, dd[match(c2@data$Name, dd$name),])
writeOGR(obj=c2,dsn=".",cc,driver="ESRI Shapefile",overwrite_layer=TRUE)




