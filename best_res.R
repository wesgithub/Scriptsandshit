#R Script to determine the optimal spatial resolution based on the iput of lidar data
#Wesley Roberts
#Most if not all of this script is taken from the script provided by T. Hengl and
#adapted for a sample lidar data set

library(gstat)
library(maptools)
library(rgdal)
library(lattice)

#open csv file containing the lidar data (+-10000 points)
wesepe.c <- read.csv("preprocessing_pts.csv", header=TRUE)
names(wesepe.c)
str(wesepe.c)

# convert to a spatial point data layer and view using spplot
coordinates(wesepe.c) <-~X+Y
spplot(wesepe.c["H"], col.regions=bpy.colors(), scales=list(draw = TRUE))

# Estimate the sampling density and related cell size:
wesepe.area <- (wesepe.c@bbox[1,2]-wesepe.c@bbox[1,1])*(wesepe.c@bbox[2,2]-wesepe.c@bbox[2,1])
wesepe.dens <- length(wesepe.c$H)/wesepe.area * 1e6
wesepe.pixsize0 <- 0.25 * sqrt(wesepe.area/length(wesepe.c$H))

# look at the spreading between the points:
library(spatstat)
wesepe.ppp <- as(wesepe.c["H"], "ppp")
plot(wesepe.ppp)
dist.wesepe <- nndist(wesepe.ppp$x, wesepe.ppp$y) #distance matrix of all values
dist.box <- boxplot(dist.wesepe, col="grey") #boxplot of this matrix
hist(dist.wesepe, breaks=30, col="grey") #histogram of this distance matrix

wesepe.pixsize1 <- dist.box$stats[3]/2   #Not really sure what this does
wesepe.pixsize2 <- qnorm(0.05, mean=mean(dist.wesepe), sd=sd(dist.wesepe), lower.tail=T)  #Not really sure what this does
wesepe.pixsize3 <- quantile(dist.wesepe, probs=0.01)  #Not really sure what this does

# now analyze the auto-correlation structure of the target variable:
library(gstat)
sel = !is.infinite(wesepe.c$H)
plot(variogram(wesepe.c$H~1, wesepe.c[sel,])) #looks very nice range at about 7-8 meters
H.var <- variogram(wesepe.c$H~1, wesepe.c[sel,])
H.vgm <- fit.variogram(H.var, vgm(nugget=0.5*var(wesepe.c[sel,]$H), model="Exp", range=sqrt(wesepe.area)/3, psill=var(wesepe.c[sel,]$H)))
plot(H.var, H.vgm, plot.nu=T)
H.vgm

wesepe.pixsize4 <- H.vgm[2,"range"]*3/2
m.pairs <- sum(subset(H.var, dist<H.vgm[2,"range"]*3, np))
wesepe.pixsize5 <- H.vgm[2,"range"]* 3 * (m.pairs)^(-1/3)

grid.wesepe.0 <- expand.grid(x=seq(wesepe.c@bbox["X","min"]+wesepe.pixsize0/2,wesepe.c@bbox["X","max"]-wesepe.pixsize0/2,wesepe.pixsize0), y=seq(wesepe.c@bbox["Y","min"]+wesepe.pixsize0/2,wesepe.c@bbox["Y","max"]-wesepe.pixsize0/2,wesepe.pixsize0))
gridded(grid.wesepe.0) <- ~x+y
grid.wesepe.1 <- expand.grid(x=seq(wesepe.c@bbox["X","min"]+wesepe.pixsize1/2,wesepe.c@bbox["X","max"]-wesepe.pixsize1/2,wesepe.pixsize0), y=seq(wesepe.c@bbox["Y","min"]+wesepe.pixsize1/2,wesepe.c@bbox["Y","max"]-wesepe.pixsize1/2,wesepe.pixsize1))
gridded(grid.wesepe.1) <- ~x+y
grid.wesepe.5 <- expand.grid(x=seq(wesepe.c@bbox["X","min"]+wesepe.pixsize5/2,wesepe.c@bbox["X","max"]-wesepe.pixsize5/2,wesepe.pixsize0), y=seq(wesepe.c@bbox["Y","min"]+wesepe.pixsize5/2,wesepe.c@bbox["Y","max"]-wesepe.pixsize5/2,wesepe.pixsize5))
gridded(grid.wesepe.5) <- ~x+y

wesepe.cf <- remove.duplicates(wesepe.c[sel,], zero=1)
gstat.wesepe <- gstat(id=c("H"), formula=H~1, data=wesepe.cf, model=H.vgm)
H.krige0 <- predict.gstat(gstat.wesepe, nmax=20, newdata=grid.wesepe.0, block=c(wesepe.pixsize0,wesepe.pixsize0), beta=1, BLUE=FALSE)
H.krige1 <- predict.gstat(gstat.wesepe, nmax=40, newdata=grid.wesepe.1, block=c(wesepe.pixsize1,wesepe.pixsize1), beta=1, BLUE=FALSE)
H.krige5 <- predict.gstat(gstat.wesepe, nmax=40, newdata=grid.wesepe.5, block=c(wesepe.pixsize5,wesepe.pixsize5), beta=1, BLUE=FALSE)


spplot(H.krige1["H"], col.regions=bpy.colors(), at=seq(0,1,0.05), sp.layout=list("sp.points", pch="+", col="cyan", wesepe.c))

par(mfrow=c(1, 3))
image(H.krige0, col=bpy.colors(), asp=1)
image(H.krige5, col=bpy.colors(), asp=1)
image(H.krige1, col=bpy.colors(), asp=1)
























