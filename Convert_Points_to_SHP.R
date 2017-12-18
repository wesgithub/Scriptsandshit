
library(sp)
library(rgdal)
library(alphahull)
library(rgeos)
library(maptools)

a<-file.choose()
b<-basename(a)
c<-dirname(a)
setwd(c)
l.ist<-list()
d<-read.csv(file=b)

P4S <- CRS("+proj=longlat +datum=WGS84")

i=1
for (i in 1:9){
  e<-subset(d,d$ID==i)
  coordinates(e)<-~X+Y
  ee<-gConvexHull(e)
  f<-as(ee,"SpatialPolygonsDataFrame")
  proj4string(f) <- P4S
  g<-spTransform(f, CRS("+proj=utm +zone=35 +south +datum=WGS84 +units=m +no_defs"))
  Area<-round(gArea(g)/10000,2)
  h<-as.data.frame(c(e[1,1:4],Area))
  names(h)<-c("ID","Name","Location_cde","Location","X","Y","Area")
  g@data<-h
  g<-spChFIDs(g,as.character(i))
  l.ist[[i]] <- g
  i=i+1
  print(i)
}

out<-l.ist[[1]]
i=2
for (i in 2:length(l.ist)){
  out<-spRbind(out,l.ist[[i]])
  i=i+1  
}

cc<-substr(b,1,(nchar(b)-4))

writeOGR(obj=out,dsn="./AA_VigorData",cc,driver="ESRI Shapefile",overwrite_layer=TRUE)








