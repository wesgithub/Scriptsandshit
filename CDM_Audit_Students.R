library(rgdal)
library(maptools)

#setwd("C:/Users/biocaRBon/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/AA_VCS_Data/CDM_Points/Richard_Data/BCP Work3/Merged")
setwd("C:/Users/biocarbon/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/AA_VCS_Data/CDM_Points/Richard_Data/RB_Final_CDM_Classification/BCP Work/A_Merged")

# open and Join the shapefiles with the classifications

RB_84<-readOGR(dsn=".",layer="84")
RB_89<-readOGR(dsn=".",layer="89")
RB_92<-readOGR(dsn=".",layer="92")
RB_99<-readOGR(dsn=".",layer="99")
RB_02<-readOGR(dsn=".",layer="02")
RB_09<-readOGR(dsn=".",layer="09")

RB1<-RB_84[,2:3]
names(RB1)<-c('PID','RB_84')
RB2<-RB_89[,3]
names(RB2)<-c('RB_89')
RB3<-RB_92[,3]
names(RB3)<-c('RB_92')
RB4<-RB_99[,3]
names(RB4)<-c('RB_99')
RB5<-RB_02[,3]
names(RB5)<-c('RB_02')
RB6<-RB_09[,3]
names(RB6)<-c('RB_09')

output1<-spCbind(RB1,as.data.frame(RB2)[1])
output2<-spCbind(RB3,as.data.frame(RB4)[1])
output3<-spCbind(RB5,as.data.frame(RB6)[1])

output4<-spCbind(output1,as.data.frame(output2)[1:2])
output5<-spCbind(output4,as.data.frame(output3)[1:2])

# Classifications now joined together

writeOGR(output5,'.',layer="RB_Classified_Points_Fin",driver="ESRI Shapefile",overwrite_layer=TRUE)



