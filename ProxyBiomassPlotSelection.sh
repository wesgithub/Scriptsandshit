################################################################################################################################
# Wesley Roberts
# BioCarbon Partners
# 2013/04/23
# Stellenbosch
# wes@biocarbonpartners.com
# script to programmatically identify and select a number of biomass sampling points within a proxy area
# Import all data into a grass database and run the script by copying and pasting the commands into grass, this script is not meant to be a stand alone application, it is merely a record of the process.
# The following data should be imported into a GRASS database - File names should be changed accordingly
###### Shapefile data ######
# class1.shp -> class1_pts
# Proxy_Area_Extent.shp -> Proxy_Area_Extent
# Roads.shp -> Roads
# Villages.shp -> Villages
###### Raster data ######
# ASTER_GDEM_Proxy_UTM35S.tif -> GDEM
# Spot_Biomass_Proxy.tif -> Spot_Biomass_Proxy
################################################################################################################################

# Convert the vector representing the proxy area extent to a raster and set as a mask
r.mask -r
v.to.rast input=Proxy_Area_Extent@PERMANENT output=Proxy_Area_Extent use=val
r.mask input=Proxy_Area_Extent 

# Compute a slope map of the study area using the gdem (compute in degrees) & select areas with a slope of < 20 Degrees
r.slope.aspect elevation=GDEM@PERMANENT slope=gdem.slope
r.mapcalc "gdem.slope.20=if(gdem.slope<20,1,null())"

# remove old mask and set gdem.slope.20 as the new mask
r.mask -r
r.mask input=gdem.slope.20

# Generate EVI image to stratify for point location selection
r.mapcalc "spot.ndvi=float(Spot_Biomass_Proxy.red@PERMANENT-Spot_Biomass_Proxy.green@PERMANENT)/float(Spot_Biomass_Proxy.red@PERMANENT+Spot_Biomass_Proxy.green@PERMANENT)"

# Recode NDVI imagery into classes suitable for selecting proxy biomass locations. Show areal coverage percentage for each class
r.recode input=spot.ndvi@Work output=spot.ndvi.recode rules=/home/wesley/work/Proxy_Biomass_Plots/proxy.biomass.recode
r.stats -a -p -n input=spot.ndvi.recode@Work

# Proxy area biomass requires at least 60 plots, but I will calculate for double that and make a final selection based on distance to villages - Using the data from the output of r.stats
# 1 58127064.742986   9.93%  <- Ignored
# 2 270445572.929570  46.18%	<- 120 * 0.4618 = 55
# 3 234059464.589722  39.97%	<- 120 * 0.3997 = 47
# 4 22987537.219007   3.93%	<- 120 * 0.0393 = 4

# Create masks using the classes established by the recode operation and randomly select plot locations within each of these classes
# Before converting to vector undertake a morpological erosion
## Class 2 ##
r.mapcalc "class2 = if(spot.ndvi.recode==2,1,null())"
r.mapcalc "temp=isnull(class2)"
r.mapcalc "temp.null=if(temp==1,1,null())"
r.buffer --o input=temp.null output=temp.null.buff distance=10
r.recode --o input=temp.null.buff output=temp.null.buff.recode rules=/home/wesley/work/Proxy_Biomass_Plots/recode.erode
r.mapcalc "class2.erode=if(isnull(temp.null.buff.recode)==1,1,null())"
g.remove rast=temp,temp.null,temp.null.buff,temp.null.buff.recode
r.to.vect -s -v input=class2.erode output=class2 feature=area
v.random.cover cover=class2@Work cat=1 output=class2_pts n=55 raster=class2@Work
v.db.update map=class2_pts@Work column=sampled value=2


## Class 3 ##
r.mapcalc "class3 = if(spot.ndvi.recode==3,1,null())"
r.mapcalc "temp=isnull(class3)"
r.mapcalc "temp.null=if(temp==1,1,null())"
r.buffer --o input=temp.null output=temp.null.buff distance=10
r.recode --o input=temp.null.buff output=temp.null.buff.recode rules=/home/wesley/work/Proxy_Biomass_Plots/recode.erode
r.mapcalc "class3.erode=if(isnull(temp.null.buff.recode)==1,1,null())"
g.remove rast=temp,temp.null,temp.null.buff,temp.null.buff.recode
r.to.vect -s -v input=class3@Work output=class3 feature=area
v.random.cover cover=class3@Work cat=1 output=class3_pts n=47 raster=class3@Work
v.db.update map=class3_pts@Work column=sampled value=3

## Class 4 ##
r.mapcalc "class4 = if(spot.ndvi.recode==4,1,null())"
r.mapcalc "temp=isnull(class4)"
r.mapcalc "temp.null=if(temp==1,1,null())"
r.buffer --o input=temp.null output=temp.null.buff distance=10
r.recode --o input=temp.null.buff output=temp.null.buff.recode rules=/home/wesley/work/Proxy_Biomass_Plots/recode.erode
r.mapcalc "class4.erode=if(isnull(temp.null.buff.recode)==1,1,null())"
g.remove rast=temp,temp.null,temp.null.buff,temp.null.buff.recode
r.to.vect -s -v input=class4@Work output=class4 feature=area
v.random.cover cover=class4@Work cat=1 output=class4_pts n=10 raster=class4@Work
v.db.update map=class4_pts@Work column=sampled value=4

v.patch -e --overwrite input=class1_pts@Work,class2_pts@Work,class3_pts@Work,class4_pts@Work output=CombinedClass_pts

v.out.ogr -e input=CombinedClass_pts@Work type=point dsn=. olayer=Proxy_Biomass_Sampling_2013-04-24
