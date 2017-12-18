library(fpc)
library(rgdal)
library(randomForest)
library(maptools)
library(sp)
library(raster)

# Set working directory for the project
setwd("C:/Users/biocarbon/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/scratch/VCS_CDMPointsUpdate_2013-09-09/2009")

# Open the training and the classification data sets
tr <- readOGR(dsn=".",layer="Base_2009")
cl <- readOGR(dsn=".",layer="2009_Additional")

# Open the raster image of interest and convert it to a raster stack
image <- readGDAL(fname="20090501_Registered_VCS_CDM_UTM35S.tif")
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
sink('summary_2009.txt') # output logistic model summary to working directory
rf
sink()

predictions <- levels(labels)[rf$test$predicted]

out<-spCbind(cl,as.data.frame(predictions))

names(out) <- c("PID","RF_02","RF_09")
writeOGR(out,'.',layer="RF09_Add",driver="ESRI Shapefile",overwrite_layer=TRUE)