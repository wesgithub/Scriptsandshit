
# set.wd('/yourdirectory')


setwd("C:/Users/biocarbon/Documents/BCP_Data/Projects/Zam_Rufunsa/Vector/AA_VCS_Data/Scratch/VCS_Phased_Approach/RF_Classification")
list.files()

cdm <- read.csv("Model_Input-LZRP_VCS_CDM_RandomForest_Classification_2013-10-22.csv")# your .csv; just run the rest


require(ggplot2) || install.packages('ggplot2') 

require(ggplot2)

if(is.null(cdm$Time)){
attach(cdm)
Time<-strptime(Observation_Date, "%m/%d/%Y")
Time2<-as.Date(Time)
Time2
Last<-max(unique(sort(Time2)))

temp.time<-as.numeric(Last-Time2)
T.Time<-temp.time*-1
Time<-T.Time
cdm<-cbind(cdm,Time)
detach(cdm)
}

cdm$Time <-(cdm$Time/365) # days to years

formula=State~Time
model.glm=glm(formula,data=cdm,weights=Weight,family=binomial(link = "logit"))
summary(model.glm)
sink('logistic model summary.txt') # output logistic model summary to working directory
summary(model.glm)
sink()

prop.def<-aggregate(State ~ Time, data= cdm, FUN=mean)
prop.def

sink('proportion.deforestation.txt') #output proportion deforestation to working directory
prop.def 
sink()

time=c((-50):(50))


glm.response <- 1/(1+exp(-(model.glm$coefficients[1]+model.glm$coefficients[2]*time)))


plot.df <- data.frame(glm.response, time)


# add proportion deforestation
prop.def2 <- data.frame(round(prop.def$Time,0), prop.def$State)
name<-c('Time', 'State')
names(prop.def2)<-name
prop.def2

head(plot.df)

match(plot.df$time, prop.def2$Time)

state.list <- rep(NA, length(plot.df$time))

for(i in 1:length(state.list)){
in.temp <-  match(plot.df$time, prop.def2$Time)[i]
state.list[i] <- prop.def2[in.temp,2]
print(i)
}

plot.df2 <- data.frame(plot.df, state.list) 
colnames(plot.df2)[3]<- 'deforestation'



##################################################


# logistic curve


log.model <- ggplot() + geom_line(data=plot.df2, aes(x=time, y=glm.response)) + ylab('Proportion of Area Deforested') + xlab('Time(Years)')

log.model
log.model + ggtitle("Proportion Deforestation Predicted") + geom_point(data=plot.df2, aes(x=time, y=deforestation))



ggsave('Phased_logistic.curve.png') # output plot of logistic model with points for proportion deforestation to working directory



##end
