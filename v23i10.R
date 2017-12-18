# Basic Example

library("yaImpute")
data("iris")
set.seed(1)
refs = sample(rownames(iris), 50)
x <- iris[, 1:3]
y <- iris[refs, 4:5]
Mahalanobis <- yai(x = x, y = y, method = "mahalanobis")

plot(Mahalanobis)

# Basic example: reviewing the data

head(impute(Mahalanobis))
tail(impute(Mahalanobis))

# Real-world example, model fit.

data("MoscowMtStJoe")
x <- MoscowMtStJoe[, c("EASTING", "NORTHING", "ELEVMEAN",
    "SLPMEAN", "ASPMEAN", "INTMEAN", "HTMEAN", "CCMEAN")]
x[, 5] <- (1 - cos((x[, 5] - 30) * pi/180))/2
names(x)[5] = "TrASP"
y <- MoscowMtStJoe[, c(1, 9, 12, 14, 18)]
mal <- yai(x = x, y = y, method = "mahalanobis")
msn <- yai(x = x, y = y, method = "msn")
gnn <- yai(x = x, y = y, method = "gnn")
ica <- yai(x = x, y = y, method = "ica")

y2 <- cbind(whatsMax(y[, 1:4]), y[, 5])
names(y2) <- c("MajorSpecies", "BasalAreaMajorSp", "TotalBA")
rf <- yai(x = x, y = y2, method = "randomForest")
head(y2)

levels(y2$MajorSpecies)

plot(rf,vars=yvars(rf))

rfImp <- impute(rf, ancillaryData = y)
rmsd  <- compare.yai(mal, msn, gnn, rfImp, ica)
apply(rmsd, 2, mean, na.rm = TRUE)

plot(rmsd)

# Real-world example, imputing attributs to AsciiGrids. The input
# data are in a subdirectory.

xfiles <- list(CCMEAN = "canopy.asc", ELEVMEAN = "dem.asc",
    HTMEAN = "heights.asc", INTMEAN = "intense.asc",
    SLPMEAN = "slope.asc", TrASP = "trasp.asc",
    EASTING = "utme.asc", NORTHING = "utmn.asc")
outfiles <- list(ABGR_BA = "rf_abgr.asc", PIPO_BA = "rf_pipo.asc",
    PSME_BA = "rf_psme.asc", THPL_BA = "rf_thpl.asc",
    Total_BA = "rf_totBA.asc")

# Note that this command takes a significant amount of time.
AsciiGridImpute(rf,xfiles,outfiles,ancillaryData=y)

# Real-world example, making images of two of the input grids
# requires package sp

library("sp")
canopy    <- read.asciigrid("canopy.asc") [100:450,400:700]
TrAsp     <- read.asciigrid("trasp.asc")  [100:450,400:700]

par(mfcol=c(1,2),plt=c(.05,.95,.05,.85))
image(canopy,col=hcl(h=140,l=seq(100,0,-10)))
title("LiDAR mean canopy cover")
image(TrAsp,col=hcl(h=140,l=seq(100,0,-10)))
title("Transformed aspect")

# Real-world example, making images two of the output grids

totBA <- read.asciigrid("rf_totBA.asc")[100:450,400:700]
psme  <- read.asciigrid("rf_psme.asc") [100:450,400:700]

par(mfcol=c(1,2),plt=c(.05,.95,.05,.85))
image(totBA,col=hcl(h=140,l=seq(100,0,-10)))
title("Total basal area")
image(psme,col=hcl(h=140,l=seq(100,0,-10)))
title("Douglas fir basal area")
