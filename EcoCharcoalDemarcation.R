
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
a<-file.choose()
b<-basename(a)
b<-substr(b,1,(nchar(b)-4))
c<-dirname(a)
c1<-readOGR(dsn=c,layer=b)
print(c)
setwd(c)
c2<-spTransform(c1, CRS("+proj=utm +zone=35 +south +datum=WGS84 +units=m +no_defs"))
######################################open raster layer Vector######################################
ab<-file.choose()
c3<-raster(ab)
######################################open vector layer Vector######################################
d1<-c2[c2$Area_ha<15,]
d1.list<-list()
d2<-c2[c2$Area_ha>15,]
d2.list<-list()
combined.list<-list()
######################################Process smaller plots using sample points and Voronoi diagrams######################################
sel<-as.data.frame(sort(d1@data$PKUID))
names(sel)<-c("sel")
i=1
for (i in 1:length(d1)){
  dd1<-d1[d1$PKUID==sel[i,],]
  sp1<-spsample(dd1,n=18,"regular")
  sp1.df<-as.data.frame(sp1)
  names(sp1.df)<-c("X","Y")
  sp1.v<-calcVoronoi(sp1.df)
  sp1.pg<-PolySet2SpatialPolygons(sp1.v)
  projection(sp1.pg)<-CRS("+proj=utm +zone=35 +south +datum=WGS84 +units=m +no_defs")
  sp1.out<-gIntersection(sp1.pg,dd1,byid=TRUE)
  df<-data.frame(pkuid=dd1@data$PKUID,id=1:length(sp1.out),name=paste(dd1@data$Name),area=1)
  l=1
  for (l in 1:length(sp1.out)){
    df[l,4]<-sp1.out@polygons[[l]]@Polygons[[1]]@area/10000
    l=l+1
  }
  row.names(df)<-row.names(sp1.out)
  sp1.df<- SpatialPolygonsDataFrame(sp1.out,df)
  d1.list[i]<-sp1.df
  print(i)
  i=i+1
}
d1.out<-do.call(rbind,d1.list)
writeOGR(obj=d1.out,dsn=".","LT15haEc",driver="ESRI Shapefile",overwrite_layer=TRUE)
combined.list[1]<-d1.out
######################################Process larger plots using contours######################################
sel2<-as.data.frame(sort(d2@data$PKUID))
end.list<-list()
j=1
for (i in 1:length(d2)){
  dd2<-d2[d2$PKUID==sel2[j,],]
  rotation=18 #Rotation period used for the ecocharcoal sites - output may not match this but it is a guide
  rs.1<-crop(c3,dd2)
  rs.2<-mask(rs.1,dd2)
  ab<-cellStats(rs.2, stat='max', na.rm=TRUE, asSample=TRUE)-1
  p = rasterToPoints(rs.2, fun=function(x){x > ab})
  p<-as.data.frame(p)
  p<-p[1,]
  coordinates(p) <- ~x+y #highest point of the plot which will be used to create the buffers / contours.
  #Calculate the buffer sizes using the hypoteneuse of the bounding box of the   
  x<-abs(dd2@bbox[1]-dd2@bbox[3])
  y<-abs(dd2@bbox[2]-dd2@bbox[4])
  xx<-x^2+y^2
  c<-sqrt(xx)
  buff.d<-c/rotation
  buff.list<-list()
  k=1
  wd.1<-c
  wd.2<-c-buff.d
  for (k in 1:17){
    lp.1<-gBuffer(p,width=wd.1)
    lp.2<-gBuffer(p,width=wd.2)
    buff.list[k]<-gDifference(lp.1,lp.2)
    wd.1<-wd.1-buff.d
    wd.2<-wd.2-buff.d
    k<-k+1
  }
  buff.list[j+1]<-gBuffer(p,width=wd.1)
  
  buff.out<-do.call(bind,buff.list)
  projection(buff.out)<-CRS("+proj=utm +zone=35 +south +datum=WGS84 +units=m +no_defs")
  buff.int<-gIntersection(buff.out,dd2,byid=TRUE)
  df<-data.frame(pkuid=dd2@data$PKUID,id=1:length(buff.int),name=paste(dd2@data$Name),area=1)
  l=1
  for (l in 1:length(buff.int)){
    df[l,4]<-buff.int@polygons[[l]]@Polygons[[1]]@area/10000
    l=l+1
  }
  end.list[j]<-SpatialPolygonsDataFrame(buff.int,df,match.ID = FALSE)
  j<-j+1
}
end.out<-do.call(bind,end.list)
writeOGR(obj=end.out,dsn=".","GT15haEc",driver="ESRI Shapefile",overwrite_layer=TRUE)
combined.list[2]<-end.out
combined.out<-do.call(bind,combined.list)
writeOGR(obj=combined.out,dsn=".","AllEcDemarcation",driver="ESRI Shapefile",overwrite_layer=TRUE)
