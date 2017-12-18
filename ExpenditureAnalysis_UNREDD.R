
library(xlsx)
library(plyr)

wd <- "H:/FAO_Zambia-2015_2017/P_UNREDD/TargetedSupport/Reporting_2015-2016"
setwd(wd)
a <- read.xlsx("Zambia Expenditures.xlsx",2,startRow=2,endRow=305, as.data.frame=TRUE,header=TRUE)

a$year<-substr(a$Period,0,4)

write.xlsx(a,"Zambia Expenditures_year.xlsx")

expend<-data.frame(matrix(nrow=0,ncol=4))
names(expend)<-c("Year","Quarter","Activity","Expense")

#Location where expense took place

a$Location[a$Org == "FOADD"|a$Org == "FOMDD"]<-"Rome"
a$Location[a$Org == "FRZAM"]<-"Lusaka"

a.lst<-c(2015,2016,2017)
i=1
for (i in 1:3){
  b <- subset(a, a$year==a.lst[i])
  b$Quarter[b$Period == paste(a.lst[i],"-01",sep="")|b$Period == paste(a.lst[i],"-02",sep="")|b$Period == paste(a.lst[i],"-03",sep="")]<-1
  b$Quarter[b$Period == paste(a.lst[i],"-04",sep="")|b$Period == paste(a.lst[i],"-05",sep="")|b$Period == paste(a.lst[i],"-06",sep="")]<-2
  b$Quarter[b$Period == paste(a.lst[i],"-07",sep="")|b$Period == paste(a.lst[i],"-08",sep="")|b$Period == paste(a.lst[i],"-09",sep="")]<-3
  b$Quarter[b$Period == paste(a.lst[i],"-10",sep="")|b$Period == paste(a.lst[i],"-11",sep="")|b$Period == paste(a.lst[i],"-12",sep="")]<-4
  b$Quarter[b$Period == paste(a.lst[i],"-13",sep="")]<-4
  
  b$Acct<-substr(b$Acct,6,nchar(as.character(b$Acct)))
  b.1<-unique(b$Acct)
  j=1
  for (j in 1:4){
    quart<-subset(b,b$Quarter==j)
    q.expend<-data.frame(matrix(nrow=length(b.1),ncol=4))
    names(q.expend)<-c("Year","Quarter","Activity","Expense")
    k<-1
    for (k in 1:length(b.1)){
      c<-subset(quart,quart$Acct==paste(b.1[k]))
      c$Actuals <- ifelse(c$Actuals>1,c$Actuals,c$Hard.Comm)
      c.sum<-sum(c$Actuals)
      q.expend[k,1]<-paste(a.lst[i])
      q.expend[k,2]<-paste("Q",j,sep="")
      q.expend[k,3]<-paste(b.1[k])
      q.expend[k,4]<-c.sum
      k=k+1
    }
    nme <- paste(a.lst[i],j,sep="-")
    nme <- paste(nme,".csv",sep="")
    write.csv(q.expend,file=nme)
    expend <- rbind(expend,q.expend)
    j=j+1
  }
  i=i+1
}

write.xlsx(expend,"Zambia Expenditures All.xlsx")

loc.exp<-ddply(a, c("Location"), summarize,SUM=sum(Actuals))
loc.exp$year <- "all"
a.2015 <- subset(a, a$year == "2015",select = c(Location,Actuals))
loc.exp.2015<-ddply(a.2015, c("Location"),summarise,SUM=sum(Actuals))
loc.exp.2015$year <- "2015"
a.2016 <- subset(a, a$year == "2016",select = c(Location,Actuals))
loc.exp.2016<-ddply(a.2016, c("Location"),summarise,SUM=sum(Actuals))
loc.exp.2016$year <- "2016"

loc.exp.out <- rbind(loc.exp,loc.exp.2015,loc.exp.2016)

write.xlsx(loc.exp.out,"Zambia Expenditures Locations.xlsx")







