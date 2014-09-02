# Random plot location selection for Leakage Area Monitoring
# Wesley Roberts
# BioCarbon Partners
# Kalk Bay
# 2013/05/31





library(maptools)
library(sp)
library(rgdal)

setwd("~/BCP_Data/Projects/Zam_Rufunsa/Vector/Leakage_Zone")
area=readOGR(dsn=".", layer="RandomPointsLocation_R")


pnts<-spsample(area, n=60, type="random")
n=1
d=list()
for (n in 1:length(pnts))
{
    b<-as.data.frame(pnts[n])
    c1<-as.data.frame(c(b[1],b[2]+50))
    c2<-as.data.frame(c(b[1],b[2]+100))
    c3<-as.data.frame(c(b[1]+50,b[2]))
    c4<-as.data.frame(c(b[1]+50,b[2]+50))
    c5<-as.data.frame(c(b[1]+50,b[2]+100))
    c6<-as.data.frame(c(b[1]+100,b[2]))
    c7<-as.data.frame(c(b[1]+100,b[2]+50))
    c8<-as.data.frame(c(b[1]+100,b[2]+100))
    e<-rbind(b,c1,c2,c3,c4,c5,c6,c7,c8)
    e<-as.data.frame(e)
    plot<-as.data.frame(rbind(paste("Rul",n,sep="",".1"),paste("Rul",n,sep="",".2"),paste("Rul",n,sep="",".3"),paste("Rul",n,sep="",".4"),paste("Rul",n,sep="",".5"),paste("Rul",n,sep="",".6"),paste("Rul",n,sep="",".7"),paste("Rul",n,sep="",".8"),paste("Rul",n,sep="",".9")))
    names(plot)<-c("name")
    f<-cbind(e,plot)
    d[[n]]<-f
    print(n)
    n=n+1
}

out<-do.call("rbind", d)

coordinates(out)<-~x+y

writeOGR(out,'./tmp',layer="Leakage_Plots_New",driver="ESRI Shapefile")
