################################################################################################
## Wesley Roberts  								      ##
## BioCarbon Partners - Stellenbosch							      ##
## 05/02/2013										      ##
## This R code computes the CVA between two dated images with two bands		              ##
## Input bands should contain the Brightness and Greeness Bands for a TC transformation       ##
## Band 1 is a brightness band derived from atmospherically corrected Landsat TM or ETM scene ##
## Band 2 is a greeness band  derived from atmospherically corrected Landsat TM or ETM scene  ##
## Output from the analysis is a magnitude image and a quadrant image depicting               ##
## the size of the change and the direction on the cartesian plane		              ##
################################################################################################

# Things too change in the code when you run it on different image data sets
# 1. Path to the images, make sure the earlier date is assigned to dte1 and the latter to dte2
# 2. The name of the output file for each of the output quadrants. This could be changed in one place and applied across the script
# 3. Remember to clear the console of all data sets prior to running otherwise R will run out of memory - alternatively just restart R
# 4. Finally, dont forget to set the working directory.
# 5. Also check the percentile threshold chosen for the quadrant and magnitude change image.

rm(list = ls(all = TRUE))

setwd("/home/wesley/work/Laikipia_processing/84-00_CVA")

# Load rgdal library
library(landsat)
library(maptools)
library(rgdal)
library(spatstat)
library(raster)
# Open the two dated images using the readGDAL function Remember to change these for different dates
dte1 <- readGDAL("/home/wesley/work/Laikipia_processing/LT51680601984240AAA04/TC.LT51680601984240AAA04.ref_sub_cloudmask.tif", half.cell=c(0.5, 0.5))
dte2 <- readGDAL("/home/wesley/work/Laikipia_processing/LE71680602000052EDC00/TC.LE71680602000052EDC00.ref_sub_cloudmask2.tif", half.cell=c(0.5, 0.5))
print("converting 0 to NA")
# Remove NA values from the images using the raster package before conducting RA or HM
# Date 1 Brightness
TC1.dte1.r<-raster(dte1[1])
TC1.dte1.r <- calc(TC1.dte1.r, function(x) ifelse(x == 0, NA, x))
TC1.dte1.na<-as(TC1.dte1.r, 'SpatialGridDataFrame')
# Date 1 Greeness
TC2.dte1.r<-raster(dte1[2])
TC2.dte1.r <- calc(TC2.dte1.r, function(x) ifelse(x == 0, NA, x))
TC2.dte1.na<-as(TC2.dte1.r, 'SpatialGridDataFrame')
# Date 2 Brightness
TC1.dte2.r<-raster(dte2[1])
TC1.dte2.r <- calc(TC1.dte2.r, function(x) ifelse(x == 0, NA, x))
TC1.dte2.na<-as(TC1.dte2.r, 'SpatialGridDataFrame')
# Date 2 Greeness
TC2.dte2.r<-raster(dte2[2])
TC2.dte2.r <- calc(TC2.dte2.r, function(x) ifelse(x == 0, NA, x))
TC2.dte2.na<-as(TC2.dte2.r, 'SpatialGridDataFrame')
# Housekeeping 
rm(dte1,dte2,TC1.dte1.r,TC1.dte2.r,TC2.dte1.r,TC2.dte2.r)
# Conduct relative normalisation before undertaking CVA analysis earlier image is slaved to later image for both greeness and brightness
# Later date image is the master while earlier date is the slave
# Brightness
print('Performing relative normalisation')
TC1.dte1.h<-relnorm(TC1.dte2.na,TC1.dte1.na,method="MA",nperm=1)
TC1.dte1.hm<-TC1.dte1.h[["newimage"]] 
# Greeness
TC2.dte1.h<-relnorm(TC2.dte2.na,TC2.dte1.na,method="MA",nperm=1)
TC2.dte1.hm<-TC2.dte1.h[["newimage"]] 
# Relative normalisation complete
# House Cleaning


# Alternative approach using raster format
print('calculating the cva magnitude layer')
dte1_brt<-raster(TC1.dte1.hm)
dte1_grn<-raster(TC2.dte1.hm)
dte2_brt<-raster(TC1.dte2.na)
dte2_grn<-raster(TC2.dte2.na)

rm(TC1.dte1.hm,TC2.dte1.hm,TC1.dte1.na,TC2.dte2.na,TC1.dte1.h,TC1.dte2.na,TC2.dte1.h,TC2.dte1.na)

cva_mag<-sqrt((dte2_brt-dte1_brt)^2)+((dte2_grn-dte1_grn)^2)
mag.quant<-quantile(cva_mag,probs=c(0.75,1))
q1.mag<-cva_mag>mag.quant[1]

writeRaster(cva_mag, filename="cva_mag_84-00.tif", format="GTiff", overwrite=TRUE, datatype='FLT4S')
print('Q1')
# Quadrant 1 Brightness and Greeness have both increased from the first to the last image dates
# Tentatively called "Biomass Loss"
brt<-dte2_brt-dte1_brt>0
grn<-dte2_grn-dte1_grn>0
Q1<-brt+grn+q1.mag>2
writeRaster(Q1, filename="Q1_cva_mag84-00", format="GTiff", overwrite=TRUE, datatype='LOG1S')
print('Q2')
# Quadrant 2 Brightness increased and Greeness has decreased from the first to the last image dates
# Tentatively called "Deforestation"
brt<-dte2_brt-dte1_brt>0
grn<-dte2_grn-dte1_grn<0
Q2<-brt+grn+q1.mag>2
writeRaster(Q2, filename="Q2_cva_mag84-00", format="GTiff", overwrite=TRUE, datatype='LOG1S')
print('Q3')
# Quadrant 3 Brightness decreased and Greeness decreased from the first to the last image dates
# Tentatively called "Fire scars and Fallow Fields"
brt<-dte2_brt-dte1_brt<0
grn<-dte2_grn-dte1_grn<0
Q3<-brt+grn+q1.mag>2
writeRaster(Q3, filename="Q3_cva_mag84-00", format="GTiff", overwrite=TRUE, datatype='LOG1S')
print('Q4')
# Quadrant 4 Brightness decreased and Greeness decreased from the first to the last image dates
# Tentatively called ""
brt<-dte2_brt-dte1_brt<0
grn<-dte2_grn-dte1_grn>0
Q4<-brt+grn+q1.mag>2
writeRaster(Q4, filename="Q4_cva_mag84-00", format="GTiff", overwrite=TRUE, datatype='LOG1S')
