








library(foreign)

# set working directory
wd <- "C:/Users/RobertsJo/Documents/FAO_Rome_2017/NFI_Dev/Zambia/SP2_Baseline/CSA/Data/CSA DATA_SPSS/DATA/ARCH"
setwd(wd)

a.1 <- read.spss("HH_LEVEL.sav", to.data.frame=TRUE)
table(a.1$PROV)

cen.sub <- subset(a.1,subset = a.1$PROV == "Central")
eas.sub <- subset(a.1,subset = a.1$PROV == "Eastern")
muc.sub <- subset(a.1,subset = a.1$PROV == "Muchinga")
sou.sub <- subset(a.1,subset = a.1$PROV == "Southern")






