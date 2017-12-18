setwd("~/BCP_Data/Projects/Zam_Rufunsa/Vector/Ecocharcoal_Zones/Biomass_SPOT_Analyses")
library(gstat)


# use spplot to explore the data outputs
# generate the grid prior to running the analysis to assign the data to.

# Generate grid to interpolate to before running the analyses.



# Look at the relation between variables of interest and disctance
hscat(log(zinc) ~ 1, meuse, (0:9) * 100)

# look for values with high semivariance 
sel <- plot(variogram(zinc ~ 1, meuse, cloud = TRUE), digitize = TRUE)
plot(sel, meuse)


# model selection uses vgm plus the sample variogram Pg 204 / 207
# alernative v.eye <- eyefit(variog(as.geodata(meuse["zinc"]), max.dist = 1500))
# use a cross variogram to look at the spatial patterns associated with the data extracted from the RS information
# Look at figure on page 210 to determine how to choose an interpolation approach.
# check to see if the measured biomass is correlated to one of the Vegetation Indices or Textural measures.





