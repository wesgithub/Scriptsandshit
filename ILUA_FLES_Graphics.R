library(plyr)
library(xlsx)
library(ggplot2)
library(gridExtra)
library(gtable)
library(scales)
library(reshape2)

setwd("C:/Users/RobertsJo/Documents/P_ILUA/FLES/Results")
options(java.parameters = "-Xmx8g")

#a.1 <- "FLES TABULATIONS with weights.xlsx"
a.1 <- "R-Results.xlsx"

a <- read.xlsx(a.1, sheetName = "Sheet1",startRow = 1,header = TRUE,keepFormulas = FALSE,stringsAsFactors=FALSE)
a.11<-a[1:4,1:3]
a.11[,2]<-as.double(a.11[,2])
a.11[,3]<-as.double(a.11[,3])
a.2 <- ggplot(a.11,aes(a.11$Gender,a.11$Percent,fill=a.11$Percent))+
  geom_bar(position="dodge",stat="identity")+
  theme(text = element_text(size=15), axis.text.x = element_text(angle=90, vjust=1))+
  xlab("Gender")+
  scale_y_continuous(name="Percent (%)", labels = comma)+
  guides(fill=FALSE)+
  ggtitle("Gender Distribution of Household Heads")

fname.gnd <- "Zambia_FLES_Gender_Distribution"
pdf(file=paste(fname.gnd,".pdf",sep=""),width = 11.69, height=8.27, bg="white")
plot(a.2)
dev.off()

 

#############################Size of Land Holdings per province

b <- read.xlsx(a.1, sheetName = "Sheet1",startRow = 7,header = TRUE,keepFormulas = FALSE,stringsAsFactors=FALSE)
names(b) <- c("Province","Male","Female")

b <- b[1:10,]
b.1 <-as.data.frame(t(b[1:10,2:3]))
names(b.1)<-b$Province
b.1$Gender <- row.names(b.1)
row.names(b.1) <- NULL
b.1$name <- factor(b.1$Gender, levels=c("Male","Female"))
b.long<-melt(b.1,id.vars=c("name"))
b.long<-b.long[1:20,]
b.long$value <- as.numeric(b.long$value)


b.3 <- ggplot(b.long,aes(variable,value,fill=name))+
  geom_bar(position="dodge",stat="identity")+
  xlab("Province")+
  scale_y_continuous(name="Area (ha)", labels = comma)+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  ggtitle(expression(atop("Average Size of Land Holding")))

fname.gnd <- "Zambia_FLES_Size_Land_Holding"
pdf(file=paste(fname.gnd,".pdf",sep=""),width = 11.69, height=8.27, bg="white")
plot(b.3)
dev.off()


#############################Size of Agricultural Activities According to Stratum

d <- read.xlsx(a.1, sheetName = "Sheet1",startRow = 21,header = TRUE,keepFormulas = FALSE,stringsAsFactors=FALSE)
d.1 <- as.data.frame(t(d[,2:4]))
names(d.1) <- d$Province
d.1$Stratum <- row.names(d.1)
row.names(d.1) <- NULL

d.1$name <- factor(d.1$Stratum, levels=c("Stratum.1","Stratum.2","Stratum.3"))
d.long<-melt(d.1,id.vars=c("name"))
d.long<-d.long[1:30,]
d.long$value <- as.numeric(d.long$value)

d.3 <- ggplot(d.long,aes(variable,value,fill=name))+
  geom_bar(position="dodge",stat="identity")+
  xlab("Province")+
  scale_y_continuous(name="Area (ha)", labels = comma)+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  ggtitle(expression(atop("Total Agricultural Area per Stratum")))

fname.gnd <- "Zambia_FLES_Size_AG_Province"
pdf(file=paste(fname.gnd,".pdf",sep=""),width = 11.69, height=8.27, bg="white")
plot(d.3)
dev.off()


#############################Forest Product Collection

e <- read.xlsx(a.1, sheetName = "Sheet1",startRow = 35,header = TRUE,keepFormulas = FALSE,stringsAsFactors=FALSE)
names(e) <- c("Province","Own Land","Outside (Customary Land)","Outside (State Land)","Outside (Lease Land)","Other")
e.1 <- as.data.frame(t(e[,2:6]))
names(e.1) <- e$Province
e.1$Location <- row.names(e.1)
row.names(e.1) <- NULL
e.1$name <- factor(e.1$Location, levels=c("Own Land","Outside (Customary Land)","Outside (State Land)","Outside (Lease Land)","Other"))
e.long<-melt(e.1,id.vars=c("name"))
e.long<-e.long[1:50,]
e.long$value <- as.numeric(e.long$value)


e.3 <- ggplot(e.long,aes(variable,value,fill=name))+
  geom_bar(position="dodge",stat="identity")+
  xlab("Province")+
  scale_y_continuous(name="Number of Households", labels = comma)+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  ggtitle(expression(atop("Households Reporting Collecting Forest Products")))

fname.gnd <- "Zambia_FLES_ForestProduct_Province"
pdf(file=paste(fname.gnd,".pdf",sep=""),width = 11.69, height=8.27, bg="white")
plot(e.3)
dev.off()

