## Iranian Sampling grid for Zagros and perhaps Caspian Sea
## 10km2 sample plot every 
## R code to establish the sampling grid.
## WEsley Roberts
## jonathan.roberts@fao.org
## August 2017

library(rgdal)
library(sp)
library(raster)
# set working directory
wd <- "C:/Users/RobertsJo/Documents/FAO_Rome_2017/Data/GIS/Projects/Iran_TCP/Vector"
setwd(wd)
# read in the shapefiles

zag.utm.sp<-readOGR(dsn = ".",layer = "ZAGROS_FW_Point_Locations_utm39N")
# assign id of 1: length of the zagros points to create spatial points dataframe.
zag.utm.sp$id <- 1:length(zag.utm.sp)

keeps <- c("id")
zag.utm.sp <- zag.utm.sp[keeps]

######################################################################################################################
########################################################ZAGROS########################################################
######################################################################################################################
#Field sampling sites for the zagros region 1 site every 10km with associated field inventory site

plt.df <- as.data.frame(matrix(nrow = 1, ncol = 2))
results <- list()
i <- 1
for (i in 1:length(zag.utm.sp@coords[,1])){
  
  tpin <- as.data.frame(t(zag.utm.sp@coords[i,]))
  plt <- as.data.frame(matrix(nrow = 5, ncol = 2))
  #plt[1,1] <- tpin@coords[1]-10
  plt[1,1] <- tpin[1]-10
  plt[1,2] <- tpin[2]
  #top left
  plt[2,1] <- tpin[1]-10
  plt[2,2] <- tpin[2]+50
  #top right
  plt[3,1] <- tpin[1]+10
  plt[3,2] <- tpin[2]+50
  #bottom right
  plt[4,1] <- tpin[1]+10
  plt[4,2] <- tpin[2]
  #bottom left
  plt[5,1] <- tpin[1]-10
  plt[5,2] <- tpin[2]
  
  plt.1 <- Polygon(plt)
  plt.2 <- Polygons(list(plt.1), ID = i)
  plt.3 <- SpatialPolygons(list(plt.2))
  plt.df[,1] <- i
  plt.df[,2] <- paste("fw","zag",i,sep="_")
  names(plt.df) <- c("id","name")
  row.names(plt.df) <- i
  plt.4 <- SpatialPolygonsDataFrame(plt.3,plt.df)
  
  
  utm39 <- "+proj=utm +zone=39 +north +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
  proj4string(plt.4) = utm39
  results[[i]]<-plt.4
  print(i)
  
}
out <- do.call(bind, results)
writeOGR(obj=out, dsn=".", layer="ZAGROS_FW_POLY_Locations_utm39N", driver="ESRI Shapefile")

######################################################################################################################
########################################################CASPIAN#######################################################
######################################################################################################################
#Field sampling sites for the zagros region 1 site every 10km with associated field inventory site

cas.utm.sp<-readOGR(dsn = ".",layer = "CASPIAN_FW_Point_Locations_utm39N")

plt.df <- as.data.frame(matrix(nrow = 1, ncol = 2))
results <- list()
i <- 1
for (i in 1:length(cas.utm.sp@coords[,1])){
  
  tpin <- as.data.frame(t(cas.utm.sp@coords[i,]))
  plt <- as.data.frame(matrix(nrow = 5, ncol = 2))
  #plt[1,1] <- tpin@coords[1]-10
  plt[1,1] <- tpin[1]-10
  plt[1,2] <- tpin[2]
  #top left
  plt[2,1] <- tpin[1]-10
  plt[2,2] <- tpin[2]+50
  #top right
  plt[3,1] <- tpin[1]+10
  plt[3,2] <- tpin[2]+50
  #bottom right
  plt[4,1] <- tpin[1]+10
  plt[4,2] <- tpin[2]
  #bottom left
  plt[5,1] <- tpin[1]-10
  plt[5,2] <- tpin[2]
  
  plt.1 <- Polygon(plt)
  plt.2 <- Polygons(list(plt.1), ID = i)
  plt.3 <- SpatialPolygons(list(plt.2))
  plt.df[,1] <- i
  plt.df[,2] <- paste("fw","cas",i,sep="_")
  names(plt.df) <- c("id","name")
  row.names(plt.df) <- i
  plt.4 <- SpatialPolygonsDataFrame(plt.3,plt.df)
  
  
  utm39 <- "+proj=utm +zone=39 +north +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
  proj4string(plt.4) = utm39
  results[[i]]<-plt.4
  print(i)
  
}
out <- do.call(bind, results)
writeOGR(obj=out, dsn=".", layer="CASPIAN_FW_POLY_Locations_utm39N", driver="ESRI Shapefile")


######################################################################################################################
################################################ZAGROS- RS Sites######################################################
######################################################################################################################
#Remote sensing sampling sites for the zagros region 1 site every 50km with associated polygon for RS based analysis

zag.utm.sp<-readOGR(dsn = ".",layer = "ZAGROS_RS_Point_Locations_utm39N")

plt.df <- as.data.frame(matrix(nrow = 1, ncol = 2))
results <- list()
i <- 1
for (i in 1:length(zag.utm.sp@coords[,1])){
  
  tpin <- as.data.frame(t(zag.utm.sp@coords[i,]))
  plt <- as.data.frame(matrix(nrow = 5, ncol = 2))
  plt[1,1] <- tpin[1]-5000
  plt[1,2] <- tpin[2]
  #top left
  plt[2,1] <- tpin[1]-5000
  plt[2,2] <- tpin[2]+10000
  #top right
  plt[3,1] <- tpin[1]+5000
  plt[3,2] <- tpin[2]+10000
  #bottom right
  plt[4,1] <- tpin[1]+5000
  plt[4,2] <- tpin[2]
  #bottom left
  plt[5,1] <- tpin[1]-5000
  plt[5,2] <- tpin[2]
  
  plt.1 <- Polygon(plt)
  plt.2 <- Polygons(list(plt.1), ID = i)
  plt.3 <- SpatialPolygons(list(plt.2))
  plt.df[,1] <- i
  plt.df[,2] <- paste("rs","zag",i,sep="_")
  names(plt.df) <- c("id","name")
  row.names(plt.df) <- i
  plt.4 <- SpatialPolygonsDataFrame(plt.3,plt.df)
  
  
  utm39 <- "+proj=utm +zone=39 +north +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
  proj4string(plt.4) = utm39
  results[[i]]<-plt.4
  print(i)
  
}
out <- do.call(bind, results)
writeOGR(obj=out, dsn=".", layer="ZAGROS_RS_POLY_Locations_utm39N", driver="ESRI Shapefile")

######################################################################################################################
##############################################CASPIAN - RS Sites######################################################
######################################################################################################################
#Remote sensing sampling sites for the zagros region 1 site every 50km with associated polygon for RS based analysis

cas.utm.sp<-readOGR(dsn = ".",layer = "CASPIAN_RS_Point_Locations_utm39N")

plt.df <- as.data.frame(matrix(nrow = 1, ncol = 2))
results <- list()
i <- 1
for (i in 1:length(cas.utm.sp@coords[,1])){
  
  tpin <- as.data.frame(t(cas.utm.sp@coords[i,]))
  plt <- as.data.frame(matrix(nrow = 5, ncol = 2))
  plt[1,1] <- tpin[1]-5000
  plt[1,2] <- tpin[2]
  #top left
  plt[2,1] <- tpin[1]-5000
  plt[2,2] <- tpin[2]+10000
  #top right
  plt[3,1] <- tpin[1]+5000
  plt[3,2] <- tpin[2]+10000
  #bottom right
  plt[4,1] <- tpin[1]+5000
  plt[4,2] <- tpin[2]
  #bottom left
  plt[5,1] <- tpin[1]-5000
  plt[5,2] <- tpin[2]
  
  plt.1 <- Polygon(plt)
  plt.2 <- Polygons(list(plt.1), ID = i)
  plt.3 <- SpatialPolygons(list(plt.2))
  plt.df[,1] <- i
  plt.df[,2] <- paste("rs","cas",i,sep="_")
  names(plt.df) <- c("id","name")
  row.names(plt.df) <- i
  plt.4 <- SpatialPolygonsDataFrame(plt.3,plt.df)
  
  
  utm39 <- "+proj=utm +zone=39 +north +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
  proj4string(plt.4) = utm39
  results[[i]]<-plt.4
  print(i)
  
}
out <- do.call(bind, results)
writeOGR(obj=out, dsn=".", layer="CASPIAN_RS_POLY_Locations_utm39N", driver="ESRI Shapefile")


