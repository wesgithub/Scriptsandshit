

##############################################################################################################################
#################################EcoCharcoalDemarcation.R#####################################################################
##############################################################################################################################
rotation=18
rs.1<-crop(c3,dd2)
rs.2<-mask(rs.1,dd2)
ab<-cellStats(rs.2, stat='max', na.rm=TRUE, asSample=TRUE)-1
p = rasterToPoints(rs.2, fun=function(x){x > ab})
p<-as.data.frame(p)
p<-p[1,]
coordinates(p) <- ~x+y

x<-abs(dd2@bbox[1]-dd2@bbox[3])
y<-abs(dd2@bbox[2]-dd2@bbox[4])
xx<-x^2+y^2
c<-sqrt(xx)
buff.d<-c/rotation


buff.list<-list()
j=1
wd.1<-c
wd.2<-c-buff.d
for (j in 1:17){
  lp.1<-gBuffer(p,width=wd.1)
  lp.2<-gBuffer(p,width=wd.2)
  buff.list[j]<-gDifference(lp.1,lp.2)
  wd.1<-wd.1-buff.d
  wd.2<-wd.2-buff.d
}
buff.list[j+1]<-gBuffer(p,width=wd.1)

buff.out<-do.call(bind,buff.list)
projection(buff.out)<-CRS("+proj=utm +zone=35 +south +datum=WGS84 +units=m +no_defs")
buff.int<-gIntersection(buff.out,dd2,byid=TRUE)
df<-data.frame(pkuid=dd2@data$PKUID,id=1:length(buff.int),name=paste(dd2@data$Name),area=1)
i=k
for (k in 1:length(buff.int)){
    df[k,4]<-buff.int.df@polygons[[i]]@Polygons[[1]]@area/10000
}
buff.int.df<-SpatialPolygonsDataFrame(buff.int,df,match.ID = FALSE)
writeOGR(obj=buff.int.df,dsn=".","test",driver="ESRI Shapefile",overwrite_layer=TRUE)

xx<-dd2@polygons[[1]]@Polygons[[1]]@coords
i.1<-0
i.2<-1
j<-1
for (i in 1:4){
  print(sqrt((xx[i.2+j,1]-xx[i.1+j,1])^2+(xx[i.2+j,2]-xx[i.1+j,2]))/18)
  j<-j+1
}



combined.out.geo<-spTransform(combined.out, CRS("+proj=longlat +ellps=WGS84"))
xy.df<-data.frame(pkuid=integer(0),id=integer(0),X=numeric(0),Y=numeric(0),Name=character(0))
i=1
for(i in 1: length(combined.out.geo)){
  x<-combined.out.geo@polygons[[i]]@Polygons[[1]]@coords
  x.df<-data.frame(pkuid=combined.out.geo@data$pkuid[i],id=combined.out.geo@data$id[i],X=x[,1],Y=x[,2],Name=combined.out.geo@data$name[i])
  xy.df<-rbind(xy.df,x.df)
  i=i+1
}

coordinates(xy.df) <- ~X+Y
writeOGR(obj=xy.df,dsn=".","test",driver="ESRI Shapefile",overwrite_layer=TRUE)



















##############################################################################################################################
#################################EcoCharcoalDemarcation.R#####################################################################
##############################################################################################################################