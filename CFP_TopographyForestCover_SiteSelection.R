
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
forest="test_TC.tif"
dd=data.frame(matrix(nrow=34, ncol=23))
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
  b1<-raster(forest)
  e<-crop(b,d)
  e1<-crop(b1,d)
  f<-mask(e,d)
  f1<-mask(e1,d)
  #calculate percentage of area for each slope class#
  #print("calculated percentage slope",i)
  g<-as.data.frame(freq(f))
  h<-subset(g, value<4&value>0)  
  flt<-round(h[1,2]/(h[1,2]+h[2,2]+h[3,2])*100,2)
  hll<-round(h[2,2]/(h[1,2]+h[2,2]+h[3,2])*100,2)
  mtn<-round(h[3,2]/(h[1,2]+h[2,2]+h[3,2])*100,2)
  tmp <- list()#data.frame(matrix(nrow=8, ncol=3)) 
  j=1
  print("Entering the process for calculating forest cover per class")
  for (j in 1:3){
    msk_i<-f
    msk_i[msk_i!=j]<-NA
    f1.stat<-mask(f1,msk_i)
    f2.stat<-freq(f1.stat)
    f2.stat<-f2.stat[!is.na(f2.stat[,1]),]
    f2.len<-length(f2.stat[,1])-1
    tot<-sum(f2.stat[1:f2.len,2])
    ee<-list()
    x=1
    for (x in 1:f2.len) {
      TC.10<-round((f2.stat[x,2]/tot)*100,1)
      ee[[x]]<-TC.10
      x=x+1
    }
    ee<-unlist(ee)
    tmp[[j]]<-ee
    j=j+1
   }
  out<-do.call("rbind", tmp)
  mt<-matrix(nrow=3,ncol=10-f2.len)
  mt2<-cbind(out,mt)  
  
  tst.list<-list()
  #print("Forest cover per slope class calculated",i)
  k=1
  l=1
  m=1
  for(k in 1:3){
    for(l in 1:10){
      #print(c(k,l))
      #print(mt2[k,l])
      tst.list[[m]]<-mt2[k,l]
      m=m+1
    }
  }
  
  slp<-as.list(cbind(i,flt,hll,mtn))
  slp<-c(slp,unlist(tst.list))
  slp<-unlist(as.numeric(slp))
  dd[[i]]<-slp
  plot(d)
  i=i+1
  }
print("Done")
# for some reason the loop breaks on the last iteration. You have to run the the rest by hand.
#Transpose dd into a df that can be joined to the original shapefile opened
output<-data.frame(t(dd))
colnames(output)<-c("id","Flat","Hilly","Mountain","fl_10","fl_20","fl_30","fl_40","fl_50","fl_60","fl_70","fl_80","fl_90","fl_100","hl_10","hl_20","hl_30","hl_40","hl_50","hl_60","hl_70","hl_80","hl_90","hl_100","mtn_10","mtn_20","mtn_30","mtn_40","mtn_50","mtn_60","mtn_70","mtn_80","mtn_90","mtn_100")

# Merge the data to the SpatialPloygonsDataFrame as per method found on Stack Overflow
# http://stackoverflow.com/questions/13135413/r-spcbind-error

c2<-c1
c2@data=data.frame(c1@data, output[match(c1@data$cat, output$id),])

writeOGR(obj=c2,dsn=".","Forest_Cover_CFP",driver="ESRI Shapefile")


output[] <- lapply(output, function(x) if(is.list(x)) unlist(x))









# Begin the plotting of the polygons and the generated statistics
library(plotrix)
i=1
colors = c("blue","green","yellow","red","orange","beige","darkgreen","lavender","yellow1","tomato")
for (i in 1:23){
  pdf(paste(c2@data[i,3],".pdf",sep=""))
  par(mfrow=c(1,4))
  par(mai=c(3.5,0,1,0))
  #Plot the polygon of interest
  tble<-as.data.frame(c2@data[i,10:12])
  tble.bbox<-bbox(c2[c2$cat==i,])
  plot(c2[c2$cat==i,])
  title(paste(c2@data[i,3]))
  addtable2plot(tble.bbox[1],tble.bbox[4],tble,bty="o",display.rownames=FALSE)

  #plot the pie chart in the next phase
  pfl.1<-output[i,5:14]
  pfl.2<-as.matrix(unlist(pfl.1))[1:10]
  pfl.2[is.na(pfl.2)]<-0
  lbs<-1:length(pfl.2)*10
  lbs<-paste(lbs,"% TC",sep="")
  names(pfl.2)<-c("10%","20%","30%","40%","50%","60%","70%","80%","90%","100%")
  barplot(pfl.2,col=colors,main="FC Flat Areas",ylim=c(0,100))
    
  phl.1<-output[i,15:24]
  phl.2<-as.matrix(unlist(phl.1))[1:10]
  phl.2[is.na(phl.2)]<-0
  names(phl.2)<-c("10%","20%","30%","40%","50%","60%","70%","80%","90%","100%")
  barplot(phl.2,col=colors,main="FC Hilly Areas",ylim=c(0,100))
  
  pmt.1<-output[i,24:33]
  pmt.2<-as.matrix(unlist(pmt.1))[1:10]
  pmt.2[is.na(pmt.2)]<-0
  names(pmt.2)<-c("10%","20%","30%","40%","50%","60%","70%","80%","90%","100%")
  barplot(pmt.2,col=colors,main="FC Mounatin Areas",ylim=c(0,100))
  dev.off()
  i=i+1  
  }




