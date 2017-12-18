#extract ET values from MODIS ET Imagery MOD16
#Wesley Roberts
#Stellenbosch
#2011/11/24


library(maptools)
library(rgdal)
library(spatstat)
library(raster)
library(zoo)

#####CREATE Zoo object to use later

year1<-zooreg(1:46, start = as.Date("2000-01-01"), frequency=1/8)
year2<-zooreg(1:46, start = as.Date("2001-01-01"), frequency=1/8)
year3<-zooreg(1:46, start = as.Date("2002-01-01"), frequency=1/8)
year4<-zooreg(1:46, start = as.Date("2003-01-01"), frequency=1/8)
year5<-zooreg(1:46, start = as.Date("2004-01-01"), frequency=1/8)
year6<-zooreg(1:46, start = as.Date("2005-01-01"), frequency=1/8)
year7<-zooreg(1:46, start = as.Date("2006-01-01"), frequency=1/8)
year8<-zooreg(1:46, start = as.Date("2007-01-01"), frequency=1/8)
year9<-zooreg(1:46, start = as.Date("2008-01-01"), frequency=1/8)
year10<-zooreg(1:46, start = as.Date("2009-01-01"), frequency=1/8)
year11<-zooreg(1:46, start = as.Date("2010-01-01"), frequency=1/8)
year<-rbind(year1,year2,year3,year4,year5,year6,year7,year8,year9,year10,year11)


h20v11<-"F:/MODIS_ET-8day/h20v11"
shape<- readShapePoints("D:/work/Data/Validation_ET/Sites/h20v11_Validation_DataBase_Ver1_Unique_Name.shp")

rastx<-21.2835554
rasty<--20.0000000
res<-0.008461888431599
###############################################################################################################
##Begining of the first loop - Here each vector is iteratively selected and submitted to the nested loop for ##
##processing.																 ##
###############################################################################################################

m<-1
n<-1
nfiles<-length(shape$COUNT)
for (n in 1:nfiles)
	{
	Lst_mean <- list()
	shape_sel<-shape[shape$COUNT[n],]
	box <- as.list(as.numeric(bbox(shape_sel)))
	xstart <- abs((as.numeric(box[1])-rastx)/res)
	ystart <- abs((as.numeric(box[4])-(rasty))/res)
	imgs<-data.frame((list.files(h20v11, pattern=".tif",full.names=FALSE)),(list.files(h20v11, pattern=".tif", full.names=TRUE)))
	names(imgs) <- c("File", "Path")
	fn=data.frame(imgs$File)
	print(shape_sel$Name)
	n<-n+1
###################################################################################################################
##Begining of the inside loop - Here images are read in using the dims derived above with values saved to a list ##
##The list is then converted to a zooreg then to data.frame and saved before the loop returns to the top and a   ##
##new vector location is slected                                                                                 ##
###################################################################################################################
	nimages<-length(imgs[,1])
	m<-1
	for (p in 1:nimages)
		{
		temp <- raster(readGDAL(as.character(imgs$Path[m]),silent=TRUE, offset=c(ystart,xstart), region.dim=c(1,1)))
		a<-extract(temp,1,1)*0.1
		Lst_mean[p] <- a
		m<-m+1
		}
	temp_list<-Lst_mean
	temp_list<-as.data.frame(as.numeric(temp_list))
	bind<-cbind(year,temp_list[,1])
	bind<-bind[,2]
	bind<-as.data.frame(bind)
	names(bind)<-paste(shape_sel$Name)
	dd<-paste("h20v11_",substr(as.vector(names(bind)),2,8),".txt",sep="")
	write.table(bind,dd)
	rm(bind,Lst_mean)
	print(paste("finished",dd))
	
}




