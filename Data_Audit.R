require("XML")
require("plyr")

a<-as.data.frame(list.files(path="C:/Users/carbon-gis/Documents/BCP_Data/Projects/EasternZambia_USAID", pattern="*.qgs",recursive=TRUE))
setwd("C:/Users/carbon-gis/Documents/BCP_Data/Projects/EasternZambia_USAID")

# Remove the ~ from the filenames
h<-1
for (h in 1:length(a[,1])) {
  a[h,]<-gsub("~",'',a[h,])
}
# clean up the data frame using unique
b <- unique(a)


# Add file info to the data frame
c<-data.frame(matrix(nrow=length(b[,1]), ncol=1))
names(c)<-c("date_mod")
h<-1
for (h in 1:length(b[,1])){
  ca<-file.info(paste(b[h,]))[,6]
  c[h,]<-strftime(ca,"%Y-%m-%d %H:%M:%S")
  h=h+1
}

#Combine last modification with the list of files
b<-cbind(b,c)
names(b)<-c("files","date_mod")

#get the number of shapefiles as well as the project name and date of last modification 
#and compile large DF.
fin.df<-data.frame(matrix(nrow=1,ncol=3))
names(fin.df)<-c("proj","date_mod","shp")

i<-1
for (i in 1:length(b[,1])) {
#for (i in 1:5) {  
  print(b[i,1])
  xmlfile=xmlParse(paste(b[i,1]))
  xmltop = xmlRoot(xmlfile) #gives content of root
  c<-as.numeric(xmlAttrs(xmltop[["projectlayers"]]))
  tmp.df<-data.frame(matrix(nrow=c,ncol=3))
  j=1
  for (j in 1:c){
    tmp.df[j,1]<-as.character(b[i,1])
    tmp.df[j,2]<-as.character(b[i,2])
    bb<-xmlValue(xmltop[["projectlayers"]][[j]][["datasource"]])
    tmp.df[j,3]<-bb
    names(tmp.df)<-c("proj","date_mod","shp")
   }
  fin.df<-rbind(fin.df,tmp.df)
}

#update the dates in the data frame to remove the time 
fin.df$date_mod<-substr(fin.df$date_mod,1,10)
fin.df<-na.omit(fin.df)
#convert the time into a date class as opposed to a character class
fin.df$date_mod<-as.Date(fin.df$date_mod,"%Y-%m-%d")
#extract file names from paths and append to the df
fin.df<-cbind(fin.df,basename(fin.df[,3]))
names(fin.df)<-c("proj","date_mod","shp","name")
write.csv(fin.df,file="CFP_Data_Audit_Shapefiles.csv")

# create a df that has each project as a row with the date it was last accessed as well as the 
# number of layers in the project
proj.df<-data.frame(matrix(nrow=1,ncol=3))
names(proj.df)<-c("Location","Date","Num_files")
ab<-unique(fin.df$proj)
abc<-length(ab)
i=1
for (i in 1:abc){
  loop<-subset(fin.df,fin.df$proj==paste(ab[i]))
  dte<-as.character(unique(loop$date_mod))
  loc<-unique(loop$proj)
  ln<-length(unique(loop$name))
  tmp<-t(as.data.frame(c(loc,dte,ln)))
  row.names(tmp)<-i
  proj.df[i,]<-tmp
}
proj.df$Date<-as.Date(proj.df$Date,"%Y-%m-%d")
proj.df<-proj.df[order(proj.df$Date),]
write.csv(proj.df,file="CFP_Data_Audit_Projects.csv") 

xx<-sort(table(fin.df$name),decreasing=TRUE)

xa<-as.data.frame(row.names(xx))
xb<-as.data.frame(as.integer(xx))
xc<-cbind(xa,xb)

xc<-subset(xc,grepl("^.+(.shp|.tif|.TIF|.kml|.tiff|.img|.csv|.adf|.asc|.bil)$",row.names(xx)))

xd<-data.frame(matrix(nrow=length(xc[,1]),ncol=1))
names(xd)<-c("tmp")
i<-1
for (i in 1:length(xc[,1])){
  setwd(dirname(fin.df[grep(xc[i,1],fin.df$name)[1],1]))
  shp.log<-file.info(fin.df[grep(xc[i,1],fin.df$name)[1],3])[,6]
  shp.log<-substr(shp.log,1,10)
  xd[i,]<-shp.log
  setwd("C:/Users/carbon-gis/Documents/BCP_Data/Projects/EasternZambia_USAID")
  print(i)
}

xe<-cbind(xc,xd)
xe<-na.omit(xe)
names(xe)<-c("file","occur","dte")

write.csv(xe,file="CFP_Data_Audit_Shapefiles_Num.csv")

# Now search for all files that match the file extensions in the xe df - These will then be cross referenced to 
# find those files on the disk which are not used in a project. These will then be cleaned up and added to an
# archive folder.

xx<-as.data.frame(list.files(path="C:/Users/carbon-gis/Documents/BCP_Data/Projects/EasternZambia_USAID", full.names=TRUE, pattern=unique(substr(xe[,1],nchar(as.character(xe[,1]))-3,nchar(as.character(xe[,1])))),recursive=TRUE))
names(xx)<-c("file")

# Append file names to the data.frame

xy <- basename(as.character(xx[,1]))

xxa<- cbind(xx,xy)


xx<-subset(xxa,grepl("^.+(.shp|.tif|.TIF|.kml|.tiff|.img|.csv|.adf|.asc|.bil)$",xy))
names(xx)<-c("filenamePath","fileName")
xx[,fileName]<-NA

#i<-1
#for (i in 1:length(xx[,1])){
#  xx[i,2]<-basename(as.character(xx[i,1]))
#}

to.archive<-xx[!(xx$fileName %in% xe$file),]

write.csv(to.archive,file="CFP_Data_Audit_Archive.csv")

##################################Not Needed##################################

#i<-1
#for (i in 1:length(b[,1])) {
#  xmlfile=xmlParse(paste(b[i,]))
#  xmltop = xmlRoot(xmlfile) #gives content of root
#  c<-(xmlSize(xmltop))
#  t.df[i,]<-c
#}

#ab<-cbind(b,t.df)
#names(ab)<-c("files","node_num")

