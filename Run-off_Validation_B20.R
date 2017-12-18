#############################################################################################################################################
#R Code to read in Weir data as discharge for a particular catchment and window to the period of interest
#Wesley Roberts
#06-02-2010
#Stellenbosch, South Africa
#The script is designed to work on Weir data downloaded from the DWA website (http://www.dwa.gov.za/Hydrology/CGI-BIN/HIS/CGIHis.exe/Station)
#Check to make sure that the file name is correct and that the code makes use of a suitable start and end date.
#############################################################################################################################################
library(rgdal)
library(zoo)
library(maptools)
library(rgeos)
library(gpclib)
library(raster)
library(hydroGOF)
library(gplots)

map <- data.frame(list.files(pattern=".txt",full.names=FALSE))

a<-read.csv(as.character(map[1,]), skip=9, header=TRUE, sep = "")
b<-length(a)-2
c<-a[,2:b]
#c[c==0]<-NA
d<-zooreg(c, start = as.Date("2005-03-09"))
e<-window(d, start = as.Date("2005-03-09"), end = as.Date("2011-05-02"))
names(e) <-c("Flow","Qual")

#############################################################Daily data now available for analysis#############################################################

#############################################################Extracting values from raster maps#############################################################

input<-"D:/work/Data/Validation_CCAM/Data/scratch/flow/ccam_data/runoff"

maps <- data.frame((list.files(input, pattern=".tiff",full.names=TRUE)))
names(maps)<-c("Path")

rastx<-16.00
rasty<--21.80
vector <- readShapePoly("D:/work/Data/Validation_CCAM/Data/scratch/flow/Validation_Analysis/Site_4/B20/B20.shp")

##Bounding Box
box <- as.list(as.numeric(bbox(vector)))
xstart <- floor((as.numeric(box[1])-rastx)/0.15)
ystart <- round(abs((as.numeric(box[4])-rasty)/0.15))
row <- round((as.numeric(box[3])-as.numeric(box[1]))/0.15)+1
col <- round((as.numeric(box[4])-as.numeric(box[2]))/0.15)+1

#open image using the bounding coordinates defined by the catchment of interest
temp <- readGDAL(as.character(maps$Path[1]),silent=TRUE, offset=c(ystart,xstart), region.dim=c(col,row))

#interim conversion to create the vector grid matching the size and dimensions of the extracted image

temp3<-as((as(temp,"SpatialPixelsDataFrame")),"SpatialPolygonsDataFrame")

#intersect the vector and the raster grid to extract the grids of interest and to create the weightings
int <- gIntersects(vector, temp3, byid=TRUE)
vec <- vector(mode="list", length=dim(int)[2])
for (i in seq(along=vec)) vec[[i]] <- try(gIntersection(vector[i,], temp3[int[,i],], byid=TRUE))
out <- do.call("rbind", vec)
out<-as(out, "SpatialPolygonsDataFrame")

#Calculate the percent area of each polygon and write it to the attribute of the vector of interest.
out2<-spCbind(out,round(sapply(slot(out, "polygons"), slot, "area"),6)/0.0225)
names(out2)<-c("dummy","Weight")

#generate centroids from the above 
test<-gCentroid(out2, byid=T, id = NULL)

#loop through imagery extract, weight, and sum then write to a list

Lst_sum <- list()
nfiles <- length(maps$Path) 
	for (n in 1:nfiles)
	{
	temp <- readGDAL(as.character(maps$Path[n]),silent=TRUE, offset=c(ystart,xstart), region.dim=c(col,row))

	#use centroids to extract the value from the raster
	rst<-raster(temp)
	rst_values<-extract(rst,test)

	#join values to the shapefile 
	out3<-spCbind(out2,as.data.frame(rst_values)[,1])
	names(out3)<-c("dummy","Weight","Values")
	out4<-spCbind(out3,round(out3$Weight*out3$Values,4))
	names(out4)<-c("dummy","Weight","Values","Result")
	out5<-sum(out4$Result)
	Lst_sum[n]<-as.numeric(out5)
	print(n)
	}

#Windowing data to the suitable time steps - THIS WILL VARYING ACCORDING TO THE IN SITU DATA
m_disch<-data.frame(as.numeric(Lst_sum))
m_disch.zoo<-zooreg(m_disch, start = as.Date("1989-01-01"), end = as.Date("2009-12-31"))

#Validation Time Period - CHANGE ACCORDING TO I AND K IN Manage_data.ods
m_dish.zoo.win<-window(m_disch.zoo, start = as.Date("2006-01-01"), end = as.Date("2009-12-31"))
e.zoo<-window(e[,1], start = as.Date("2006-01-01"), end = as.Date("2009-12-31"))

Simulation<-m_dish.zoo.win
Observation<-e.zoo
Simulation[ is.na(Simulation) ] <- 0
Observation[ is.na(Observation) ] <- 0

#----------------------------------------------------------Validation Stats 1----------------------------------------------------------#
#############Graphical Goodness of Fit Metrics using GGOF from the package hydroGOF#############

pdf("B20_Annual_Monthly_Daily.pdf")
ggof(Simulation,Observation, main="Observations vs Simulations", ylab="Discharge", ftype="dma", FUN=sum)
dev.off()
Daily.agg <- cbind(Simulation, Observation)

#----------------------------------------------------------Validation Stats 2----------------------------------------------------------#
#############Basic Summary stats including time series plots #############

pdf("B20_Time_Diff_Daily.pdf")
Daily_Diff<-Daily.agg[,1]-Daily.agg[,2]
Daily.agg <- cbind(Daily.agg, Daily_Diff)
plot(Daily.agg, main="B20 Daily Time Series", xlab="Time")
dev.off()

#############Cumulative sum plots#############

pdf("B20_CumSum_Daily.pdf")
plot(cumsum(Daily.agg[,1]),col=2, ylab="Cumulative Sum",main="B20 Cumulative Sum: Run-off")
lines(cumsum(Daily.agg[,2]), col=4)
legend("topleft", inset=.05,c("Simulation","Observed"), lty=c(1,1),lwd=c(2.5,2.5),col=c("red","blue"))
dev.off()


#----------------------------------------------------------Validation Stats 4----------------------------------------------------------#
#Seasonal GOF analyses # Make sure the data starts at the first quarter or the 1 December so as to properly define
#the begining and end of the seasonal months
Daily.sea <- window(Daily.agg, start = as.Date("2006-01-01"), end = as.Date("2009-12-31"))
names(Daily.sea)<-c("Simulation","Observation","Difference")
seas <- as.numeric(format(as.yearqtr(as.yearmon(time(Daily.sea)) + 1/12), "%q"))


sea<-c("DJF","MAM","JJA","SON")
stat<-c("Observed-vs-Simulation")
end<-c(".pdf")
n=1
	while (n <= 4)
	{
	print(n)
	pdf(paste(sea[n],stat,end,sep="_"))
	day<-Daily.sea[seas == n]
	day.gof<-gof(as.zoo(day$Simulation), as.zoo(day$Observation))
	day.lm<-lm(as.zoo(day$Simulation)~as.zoo(day$Observation))
	par(oma=c(1,0,0,0))
	par(mar=c(4,4,2,2))
	nf <- layout(matrix(c(1,1,2,2),2,2,byrow=FALSE), widths=c(4,1), heights=c(4,1), TRUE)
	plot(as.zoo(day$Observation),as.zoo(day$Simulation), xlab="Obs", ylab="Sim", main=paste(sea[n],stat))
	abline(day.lm)
	abline(0,1)
	day.gof<-as.data.frame(day.gof)
	names(day.gof)<-c("Stats")
	textplot(capture.output(day.gof),halign="left",valign="top",cex=0.8)
	n=n+1
	dev.off()
	}