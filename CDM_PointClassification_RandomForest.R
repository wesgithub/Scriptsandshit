# Wesley Roberts
# Run sample CDM using RandomForests
# 2013-10-21

#libraries

library(fpc)
library(rgdal)
library(randomForest)
library(maptools)
library(sp)
library(raster)

x=6


setwd("C:/Users/biocarbon/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/AA_VCS_Data/Scratch/VCS_Phased_Approach/RF_Classification")
# Open the Training data
cl <- readOGR(dsn=".",layer="Input_CDM_Points_09")
tr <- readOGR(dsn=".",layer="Train_2009")


# Open the Imagery & Convert the image to a raster stack 
fl<-as.data.frame(list.files(pattern="*.tif"))
image <- readGDAL(fname=paste(fl[x,]))
image_2 <-stack(raster(image[1]),raster(image[2]),raster(image[3]),raster(image[4]),raster(image[5]),raster(image[6]))

# Extract the values from the bands and combine with the training data
cl.dat <-extract(image_2,cl)
test<-as.data.frame(cl.dat)
train.dat <- extract(image_2,tr)
train.dat2 <- cbind(as.data.frame(tr)[1:2],train.dat)

# Train the Random Forest classifier using the training data
labels <- as.factor(train.dat2[,2])
train <- train.dat2[,-1:-2]

rf <- randomForest(train, labels, xtest=test, ntree=500,do.trace=TRUE,importance=TRUE) 
sink('09_AllData.txt') # output logistic model summary to working directory
rf
sink()

predictions <- levels(labels)[rf$test$predicted]

out<-spCbind(cl,as.data.frame(predictions))
names(out)<-c("ID","input","Y_2009")
writeOGR(out,'.',layer="CDM_2009",driver="ESRI Shapefile",overwrite_layer=TRUE)

# Save the output to a new shapefile







