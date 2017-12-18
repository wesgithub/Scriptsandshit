library(sp)
library(rgdal)
library(hyperSpec)
library(gdalUtils)
library(raster)
gdal_setInstallation(search_path="C:/OSGeo4W64/bin",rescan=TRUE,verbose=TRUE)



file1<-file.choose()
file2<-basename(file1)
file3<-substr(file2,1,(nchar(file2)-4))
file4<-dirname(file1)
setwd(file4)

a<-as.data.frame(list.files(path=".", pattern="*.hdr$",recursive=TRUE))
# Remove the .hdr from the filenames
b<-a
c<-data.frame(matrix(nrow=length(b[,1]), ncol=1))
names(c)<-c("files")
h<-1
for (h in 1:length(a[,1])) {
  c[h,]<-(gsub(".hdr",'',a[h,]))
}

#Convert all files from ENVI to tiff

for (i in 1:length(c[,1])){
  gdal_translate(c[i,], paste0(file3, i, ".tiff"))
  #print(c[i,])
  }


#list <- list.files(".", pattern="tiff$",full.names=TRUE)
#gdalwarp(srcfile=list, t_srs="+proj=longlat +datum=WGS84 +no_defs",dstfile=paste0(file3, "mosiac", ".tiff"))

# Change directory into the directory of your choice
#setwd("C:/Users/carbon-gis/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/JAXA_PALSAR/25mResOriginalData/2010")

# Mosaic images into one large scene for the year you are processing. Begin 
list <- list.files(".", pattern="tiff$",full.names=TRUE)
gdalwarp(srcfile=list, t_srs="+proj=longlat +datum=WGS84 +no_defs",dstfile=paste0("PALSAR_2010_mosaic", ".tiff"))

