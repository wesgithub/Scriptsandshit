library(fpc)
library(rgdal)
library(randomForest)
library(maptools)
library(sp)
library(raster)

# Set working directory for the project
setwd("C:/Users/biocarbon/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/scratch/VCS_CDMPointsUpdate_2013-09-09/R_Classification")

# Open the training and the classification data sets
tr <- readOGR(dsn=".",layer="25_Percent_Train")
cl <- readOGR(dsn=".",layer="25_Percent_Test")

# Open the raster image of interest and convert it to a raster stack
image <- readGDAL(fname="19890713_Registered_VCS_CDM_UTM35S.tif")
image_2 <-stack(raster(image[1]),raster(image[2]),raster(image[3]),raster(image[4]),raster(image[5]),raster(image[6]))

# extract raster values for both the training and the classification data sets
train.dat <- extract(image_2,tr)
class.dat <- extract(image_2,cl)

# combine the raster values into a data frame ready for modelling and classification
train.dat2 <- cbind(as.data.frame(tr)[1:2],train.dat)
class.dat2 <- cbind(as.data.frame(cl)[1:2],class.dat)

# Develop classification model using random forests

test <- class.dat2[,-1:-2]

labels <- as.factor(train.dat2[,2])
train <- train.dat2[,-1:-2]


rf <- randomForest(train, labels, xtest=test, ntree=5000,do.trace=TRUE) 
sink('summary25_percent_Sample.txt') # output logistic model summary to working directory
rf
sink()

predictions <- levels(labels)[rf$test$predicted]

out<-spCbind(cl,as.data.frame(predictions))

names(out) <- c("PID","RB_89","RF_89")

writeOGR(out,'.',layer="25_Percent_Output",driver="ESRI Shapefile",overwrite_layer=TRUE)

a=0
b=0
c=0
d=0
x=1
nlength<-length(out)
for (x in 1:nlength)
{
ifelse(out$RB_89[x]==1 && out$RF_89[x]==1, (a=a+1), ifelse(out$RB_89[x]==2 && out$RF_89[x]==2, (b=b+1), ifelse(out$RB_89[x]==1 && out$RF_89[x]==2, (c=c+1), ifelse(out$RB_89[x]==2 && out$RF_89[x]==1, (d=d+1)))))
print (a)
}
print ("Forest Classified as Forest")
print (a)
print ("Non-Forest Classified as Non-Forest")
print (b)
print ("Forest Classified as Non-Forest")
print (c)
print ("Non-Forest Classified as Forest")
print (d)