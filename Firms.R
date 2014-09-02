library(sp)
library(rgdal)
library(ggplot2)
library(rgeos)
library(ggmap)
library(sendmailR)


setwd("C:/Users/carbon-gis/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/NASA_FIRMS")
# Open fire data csv file. User is prompted to select the file which needs to be mapped / analyzed
a<-file.choose()
b<-read.csv(file=a)

# CSV file is now converted to a Spatial Format and saved 
coords = cbind(b[,2], b[,1])
sp = SpatialPoints(coords)
spdf = SpatialPointsDataFrame(coords, b)
c<-substr(a, 92, 125)
writeOGR(obj=spdf,dsn="./FireData_shp",c,driver="ESRI Shapefile")

# Map of the location of the fires
# Open base data
base<-readOGR(dsn="./BaseData",layer="poly_extent")
roads<-readOGR(dsn="./BaseData",layer="Roads")
ref<-readOGR(dsn="C:/Users/carbon-gis/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/Reference_Zone", layer="Reference_Zone_WGS84_2014-06-14")
cons<-readOGR(dsn="C:/Users/carbon-gis/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/Accounting_Project_Area",layer="New_Rufunsa_Boundary_01-11-2012_WGS84")
leak<-readOGR(dsn="C:/Users/carbon-gis/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/Leakage_Zone",layer="Leakage_Zone_WGS84")

# Fortify shapes to be used for mapping purposes in ggplot2

base.f<-fortify(base)
roads.f<-fortify(roads)
ref.f<-fortify(ref)
cons.f<-fortify(cons)
leak.f<-fortify(leak)
spdf.f<-fortify(b)

bound<-bbox(base)
bound[1, ] <- (bound[1, ] - mean(bound[1, ])) * 1.25 + mean(bound[1, ])
bound[2, ] <- (bound[2, ] - mean(bound[2, ])) * 1.25 + mean(bound[2, ])
lnd.b1 <- ggmap(get_map(location = bound))

#p <- ggplot()
q <- geom_polygon(data=base.f, aes(x=long, y=lat, group = group),colour="black", alpha=0)
r <- geom_polygon(data=ref.f, aes(x=long, y=lat, group = group),colour="black", alpha=0)
s <- geom_polygon(data=cons.f, aes(x=long, y=lat, group = group),colour="black")
t <- geom_polygon(data=leak.f, aes(x=long, y=lat, group = group),colour="black",alpha=0)
u <- geom_point(data=spdf.f, aes(x=LONGITUDE, y=LATITUDE, size = CONFIDENCE),colour="red", fill="red")
#t <- geom_line(data=roads.f,aes(x=long, y=lat, group = group))
lnd.b1 + q + r + s + t + u + ggtitle(paste("Fires in the Vacinity of LRZP", c, sep=" ")) + theme_bw() 

ggsave(filename=paste(c,".pdf",sep=""),)

ggsave(filename=paste(c,".pdf",sep=""),path="C:/Users/carbon-gis/Google Drive/Maps/LZRP/nasa_firms_maps")


## Email result to seamus

#####send plain email

#from <- "<wesley@biocarbonpartners.com>"
#from <- "<jwesroberts@gmail.com>"
#to <- "<gimps.sa@gmail.com>"
#to <- "rufunsa@biocarbonpartners.com"
#subject <- "This is a simple test - please ignore"
#body <- "Email body."                     
#mailControl=list(smtpServer="ASPMX.L.GOOGLE.COM")
#sendmail_options(smtpPort=25)
#sendmail_options(STARTTLSPort=587)
#mailControl=list(smtpServer="smtp.gmail.com")
#sendmail(from=from,to=to,subject=subject,msg=body,control=mailControl)

#####send same email with attachment

#needs full path if not in working directory
#attachmentPath <- "subfolder/log.txt"

#same as attachmentPath if using working directory
#attachmentName <- "log.txt"

#key part for attachments, put the body and the mime_part in a list for msg
#attachmentObject <- mime_part(x=attachmentPath,name=attachmentName)
#bodyWithAttachment <- list(body,attachmentObject)

#sendmail(from=from,to=to,subject=subject,msg=bodyWithAttachment,control=mailControl)




