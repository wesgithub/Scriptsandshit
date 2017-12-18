library(sp)
library(rgdal)
library(ggplot2)
library(rgeos)
library(ggmap)
library(RgoogleMaps)
library(RColorBrewer)

library(MASS)

setwd("C:/Users/carbon-gis/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/NASA_FIRMS/FireData_csv")

a<-as.data.frame(list.files(path=".", pattern="*.csv"))
names(a)<-c("files")

b<-read.csv(file=paste(a[1,]))

#begin for loop which runs through a opening and combining the rest of the files with b

i=2
for (i in 1:length(a[,1])) {
  c<-read.csv(file=paste(a[i,]))
  b<-rbind(b,c)
  i=i+1
}
b$SATELLITE[b$SATELLITE=="T"]<- "terra"
b$SATELLITE[b$SATELLITE=="TRUE"]<- "terra"
b$SATELLITE[b$SATELLITE=="A"]<- "aqua"

date<-as.character(b[,4])
date<-as.Date(date, "%m/%d/%Y")
d<-cbind(b,date)

#april<-subset(d, d$date >= as.Date("2014-04-01") & d$date < as.Date("2014-05-01"))
may<-subset(d, d$date >= as.Date("2014-05-01") & d$date < as.Date("2014-06-01"))
june<-subset(d, d$date >= as.Date("2014-06-01") & d$date < as.Date("2014-07-01"))
july<-subset(d, d$date >= as.Date("2014-07-01") & d$date < as.Date("2014-08-01"))
aug<-subset(d, d$date >= as.Date("2014-08-01") & d$date < as.Date("2014-09-01"))
sep<-subset(d, d$date >= as.Date("2014-09-01") & d$date < as.Date("2014-10-01"))

mylist<-list(may,june,july,aug,sep)
mylist2<-c("May 2014","June 2014", "July 2014", "August 2014", "September 2014")

base<-readOGR(dsn="../BaseData",layer="poly_extent")
ref<-readOGR(dsn="C:/Users/carbon-gis/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/Reference_Zone", layer="Reference_Zone_WGS84_2014-06-14")
cons<-readOGR(dsn="C:/Users/carbon-gis/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/Accounting_Project_Area",layer="New_Rufunsa_Boundary_01-11-2012_WGS84")
leak<-readOGR(dsn="C:/Users/carbon-gis/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/Leakage_Zone",layer="Leakage_Zone_WGS84")
base.f<-fortify(base)
roads.f<-fortify(roads)
ref.f<-fortify(ref)
cons.f<-fortify(cons)
leak.f<-fortify(leak)

bound<-bbox(base)
bound[1, ] <- (bound[1, ] - mean(bound[1, ])) * 1.25 + mean(bound[1, ])
bound[2, ] <- (bound[2, ] - mean(bound[2, ])) * 1.25 + mean(bound[2, ])
lnd.b1 <- ggmap(get_map(location = bound))


i=1
for (i in 1:length(mylist2))
{
  b<-as.data.frame(mylist[i])
  coords = cbind(b[,2], b[,1])
  sp = SpatialPoints(coords)
  spdf = SpatialPointsDataFrame(coords, b)
  spdf.f<-fortify(b)
  q <- geom_polygon(data=base.f, aes(x=long, y=lat, group = group),colour="black", alpha=0)
  r <- geom_polygon(data=ref.f, aes(x=long, y=lat, group = group),colour="black", alpha=0)
  s <- geom_polygon(data=cons.f, aes(x=long, y=lat, group = group),colour="black")
  t <- geom_polygon(data=leak.f, aes(x=long, y=lat, group = group),colour="black",alpha=0)
  u <- geom_point(data=spdf.f, aes(x=LONGITUDE, y=LATITUDE, size = CONFIDENCE, fill=date),colour="red")
  x<-mylist2[i]
  lnd.b1 + q + r + s + t + u + ggtitle(paste("Fires in the Vacinity of LRZP -",x,sep=" ")) + theme_bw() 
  ggsave(filename=paste(x,".tiff",sep=""),)
  i=i+1
}





