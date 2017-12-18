# Calculate a distance matrix of a point input file
# Wesley Roberts
# BioCarbon Partners
# Kalk Bay
# 2013/07/08

library(sp)
library(dismo)

data <- read.csv('DistanceMatrix.csv') # Read in your data
coordinates(data) <- ~X+Y # point them to your coordinates to make a spatialpoint layer
# Or like this:
Pointlayer <- SpatialPoints(cbind(data$X,data$Y))


# then calculate your distance matrix your point sequence
d <- pointDistance(data,longlat=F)
d <- as.data.frame(d)
e <- 1:30
d <- cbind(e,d)
f <- merge(data,d, by.x="Submission", by.y="e")
# Looks for example like this:
write.csv(f,"file.csv")