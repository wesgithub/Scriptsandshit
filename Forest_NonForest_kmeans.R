# Forest non-forest map using dbscan
# Wesley Roberts
# BioCarbon Partners
# Kalk Bay
# 2013/07/16

library(fpc)
library(rgdal)
library(randomForest)
library(maptools)
library(zoo)
setwd("~/BCP_Data/Projects/Zam_Rufunsa/Raster/AA_VCS_Data/Forest_NonForestMap/output")

a<-readOGR(dsn=".",layer="2009_segmentation_2beClass")
b<-as.data.frame(a)
c<-b[,c("bnd1_mean","bnd2_mean","bnd3_mean","bnd4_mean","bnd5_mean","bnd6_mean","ASPCT_mean","SLPE_mean")]
c<-na.approx(c, rule=2)
x <- scale(na.omit(c))

d<-kmeans(x, 15, iter.max = 100, nstart = 1, algorithm = c("Hartigan-Wong"))
k_means<-as.data.frame(d$cluster)
bb<-length(k_means[,1])-1
row.names(k_means)<-0:bb
e<-spCbind(a,k_means)
writeOGR(e,'.',layer="2009_Classified",driver="ESRI Shapefile",overwrite_layer=TRUE)



