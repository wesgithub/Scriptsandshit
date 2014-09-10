## Example procedure for working with data (attributes) inside SpatialPolygonsDataFrame objects

# Load my favorite libraries for that sort of work
library(data.table)
library(rgdal)

# Load 2 shapefiles that, say, we want to merge.
# Note that you can read pretty much any spatial format using readOGR().
tza.l2 <- readOGR("./analysis/TZA-AC-07/maps", "tza-ac-07_L2")
tza.l1 <- readOGR("./analysis/TZA-AC-07/maps", "tza-ac-07_L1")

# Let's explore the 1st object (for information)
str(tza.l2)
# Formal class 'SpatialPolygonsDataFrame' [package "sp"] with 5 slots
# ..@ data       :'data.frame':  140 obs. of  12 variables:
# .. ..$ ISO       : Factor w/ 1 level "TZA": 1 1 1 1 1 1 1 1 1 1 ...
# .. ..$ NAME_0    : Factor w/ 1 level "Tanzania": 1 1 1 1 1 1 1 1 1 1 ...
# .. ..$ ID_1      : int [1:140] 3052 3052 3052 3052 3053 3053 3053 3054 3054 3054 ...
# .. ..$ NAME_1    : Factor w/ 26 levels "Arusha","Dar-Es-Salaam",..: 1 1 1 1 2 2 2 3 3 3 ...
# .. ..$ ID_2      : int [1:140] 33658 33659 33661 33662 33664 33665 33666 33667 33668 33669 ...
# .. ..$ NAME_2    : Factor w/ 130 levels "Arumeru","Arusha",..: 1 2 76 96 20 40 123 13 14 44 ...
# .. ..$ Shape_Leng: num [1:140] 2.801 0.504 7.466 6.13 1.063 ...
# .. ..$ Shape_Area: num [1:140] 0.2321 0.00882 1.30787 1.25441 0.02747 ...
# .. ..$ svyL1Code : int [1:140] 2 2 2 2 7 7 7 1 1 1 ...
# .. ..$ svyL1Name : Factor w/ 26 levels "Arusha","Dar es salaam",..: 1 1 1 1 2 2 2 3 3 3 ...
# .. ..$ svyL2Code : int [1:140] 7 3 1 5 2 1 3 6 5 1 ...
# .. ..$ svyL2Name : Factor w/ 136 levels "Arusha Rural",..: 1 2 81 101 22 44 130 5 16 48 ...
# ..@ polygons   :List of 140
# .. ..$ :Formal class 'Polygons' [package "sp"] with 5 slots
# .. .. .. ..@ Polygons :List of 49
# .. .. .. .. ..$ :Formal class 'Polygon' [package "sp"] with 5 slots
# .. .. .. .. .. .. ..@ labpt  : num [1:2] 36.91 -2.99
# .. .. .. .. .. .. ..@ area   : num 1.63e-16
# .. .. .. .. .. .. ..@ hole   : logi FALSE
# .. .. .. .. .. .. ..@ ringDir: int 1
# .. .. .. .. .. .. ..@ coords : num [1:5, 1:2] 36.9 36.9 36.9 36.9 36.9 ...
# .. .. .. .. ..[list output truncated]
# .. .. .. ..@ plotOrder: int [1:49] 31 48 23 45 40 38 15 37 16 20 ...
# .. .. .. ..@ labpt    : num [1:2] 36.73 -3.43
# .. .. .. ..@ ID       : chr "0"
# .. .. .. ..@ area     : num 0.12
# .. .. [list output truncated]
# ..@ plotOrder  : int [1:140] 92 47 110 60 114 73 97 13 116 100 ...
# ..@ bbox       : num [1:2, 1:2] 29.327 -11.746 40.445 -0.982
# .. ..- attr(*, "dimnames")=List of 2
# .. .. ..$ : chr [1:2] "x" "y"
# .. .. ..$ : chr [1:2] "min" "max"
# ..@ proj4string:Formal class 'CRS' [package "sp"] with 1 slots
# .. .. ..@ projargs: chr NA

# That object is made of 5 "slots"
slotNames(tza.l2)
# [1] "data"        "polygons"    "plotOrder"   "bbox"        "proj4string"

# We can access each slot (using "@")
class(tza.l2@data)
# [1] "data.frame"
class(tza.l2@polygons)
# [1] "list"

# Each polygon is itself a list with 5 slots (incl. all the vertice coordinates).
slotNames(tza.l2@polygons[[1]])
# [1] "Polygons"  "plotOrder" "labpt"     "ID"        "area" 

# The ID slot is what ties the geometries and the attributes.
all(lapply(tza.l2@polygons, slot, "ID") == row.names(tza.l2))
# [1] TRUE

# Note that like row.names, polygon IDs are character not integer.
summary(as.integer(lapply(tza.l2@polygons, slot, "ID")))
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#    0.0    34.8    69.5    69.5   104.0   139.0 

summary(as.integer(row.names(tza.l2))
        #   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
        #    0.0    34.8    69.5    69.5   104.0   139.0 
        
        # Save the data row.names into an explicit variable
        tza.l2$rn <- row.names(tza.l2)
        
        # Create temporary data tables to work on the attributes
        tmp.l2 <- data.table(tza.l2@data)
        tmp.l1 <- data.table(tza.l1@data)
        
        # Say we want to merge data from table tmp.l1 into tmp.l2
        setkey(tmp.l2, svyL1Name, svyL2Code)
        setkey(tmp.l1, region, district)
        tmp.l2 <- tmp.l1[tmp.l2]
        
        # Then let's re-attach the table to the original SpatialPolygonsDataFrame
        # (preserving the original order of the row.names)
        setkey(tmp.l2, rn)
        tza.l2@data <- tmp.l2[row.names(tza)]
        
        # Export back to shapefile (or to any spatial format)
        writeOGR(tza.l2, "./analysis/TZA-AC-07/maps", "tza-ac-07_L2", driver="ESRI Shapefile")
