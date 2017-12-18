## R script to doownload MODIS Data, convert to suitable format and mosiac 
## for two dates, 2000 and 2012 (3rd TimeStep of April). Then conduct CVA using 
## both EVI and Albedo imagery. May be useful to normalise data from 0 - 1
## before conducting the CVA.
## Wesley Roberts
## BioCarbon partners
## Kalk Bay, Cape Town, South Africa
## 2013/05/06

rm(list = ls(all = TRUE))
wd="C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS"
setwd(wd)

library(landsat)
library(raster)
library(rgdal)
library(maptools)

## Downloaded MODIS Data.
# library(MODIS)
# ext <- getTile(tileH=20:21,tileV=10)
# Download MODIS Data using the runGdal function in 
# runGdal(product="MOD13A1", extent=ext, begin="2000.05.08", end="2000.07.27", SDSstring="010000000000",outProj="EPSG:4326")
# runGdal(product="MCD43B3", extent=ext, begin="2000.05.08", end="2000.07.27", SDSstring="101",outProj="EPSG:4326")
# runGdal(product="MOD13A1", extent=ext, begin="2012.05.08", end="2012.07.27", SDSstring="010000000000",outProj="EPSG:4326")
# runGdal(product="MOD13A1", extent=ext, begin="2012.07.11", end="2012.07.27", SDSstring="010000000000",outProj="EPSG:4326")
# runGdal(product="MCD43B3", extent=ext, begin="2012.05.08", end="2012.07.27", SDSstring="101",outProj="EPSG:4326")
# Seems to be an error with this one - Downloaded and processed by hand (runGdal(product="MOD13A1", extent=ext, begin="2012.06.25", end="2012.06.25", SDSstring="010000000000",outProj="EPSG:4326"))


## Open the shapefile of interest and generate an extent from the data.

shape <- readShapePoly("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Vector/CVA_Extent/StudyAreaExtent.shp")
clip <- extent(shape)
## Open each time step for the EVI imagery and process 2000
mod.129 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MOD13A1.005_20130502155018-2000/MOD13A1.A2000129.500m_16_days_EVI.tif")
mod.145 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MOD13A1.005_20130502155018-2000/MOD13A1.A2000145.500m_16_days_EVI.tif")
mod.161 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MOD13A1.005_20130502155018-2000/MOD13A1.A2000161.500m_16_days_EVI.tif")
mod.177 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MOD13A1.005_20130502155018-2000/MOD13A1.A2000177.500m_16_days_EVI.tif")
mod.193 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MOD13A1.005_20130502155018-2000/MOD13A1.A2000193.500m_16_days_EVI.tif")
mod.209 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MOD13A1.005_20130502155018-2000/MOD13A1.A2000209.500m_16_days_EVI.tif")
## Create a rasterBrick 
evi.2000 <- list(mod.129,mod.145,mod.161,mod.177,mod.193,mod.209)
names(evi.2000)<-c("1","2","3","4","5","6")
evi.2000.b <- brick(evi.2000)
## Crop the raster brick using the extent generated earlier
evi.2000.b.c <- crop(evi.2000.b,clip)
## Remove -3000 and convert to NA
evi.2000.b.c.na <- calc(evi.2000.b.c, function(x) ifelse(x == -3000, NA, x))
## Apply the conversion coef to the data to 
evi.2000.b.c.na.cor <- evi.2000.b.c.na/10000
###############################################################################################################
## IMAGE TO USE FOR THE CVA ANALYSIS BELOW - CHANGE WHEN TESTING
evi.2000.f <- max(evi.2000.b.c.na.cor,na.rm=TRUE)
###############################################################################################################

## Open each time step for the EVI imagery and process 2012
mod.129 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MOD13A1.005_20130503074859-2012/MOD13A1.A2012129.500m_16_days_EVI.tif")
mod.145 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MOD13A1.005_20130503074859-2012/MOD13A1.A2012145.500m_16_days_EVI.tif")
mod.161 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MOD13A1.005_20130503074859-2012/MOD13A1.A2012161.500m_16_days_EVI.tif")
mod.177 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MOD13A1.005_20130503074859-2012/MOD13A1.A2012177.500m_16_days_EVI.tif")
mod.193 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MOD13A1.005_20130503074859-2012/MOD13A1.A2012193.500m_16_days_EVI.tif")
mod.209 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MOD13A1.005_20130503074859-2012/MOD13A1.A2012209.500m_16_days_EVI.tif")
## Create a rasterBrick 
evi.2012 <- list(mod.129,mod.145,mod.161,mod.177,mod.193,mod.209)
names(evi.2012)<-c("1","2","3","4","5","6")
evi.2012.b <- brick(evi.2012)
## Crop the raster brick using the extent generated earlier
evi.2012.b.c <- crop(evi.2012.b,clip)
## Remove -3000 and convert to NA
evi.2012.b.c.na <- calc(evi.2012.b.c, function(x) ifelse(x == -3000, NA, x))
## Apply the conversion coef to the data to 
evi.2012.b.c.na.cor <- evi.2012.b.c.na/10000
###############################################################################################################
## IMAGE TO USE FOR THE CVA ANALYSIS BELOW - CHANGE WHEN TESTING
evi.2012.f <- max(evi.2012.b.c.na.cor,na.rm=TRUE)
###############################################################################################################

######################################################ALBEDO2000######################################################
#Albedo scale factor 0.0010

mcd.00.129 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130502192506-2000/MCD43B3.A2000129.Albedo_BSA_Band1.tif")
mcd.00.137 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130502192506-2000/MCD43B3.A2000137.Albedo_BSA_Band1.tif")
mcd.00.145 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130502192506-2000/MCD43B3.A2000145.Albedo_BSA_Band1.tif")
mcd.00.153 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130502192506-2000/MCD43B3.A2000153.Albedo_BSA_Band1.tif")
mcd.00.161 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130502192506-2000/MCD43B3.A2000161.Albedo_BSA_Band1.tif")
mcd.00.169 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130502192506-2000/MCD43B3.A2000169.Albedo_BSA_Band1.tif")
mcd.00.177 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130502192506-2000/MCD43B3.A2000177.Albedo_BSA_Band1.tif")
mcd.00.185 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130502192506-2000/MCD43B3.A2000185.Albedo_BSA_Band1.tif")
mcd.00.193 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130502192506-2000/MCD43B3.A2000193.Albedo_BSA_Band1.tif")
mcd.00.201 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130502192506-2000/MCD43B3.A2000201.Albedo_BSA_Band1.tif")
mcd.00.209 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130502192506-2000/MCD43B3.A2000209.Albedo_BSA_Band1.tif")

mcd.2000 <- list(mcd.00.129,mcd.00.137,mcd.00.145,mcd.00.153,mcd.00.161,mcd.00.169,mcd.00.177,mcd.00.185,mcd.00.193,mcd.00.201,mcd.00.209)
names(mcd.2000)<-c("1","2","3","4","5","6","7","8","9","10","11")
mcd.2000.b <- brick(mcd.2000)
## Crop the raster brick using the extent generated earlier
mcd.2000.b.c <- crop(mcd.2000.b,clip)
## Remove -3000 and convert to NA
mcd.2000.b.c.na <- calc(mcd.2000.b.c, function(x) ifelse(x == 0, NA, x))
## Apply the conversion coef to the data to 
mcd.2000.b.c.na.cor <- mcd.2000.b.c.na*0.0010
###############################################################################################################
## IMAGE TO USE FOR THE CVA ANALYSIS BELOW - CHANGE WHEN TESTING
mcd.2000.f <- max(mcd.2000.b.c.na.cor,na.rm=TRUE)
mcd.2000.r <- resample(mcd.2000.f,evi.2000.f,method="ngb")
###############################################################################################################

######################################################ALBEDO2012######################################################

mcd.12.129 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130503101609-2012/MCD43B3.A2012129.Albedo_BSA_Band1.tif")
mcd.12.137 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130503101609-2012/MCD43B3.A2012137.Albedo_BSA_Band1.tif")
mcd.12.145 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130503101609-2012/MCD43B3.A2012145.Albedo_BSA_Band1.tif")
mcd.12.153 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130503101609-2012/MCD43B3.A2012153.Albedo_BSA_Band1.tif")
mcd.12.161 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130503101609-2012/MCD43B3.A2012161.Albedo_BSA_Band1.tif")
mcd.12.169 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130503101609-2012/MCD43B3.A2012169.Albedo_BSA_Band1.tif")
mcd.12.177 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130503101609-2012/MCD43B3.A2012177.Albedo_BSA_Band1.tif")
mcd.12.185 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130503101609-2012/MCD43B3.A2012185.Albedo_BSA_Band1.tif")
mcd.12.193 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130503101609-2012/MCD43B3.A2012193.Albedo_BSA_Band1.tif")
mcd.12.201 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130503101609-2012/MCD43B3.A2012201.Albedo_BSA_Band1.tif")
mcd.12.209 <- raster("C:/Users/biocarbon/Documents/BCP_Data/Projects/EasternZambia_USAID/Raster/CVA_MODIS/PROCESSED/MCD43B3.005_20130503101609-2012/MCD43B3.A2012209.Albedo_BSA_Band1.tif")

mcd.2012 <- list(mcd.12.129,mcd.12.137,mcd.12.145,mcd.12.153,mcd.12.161,mcd.12.169,mcd.12.177,mcd.12.185,mcd.12.193,mcd.12.201,mcd.12.209)
names(mcd.2012)<-c("1","2","3","4","5","6","7","8","9","10","11")
mcd.2012.b <- brick(mcd.2012)
## Crop the raster brick using the extent generated earlier
mcd.2012.b.c <- crop(mcd.2012.b,clip)
## Remove -3000 and convert to NA
mcd.2012.b.c.na <- calc(mcd.2012.b.c, function(x) ifelse(x == 0, NA, x))
## Apply the conversion coef to the data to 
mcd.2012.b.c.na.cor <- mcd.2012.b.c.na*0.0010
###############################################################################################################
## IMAGE TO USE FOR THE CVA ANALYSIS BELOW - CHANGE WHEN TESTING
mcd.2012.f <- max(mcd.2012.b.c.na.cor,na.rm=TRUE)
mcd.2012.r <- resample(mcd.2012.f,evi.2012.f,method="ngb")
###############################################################################################################


###############################################################################################################
#############################################ChangeVectorAnalysis##############################################
###############################################################################################################

cva.mod <- sqrt(((evi.2012.f-evi.2000.f)^2)+((mcd.2012.r-mcd.2000.r)^2))
cva.mag.quant<-quantile(cva.mod,probs=c(0.95,1))
writeRaster(cva.mod, filename="MODIS_cva_mag.tif", format="GTiff", overwrite=TRUE, datatype='FLT4S')
q1.mag<-cva.mod>cva.mag.quant[1]

#############################################Quadrant1##############################################
print('Q1')
alb<-mcd.2012.r-mcd.2000.r>0
evi<-evi.2012.f-evi.2000.f>0
Q1<-alb+evi+q1.mag>2
writeRaster(Q1, filename="Q1_MODIS_cva_mag.tif", format="GTiff", overwrite=TRUE, datatype='LOG1S')

#############################################Quadrant2##############################################
print('Q2')
alb<-mcd.2012.r-mcd.2000.r>0
evi<-evi.2012.f-evi.2000.f<0
Q2<-alb+evi+q1.mag>2
writeRaster(Q2, filename="Q2_MODIS_cva_mag", format="GTiff", overwrite=TRUE, datatype='LOG1S')

#############################################Quadrant2##############################################
print('Q3')
alb<-mcd.2012.r-mcd.2000.r<0
evi<-evi.2012.f-evi.2000.f<0
Q3<-alb+evi+q1.mag>2
writeRaster(Q3, filename="Q3_MODIS_cva_mag", format="GTiff", overwrite=TRUE, datatype='LOG1S')

#############################################Quadrant2##############################################
print('Q4')
alb<-mcd.2012.r-mcd.2000.r<0
evi<-evi.2012.f-evi.2000.f>0
Q4<-alb+evi+q1.mag>2
writeRaster(Q4, filename="Q4_MODIS_cva_mag", format="GTiff", overwrite=TRUE, datatype='LOG1S')






