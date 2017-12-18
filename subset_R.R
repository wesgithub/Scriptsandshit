## Simple prog to calculate regression between VOL_PL (total plot level volume) independant variable and NDVI dependant variable
## the program first calculates a simple linear regression then using weighted stdandard deviation of the NDVI variable
## Wesley Roberts 15 - 06 -2007
## CSIR - FFP Durban

## Open library to read Excel spreadsheets
library(xlsReadWrite)

## Read in the spreadsheet specifying the first row as column names
my_file = read.xls("Book2.xls", colNames = TRUE, sheet = 1, type = "data.frame", from = 1, colClasses = NA)

## Print the data.frame
print(my_file)

## subset data.frame selecting all nitens plots regardless of age or site index
sub <- subset(my_file, Sp_ID == 1, select = c(VOL_PL, NDVI, N_AV), drop = FALSE)

## print the subset
print(sub)

## simple linear regression with VOL_PL as independant variable and NDVI as the dependant
sim_ln = lm(VOL_PL ~ NDVI, data = sub)

## print summary of linear regression
print(summary(sim_ln))

## second part of the code; first step is calculating the weights from the NDVI data
w <- 1 + sqrt(sub$NDVI)/2

## print weights
print(w)

## calculate weighted linear regression using the standard deviation weights
sim_ln_w = lm(VOL_PL ~ NDVI, data = sub, weight = 1/w^2)

## print summary of weighted linear regression
print(summary(sim_ln_w))
