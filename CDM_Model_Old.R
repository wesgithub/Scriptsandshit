#install.packages("date")
library(date)

setwd("C:/Users/biocarbon/Google Drive/LZRP_VCS_Data/Scenario simulation/Scenario1")


stuff=read.csv("Scenario1_ModelInput-LZRP_VCS_CDM_Points_2013-09-09_add228forest.csv")

head(stuff)
attach(stuff)
Time<-strptime(Observation_Date, "%m/%d/%Y")
Time2<-as.Date(Time)
Zero<-as.Date("2009/10/1")
temp.time<-as.numeric(Zero-Time2)
T.Time<-temp.time*-1
stuff2<-cbind(stuff,T.Time)
formula=State~T.Time
model.glm=glm(formula,data=stuff2,weights=Weight,family=binomial(link = "logit"))
summary(model.glm)

plot(stuff2$T.Time/365,stuff2$State,ylab="Proportion of Area Deforested",xlab="Time (yrs)", xlim=c(-50,50))
time=c((-50*365):(50*365))
response=1/(1+exp(-(model.glm$coefficients[1]+model.glm$coefficients[2]*time)))
lines(time/365,response,lty="solid",col="black")
