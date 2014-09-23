


require(rgdal)
require("R.utils")
require(raster)
require(maptools)
require(SDMTools)
require(RColorBrewer)
require(rgeos)


setwd("C:/Users/carbon-gis/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/ScoutData/A_Collated_SHP_Data_2013/shp_Data")

a<-as.data.frame(list.files(path=".", pattern="*.shp"))
names(a)<-c("files")
aa=data.frame(matrix(nrow=1, ncol=7),stringsAsFactors=FALSE)
names(aa)<-c("ele","time","name","Label","Type","coords.x1","coords.x2")

i=1
for (i in 1:length(a[,1])) {
  b<-as.character(a[i,])
  c<-substr(b,1,(nchar(b)-4))
  c1<-readOGR(dsn=".",layer=c)
  d<-cbind(c1@data,c1@coords)  
  aa<-rbind(d,aa)
  i=i+1
}

aa$time <- as.character(aa$time)
i=1

for (i in 1:length(aa[,1])){
  xx<-as.character(aa[i,2])
  if(nchar(xx)>10){aa[i,2]<-substr(xx,1,nchar(xx)-12)}else{}
  i=i+1
}


coords <- aa[1:190,6:7]
spdf = SpatialPointsDataFrame(coords, aa[1:190,])

writeOGR(obj=spdf,dsn="C:/Users/carbon-gis/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/ScoutData/A_Collated_SHP_Data_2013","BCP_LZRP_CollatedScoutData_22-09-14",driver="ESRI Shapefile",overwrite_layer=TRUE)
write.csv(aa,file="C:/Users/carbon-gis/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/ScoutData/A_Collated_SHP_Data_2013/BCP_LZRP_CollatedScoutData_22-09-14.csv")



