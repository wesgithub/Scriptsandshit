#install.packages("date")
library(date)

#stuff=read.csv(""C:\Users\meljonas\Dropbox\ecoPartners Projects\BioCarbon Rufunsa Ranch\NERs\PhaseII\deforestationmodel.csv"")
stuff=read.csv("C:\\Users\\biocarbon\\Documents\\BCP_Data\\Projects\\Zam_Rufunsa\\Vector\\CDM_Points\\Model_Input_NewCDM_Rufunsa-1555-2013_05_29.csv")

head(stuff)
attach(stuff)
Time<-strptime(Observation_Date, "%m/%d/%Y")
Time2<-as.Date(Time)
Time2
#Zero<-as.Date("2008/9/1")
Zero<-as.Date("2009/10/1")
#T.Time<-as.numeric(Sys.Date()-Time2)
temp.time<-as.numeric(Zero-Time2)
T.Time<-temp.time*-1
T.Time
stuff2<-cbind(stuff,T.Time)

formula=State~T.Time
model.glm=glm(formula,data=stuff2,weights=Weight,family=binomial(link = "logit"))
#model.glm=glm(formula,data=stuff2,family=binomial(link = "logit"))
summary(model.glm)

plot(stuff2$T.Time/365,stuff2$State,ylab="Proportion of Area Deforested",xlab="Time (yrs)", xlim=c(-50,50))
time=c((-50*365):(50*365))
response=1/(1+exp(-(model.glm$coefficients[1]+model.glm$coefficients[2]*time)))
lines(time/365,response,lty="solid",col="black")
