zag <- readOGR(dsn = ".",layer = "ZagrosForests_Iran_OakDecline_2017_diss")
cas <- readOGR(dsn = ".",layer = "CaspianForests_Iran_BB_2017_StudyArea")
# convert to the utm coordinate system
zag.utm <- spTransform(zag, CRS("+init=epsg:32639"))
cas.utm <- spTransform(cas, CRS("+init=epsg:32639"))
# generate the field sites every 10km
zag.utm.sp <- spsample(zag.utm,type = "regular",cellsize = 10000)
cas.utm.sp <- spsample(cas.utm,type = "regular",cellsize = 10000)