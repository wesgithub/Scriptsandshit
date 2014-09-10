# Wesley Roberts
# R script to calculate and save mapping criteria for site selection
# The script will only work with data that is spatially coincident with the RASTER images used
# 09-09-2014

require(rgdal)
require("R.utils")
require(raster)
require(maptools)
require(SDMTools)
require(RColorBrewer)
require(rgeos)

#######################################OPEN SHAPEFILE###########################################################
setwd("C:/Users/carbon-gis/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/NASA_FIRMS")
# Open fire data csv file. User is prompted to select the file which needs to be mapped / analyzed
# select the shapefile and edit path and filename such that OGR recognises the inputs and will open it regardless 
# of the file name or path
a<-file.choose()
b<-basename(a)
b<-substr(b,1,(nchar(b)-4))
c<-dirname(a)
setwd(c)
c1<-readOGR(dsn=".",layer=b)
c2<-spTransform(c1, CRS("+proj=utm +zone=36 +south +datum=WGS84 +units=m +no_defs"))
#######################################OPEN SHAPEFILE##########################################################


#######################################cREATE A DATAFRAME TO SAVE THE DATA TO##################################
dd=data.frame(matrix(nrow=length(c1), ncol=12))
names(dd)<-c("id","area","perm","area_ha","flt","hll","mtn","forest","co2_ha","co2_tot","threat","threat_bnd")
#######################################cREATE A DATAFRAME TO SAVE THE DATA TO##################################


####################################FOR LOOP TO CALCULATE CRITERIA OF INTEREST#################################

i=1
for (i in 1:length(c2)) {
  d<-c2[c2$id==i,]
  ee<-data.frame(matrix(nrow=1, ncol=12))
  ee[,1]<-i
  ee[,2]<-gArea(d)
  ee[,3]<-gLength(d)
  ee[,4]<-gArea(d)/10000
#######################Topography#######################
  e<-raster("C:/Users/carbon-gis/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/SiteSelectionScratch/test_SL.tif")
  f<-crop(e,d)
  g<-mask(f,d)
  h<-as.data.frame(freq(g))
  j<-subset(h, value<4&value>0)
  ee[,5]<-round(j[1,2]/(j[1,2]+j[2,2]+j[3,2])*100,2)
  ee[,6]<-round(j[2,2]/(j[1,2]+j[2,2]+j[3,2])*100,2)
  ee[,7]<-round(j[3,2]/(j[1,2]+j[2,2]+j[3,2])*100,2)
  rm(e,f,g,h,j)
########################Forest Cover##########################
  e<-raster("C:/Users/carbon-gis/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/Hansen_Global_Forest_Change/Tree_Cover_2000/Hansen_GFC2013_TreeCover_GT10_UTM36s_Sieved_NoNull.tif")
  f<-crop(e,d)
  g<-mask(f,d)
  h<-as.data.frame(freq(g))
  j<-round(h[1,2]/(h[1,2]+h[2,2])*100,2)
  ee[,8]<-j
  rm(e,f,g,h,j)
#######################SAATCHI CARBON########################
  e<-raster("C:/Users/carbon-gis/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/Saatchi_Carbon/Saatchi_EprovUTM36s.tif")
  f<-crop(e,d)
  g<-mask(f,d)
  ee[,9]<-round(cellStats(g,stat="mean"),2)
  ee[,10]<-round(cellStats(g,stat="mean")*ee[,4],2)
  rm(e,f,g)
########################THREAT##############################
  e<-raster("C:/Users/carbon-gis/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/USFS_ChangeDetection_Data/Scratch_SiteSelection_EP/Combined_USFS_Hansen_dilate_cross_3x3_close_ball_5x5_sieve_15_8.tif")
  f<-crop(e,d)
  g<-mask(f,d)
  h<-as.data.frame(freq(g))
  j<-round(h[2,2]/h[1,2]*100,2)
  ee[,11]<-j

  pol <- rasterToPolygons(f, fun=function(f){f==1})
  pol_buf <- gBuffer(spgeom=pol,width=120)
  dl<-as(d,"SpatialLines")
  int<-gIntersection(dl,pol_buf)
  ee[,12]<-round(gLength(int)/ee[,3]*100,2)
  rm(e,f,g,h,j,pol,pol_buf,dl,int)
  dd[i,1:12]<-ee
  i=i+1
}

cc<-paste(b,"_criteriaMaps",sep="")
c2@data=data.frame(c2@data, dd[match(c2@data$id, dd$id),])

writeOGR(obj=c2,dsn=".",cc,driver="ESRI Shapefile",overwrite_layer=TRUE)
