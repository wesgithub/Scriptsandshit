# Wesley Roberts
# FAO - Integrated Land Use Assessment II
# July 2015
# Forestry Department - Lusaka
# This script accesses tree data using the output from a collect database
# Eacc cluster has its own xml file which stores all of the relevant data for that cluster.
# The script iterates through the xml files and calculates the total carbon per plot as well as the total carbon per hectare for 
# a particular plot. Script can be updated using the accessability code in the xml file as opposed to the length of an
# XMLnodeset.
# Run the script in the directory containing all of the output xml files from the collect backup with data.

require("XML")
require("plyr")

# set the working directory to the folder where the xml files are stored
setwd("C:/Users/Wesley/Documents/FAO/ForestInventory/ILUA/Results/PlotLevelCarbonData/FDServer_zambia_ilua_ii_2015-07-15_17-11-17-881+0300.collect-backup/data/3")
a<-as.data.frame(list.files(path="./", pattern="*.xml",recursive=TRUE)) # read the xml files into a data.frame
names(a)<-c("xml_file") # set the column name
fin.df<-data.frame(matrix(nrow=0,ncol=14)) # create the output data.frame for the results to be written ## Below adds column names to the output file
names(fin.df)<-c("Prov","Dist","Town","Vill","ILUA1_C","Soil_C","UTM","Clust_Num","Plot_Num","plot_x","plot_y","Tree_Tot","Tree_AGC","Tree_AGC_ha")

## Provinces look up table data. This allows the correct province to be written to the output 
ProvinceList <- c("Central", "Copperbelt", "Eastern", "Luapula", "Lusaka", "Muchinga", "Northern", "NorthWestern", "Southern", "Western")
ProvinceCode <- c("100","200","300","400","500","600","700","800","900","1000")
Prov_V <- as.data.frame(cbind(ProvinceCode,ProvinceList))

## Begin the for loop, the main loop will iterate through the xml files while loops within the for loop iterate through
## plots and then trees. Triple nested for loops take care of the nested nature of the xml files
i=1
for (i in 1:length(a[,1])) {
  xmlfile <- xmlParse(paste(a[i,1])) #Read in the XML file
  
  t.df<-data.frame(matrix(nrow=4,ncol=14)) #temporary data.frame to store the plot data
  names(t.df)<-names(fin.df) #set column names for the temporary d.f - these are required for the rbind below
  xmltop <- xmlRoot(xmlfile) #Get access to the top-level XMLNode object
  j=1
  #if (length(getNodeSet(xmltop,paste("/cluster/plot[",j,"]",sep="")))<1) next(1) ## Not used
  for (j in 1:4){
    xy<-getNodeSet(xmltop,paste("/cluster/plot[",j,"]",sep="")) #Extract the data for the plot of interest - This is used later for the dbh
                                                                #processing within the function
    # Assign the province name based on the code and table produced above
    t.df[j,1]<-ifelse(xmlValue(xmltop[["cluster_location"]][["province"]])==100, as.character(Prov_V[1,2]),
                      ifelse(xmlValue(xmltop[["cluster_location"]][["province"]])==200, as.character(Prov_V[2,2]),
                             ifelse(xmlValue(xmltop[["cluster_location"]][["province"]])==300, as.character(Prov_V[3,2]),
                                    ifelse(xmlValue(xmltop[["cluster_location"]][["province"]])==400, as.character(Prov_V[4,2]),
                                           ifelse(xmlValue(xmltop[["cluster_location"]][["province"]])==500, as.character(Prov_V[5,2]),
                                                  ifelse(xmlValue(xmltop[["cluster_location"]][["province"]])==600, as.character(Prov_V[6,2]),
                                                         ifelse(xmlValue(xmltop[["cluster_location"]][["province"]])==700, as.character(Prov_V[7,2]),
                                                                ifelse(xmlValue(xmltop[["cluster_location"]][["province"]])==800, as.character(Prov_V[8,2]),
                                                                       ifelse(xmlValue(xmltop[["cluster_location"]][["province"]])==900, as.character(Prov_V[9,2]),
                                                                              ifelse(xmlValue(xmltop[["cluster_location"]][["province"]])==1000, as.character(Prov_V[10,2]),0)
                                                                       )))))))))
    t.df[j,2]<-xmlValue(xmltop[["cluster_location"]][["district"]]) #Write district code to the output
    t.df[j,3]<-xmlValue(xmltop[["cluster_location"]][["township"]]) #write closest township to the output
    t.df[j,4]<-xmlValue(xmltop[["cluster_location"]][["village"]]) #write closest village to the output
    t.df[j,5]<-xmlValue(xmltop[["cluster_location"]][["ilua1_cluster"]]) #number of the ILUAII cluster
    t.df[j,6]<-xmlValue(xmltop[["cluster_location"]][["soil_cluster"]]) #Was a soil cluster sampled at this location
    t.df[j,7]<-xmlValue(xmltop[["cluster_location"]][["utm_zone"]]) #UTM zone of the cluster
    t.df[j,8]<-xmlValue(xmltop[["no"]]) #cluster number 
    t.df[j,9]<-j #plot number 
    ## Function that processes the data within xy, if its length is greater than 0. See ifelse statement on line 92 and 93
    ## count takes the plot numberr into the function. Not sure if this is required but it seems to work so will not change 
    ## things just yet
    count<-j
    x.y.func<-function(xy,count)
    {
      to.df<-data.frame(matrix(nrow=5,ncol=1)) #Create the d.f to store the data produced in the function
      to.df[1,]<-ifelse(count==1,as.numeric(xmlValue(xy[[1]][["plot_marker"]][["x"]])), #Write X coordinate to the output making sure the correct 
                        ifelse(count==2,as.numeric(xmlValue(xy[[1]][["plot_marker"]][["x"]]))+25, #adjustments are made such that the output point falls onto
                               ifelse(count==3,as.numeric(xmlValue(xy[[1]][["plot_marker"]][["x"]])), #the centre of the plot
                                      ifelse(count==4,as.numeric(xmlValue(xy[[1]][["plot_marker"]][["x"]]))-25,0)
                               )))
      to.df[2,]<-ifelse(count==1,as.numeric(xmlValue(xy[[1]][["plot_marker"]][["y"]]))+25, #Write Y coordinate to the output making sure the correct 
                        ifelse(count==2,as.numeric(xmlValue(xy[[1]][["plot_marker"]][["y"]])), #adjustments are made such that the output point falls onto
                               ifelse(count==3,as.numeric(xmlValue(xy[[1]][["plot_marker"]][["y"]]))-25, #the centre of the plot
                                      ifelse(count==4,as.numeric(xmlValue(xy[[1]][["plot_marker"]][["y"]])),0)
                               )))
      to.df[3,]<-length(getNodeSet(xmltop,paste("/cluster/plot[",count,"]/tree/dbh",sep=""))) #write the number of trees to the temporary d.f
      a.dbh<-getNodeSet(xmltop,paste("/cluster/plot[",count,"]/tree/dbh",sep="")) #write entire dbh nodeset to a.dbh for processing
      ta.df<-data.frame(matrix(nrow=to.df[3,],ncol=6)) #temporary d.f to contain the results for the individual trees 
      k=1 #for loop to calcualte the tree level AGB, AGC and Total Carbon per tree
      for (k in 1:to.df[3,]){
        ta.df[k,1]<-xmlValue(a.dbh[[k]]) ## extract dbh from nodeset
        ta.df[k,2]<-exp(2.342 * log(as.numeric(ta.df[k,1])) - 2.059)/1000 ## convert to AGB tons
        ta.df[k,3]<-ta.df[k,2]*0.28 ## convert to BGB
        ta.df[k,4]<-ta.df[k,2]*0.49 ## convert to AGC
        ta.df[k,5]<-ta.df[k,3]*0.49 ## convert to BGC
        ta.df[k,6]<-ta.df[k,4]+ta.df[k,5] ## total AGC
      }
      to.df[4,]<-sum(ta.df$X6,na.rm=TRUE)  ## Total Carbon
      to.df[5,]<-sum(ta.df$X6,na.rm=TRUE)/0.10  ## Carbon Per hectare tot_Carbon
      return(data.frame(to.df))
    }
    ifelse(length(getNodeSet(xmltop,paste("/cluster/plot[",j,"]/tree/dbh",sep="")))>1,func.data<-data.frame(x.y.func(xy,j)),t.df[j,10:14]<--999)
    ifelse(length(getNodeSet(xmltop,paste("/cluster/plot[",j,"]/tree/dbh",sep="")))>1,t.df[j,10:14]<-func.data[1:5,],0)
  }
  fin.df<-rbind(fin.df,t.df) 
}

write.csv(x = fin.df,file = "plotlevelcarbon.csv",quote = FALSE,row.names = FALSE)


