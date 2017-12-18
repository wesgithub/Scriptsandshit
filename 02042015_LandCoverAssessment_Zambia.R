require(rgdal)
require("R.utils")
require(raster)
require(maptools)
require(SDMTools)
require(RColorBrewer)
require(rgeos)
require(sp)

setwd("C:/Users/carbon-gis/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/LandCoverAssessment_GHG")
data<-data.frame(matrix(0:999,ncol=1,nrow=1000))
names(data)<-c("Id")
yr=2010

######################################open eastern province boundary layer Vector######################################
a<-file.choose()
b<-basename(a)
b<-substr(b,1,(nchar(b)-4))
c<-dirname(a)
c1<-readOGR(dsn=c,layer=b)
######################################open land cover classification 2000 Scheme I / II######################################
nme_I<-paste(yr,"_","SchemeI",".tif",sep="")
nme_II<-paste(yr,"_","SchemeII",".tif",sep="")
SI_2000<-raster(nme_I)
SII_2000<-raster(nme_II)
######################################open random points to test the classification classes######################################
aa<-file.choose()
bb<-basename(aa)
bb<-substr(bb,1,(nchar(bb)-4))
cc<-dirname(aa)
spnts<-readOGR(dsn=cc,layer=bb)
######################################Extract Raster Values from Scheme I and II######################################
SI<-extract(SI_2000,spnts)
SII<-extract(SII_2000,spnts)
aa<-as.data.frame(cbind(data,SI,SII))
######################################Print the classes for each Scheme I class######################################
j<-1
for (i in 1:6){
  pn=sort(unique(subset(aa[,3],aa[,2]==j)))
  message("Class:",j,"-", pn)
  j=j+1
  }
######################################Save data to a shapefile######################################
cc<-paste(b,"_","LandCover","_",yr,sep="")
c2<-spnts
c2@data=data.frame(c2@data, aa[match(c2@data$ID, aa$Id),])
writeOGR(obj=c2,dsn=".",cc,driver="ESRI Shapefile",overwrite_layer=TRUE)


