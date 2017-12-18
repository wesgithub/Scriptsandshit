# R script to look at CSA data
# Exctract the Column headers and the variables from the SAV files
# shared with me by Mr. Misael Kokwe ZAMBIA CSA
# Rome
# 07-10-2017
# Wesley Roberts

library(foreign)
library(xlsx)

# set working directory
wd <- "C:/Users/RobertsJo/Documents/FAO_Rome_2017/NFI_Work/Zambia/SP2_Baseline/CSA/Data/CSA DATA_SPSS/DATA/ARCH"
setwd(wd)
# create a list of files to be opened and investigated
a <- as.data.frame(list.files(path=".", pattern = "*.sav",full.names = TRUE))
names(a) <- c("file")
# list to store the data.frame created
mybiglist<-list()

i <- 1
for (i in 1:length(a[,1])){
  # read the sav file into R as a data.frame
  a.1 <- read.spss(as.character(a[i,]), to.data.frame=TRUE)
  b.1<-attributes(a.1) ## Access the attributes of the survey
  c.1<-b.1$variable.labels ## write variable labels 
  d.1<-as.list(c.1) ## store variable labels in a list
  e.1<-as.data.frame(d.1) ## convert list into data.frame
  f.1<-as.data.frame(t(e.1)) ## transpose the data.frame
  f.1$CDE<-rownames(f.1) ## write row names into the df
  f.1<-f.1[c(2,1)] ## re-order the columns
  names(f.1)<-c("CDE","QUE") ## re-name the columns
  g.1<-substr(as.character(a[i,]),3,nchar(as.character(a[i,]))-4) ## extract the name of the file from the list of files
  mybiglist[[g.1]]<-f.1 ## Append the df to the big list for processing later
  i<-i+1
}

# write the list of df's to an xlsx workbook
wb <- createWorkbook()
saveWorkbook(wb, 'CSA.xlsx')
# this is a mystery but still works
lapply(names(mybiglist), function(x) write.xlsx(mybiglist[[x]], 'CSA.xlsx', sheetName=x, append=TRUE))



