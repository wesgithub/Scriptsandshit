##Please make sure you have installed the SSOAP library: in R window, choose menu "Packages->Install pacages", choose any location, choose "SSOAP"
##Then you may try the following command to get the subset data you would like to require:

## load the package
library(SSOAP)

## get the SOAP service
ornlMODIS = processWSDL("http://daac.ornl.gov/cgi-bin/MODIS/GLBVIZ_1_Glb_subset/MODIS_webservice.wsdl")

## define the function set
ornlMODISFuncs = genSOAPClientInterface(operations=ornlMODIS@operations[[1]], def=ornlMODIS)

## use the getsubset function
result = ornlMODISFuncs@functions$getsubset(40.115,-110.025,"MOD11A2","LST_Day_1km","A2001001","A2001025",1,1)

## print result
print(result)
