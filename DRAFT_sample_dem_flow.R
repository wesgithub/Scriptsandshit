library(maptools)
library(rgdal)
library(spatstat)
library(raster)
library(rgeos)


map <- data.frame(list.files(pattern=".shp",full.names=FALSE))
weir <- readShapePoints(as.character(map[1,]))

Lst_mean <- list()

rastx<-10
rasty<-10

y <- length(weir$COUNT)
x <- 1
while (x <= y)
{
	a<-weir[weir$COUNT[x],]
	b<-gBuffer(a,byid=FALSE, width=0.001)
	box <- as.list(as.numeric(bbox(b)))

	xstart <- (as.numeric(box[1])-rastx)/0.000833333333333
	ystart <- abs((as.numeric(box[4])+rasty)/0.000833333333333)

	row <- round((as.numeric(box[3])-as.numeric(box[1]))/0.00008)
	col <- round((as.numeric(box[4])-as.numeric(box[2]))/0.00008)


	temp <- readGDAL("D:/work/Data/Raster_Data/SRTM_90v4/SRTM90.img",silent=TRUE, offset=c(ystart,xstart), region.dim=c(col,row))	
	RDEMImg<-raster(temp)
	c<-extract(RDEMImg,as.data.frame(a)[,4:5])
	Lst_mean[x] <- as.numeric(c)
	print(x)
	x=x+1
}

data_mean <- data.frame(as.numeric(Lst_mean))
weir2<-spCbind(weir[,1],as.vector(round(data_mean)))
nc <- ncol(weir2)
names(weir2) = c("Names","Elevation")

writePointsShape(weir2,"Tertiary_Catchments_Validation_Weirs_Heights.shp", factor2char = TRUE, max_nchar=254)