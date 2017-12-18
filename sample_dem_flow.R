# R Program to read and print to file mean, median, sqrt, and mode of NDVI values for each polygon in the shapefile
# 31st March 2008
# WEsley Roberts
# CSIR Stellenbosch
# path to script source("/media/sda2/wes2006/Projects/Evapotranspiration/Data/Landsat_NDVI/scripts/read.print.01.R")

library(maptools)
library(rgdal)
library(spatstat)

#This is the input for the reading of the image files including their paths and names

input <- "/media/sda2/wes2006/Projects/Evapotranspiration/Data/Landsat_NDVI"
maps <- data.frame((list.files(input, pattern=".img",full.names=FALSE)),(list.files(input, pattern=".img", full.names=TRUE)))
names(maps) <- c("File", "Path")
fn=data.frame(maps$File)

rastx<-284055.000
rasty<-6302475.000

Lst_mean <- list()
Lst_median <- list()
Lst_stddev <- list()
Lst_mode <- list()

brede <- readShapePoly("/media/sda2/wes2006/Projects/Evapotranspiration/Data/WFW_Data/R-pro/Berg_River_project2.shp", IDvar="COUNT", proj4string=CRS("+proj=utm +zone=34 +south +ellps=WGS84 +datum=WGS84 +units=m +no_defs"))

output <- data.frame(fn)
names(output) <- c("Date")

y <- length(brede$COUNT)
x=1
while (x <= y)
{
		nfiles <- length(maps$Path) 
		for (n in 1:nfiles)
		{  
		   brede_add <- brede[brede$COUNT[x], ]
		   box <- as.list(as.numeric(bbox(brede_add)))
		   xstart <- (as.numeric(box[1])-rastx)/30
		   ystart <- abs((as.numeric(box[4])-rasty)/30)
		   
		   row <- round((as.numeric(box[3])-as.numeric(box[1]))/30)
		   col <- round((as.numeric(box[4])-as.numeric(box[2]))/30)
		   
		   temp <- readGDAL(as.character(maps$Path[n]),silent=TRUE, offset=c(ystart,xstart), region.dim=c(col,row))
		   
		   temp2 <- as(temp, "SpatialGridDataFrame")
		   gridded(temp2) = FALSE	   
		   x.clip <- temp2[!is.na(overlay(temp2, brede_add)),]
		   
		   #calculate statistics for each polygon
		   
		   a <- mean(x.clip$band1)
		   b <- median(x.clip$band1)
		   c <- sqrt(var(x.clip$band1))
		   d.1 <- table(round(x.clip$band1,1))
		   d <- as.numeric(names(d.1)[which.max(d.1)])
		   
		   #write stats to lists defined earlier
		   
		   Lst_mean[n] <- as.numeric(a)
		   Lst_median[n] <- as.numeric(b)
		   Lst_stddev[n] <- as.numeric(c)
		   Lst_mode[n] <- as.numeric(d)
		   
		   print(n)
		   x.clip<-0
		   rm(a,b,c,d,d.1)
		 } 
	
	data_mean <- data.frame(as.numeric(Lst_mean))
	data_median <- data.frame(as.numeric(Lst_median))
	data_stddev <- data.frame(as.numeric(Lst_stddev))
	data_mode <- data.frame(as.numeric(Lst_mode))
	
	
	names(data_mean) <- brede$NBALID[x]
	names(data_median) <- brede$NBALID[x]
	names(data_stddev) <- brede$NBALID[x]
	names(data_mode) <- brede$NBALID[x]
	
	out_mean <- data.frame(output,data_mean)
	out_median <- data.frame(output,data_median)
	out_stddev <- data.frame(output,data_stddev)
	out_mode <- data.frame(output,data_mode)
		
	print(paste(brede$NBALID[x]))
	x<-x+1
}
print("writing out mean table")
write.table(out_mean, "Berg_River_project_mean.csv")

print("writing out median table")
write.table(out_median, "Berg_River_project_median.csv")

print("writing out std dev table")
write.table(out_stddev, "Berg_River_project_stddev.csv")

print("writing out mode table")
write.table(out_mode, "Berg_River_project_mode.csv")
