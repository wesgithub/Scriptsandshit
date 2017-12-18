#Zimbabwe GFS sites

library(rgdal)
library(sp)
# set working directory
wd <- "C:/Users/RobertsJo/Documents/FAO_Rome_2017/NFI_Work/GFS/Zimbabwe/GFS_Zim_survey_plots"
setwd(wd)

plt <- readOGR(dsn = ".",layer = "GFS_Zim_Forest_survey_plots_utm35S")


results <- list() 

i <- 1
  for (i in 1:length(plt@coords[,1])){
    
    plot1 <- as.data.frame(t(plt@coords[i,]))
    plot2 <- plot1
    plot2[,2] <- plot1[,2]+500
    plot3 <- plot2
    plot3[,1] <- plot2[,1]+500
    plot4 <- plot3
    plot4[,2] <-plot3[,2]-500
    clus <- rbind(plot1,plot2,plot3,plot4)
    clus$cluster<-plt$public_id[i]
    clus["id"] <- c(1,2,3,4)
    coordinates(clus) <- ~coords.x1+coords.x2
    utm35 <- "+proj=utm +zone=35 +south +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
    proj4string(clus) = utm35
    
    results[[i]]<-clus
    
  }


x <- do.call("rbind", results)

writeOGR(obj=x, dsn=".", layer="GFS_Zimbabwe_2017_Cluster-Plots_utm35s", driver="ESRI Shapefile")


