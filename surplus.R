## zoo example
x.date <- as.Date(paste(2003, rep(1:4, 4:1), seq(1,19,2), sep = "-"))
x <- zoo(matrix(rnorm(20), ncol = 2), x.date)
x
window(x, start = as.Date("2003-02-01"), end = as.Date("2003-03-01"))
window(x, index = x.date[1:6], start = as.Date("2003-02-01"))
window(x, index = x.date[c(4, 8, 10)])
aa<-zooreg(1:1825,start=as.Date("1997-01-01"))
bb <- subset(aa, index(aa)>=as.Date("1998-12-01")&index(aa)<=as.Date("1999-02-28"))
cc <- subset(aa, index(aa)>=as.Date("1999-12-01")&index(aa)<=as.Date("2000-02-28"))
dd <- subset(aa, index(aa)>=as.Date("2000-12-01")&index(aa)<=as.Date("2001-02-28"))
ee<- rbind(bb,cc,dd)
seas <- as.numeric(format(as.yearqtr(as.yearmon(time(aa)) + 1/12), "%q"))
aa[seas == 1]
gof(djf.day$Simulation,djf.day$Observation)
comb<-c(as.data.frame(e.zoo),as.data.frame(m_disch.zoo)/100)
comb<-as.data.frame(comb)
names(comb)<-c("obs","mod")
comb.zoo<-zooreg(comb, start = as.Date("1996-02-15"))
a.day=cor(e.zoo,m_disch.zoo)
plot.zoo(e.zoo, main="Daily Discharge", ylab="Discharge", xlab="Correlation", ylim=-3:30, sub=as.character(paste(round(a.day,2))))
lines((m_disch.zoo/100), type="l", col=2)
legend("bottomright",colnames(comb), lty = 1:1, col=c(1,2))

#############Daily Time Series Regression and scatter plot#############
dt.reg<-lm(comb$obs~comb$mod)
plot(comb$obs~comb$mod, main="Daily Discharge", sub="a note", ylab="Observed", xlab="Modeled")
abline(dt.reg)
abline(0,1)



x <- pmin(3, pmax(-3, stats::rnorm(50)))
y <- pmin(3, pmax(-3, stats::rnorm(50)))
xhist <- hist(x, breaks=seq(-3,3,0.5), plot=FALSE)
yhist <- hist(y, breaks=seq(-3,3,0.5), plot=FALSE)
top <- max(c(xhist$counts, yhist$counts))

xrange <- c(-3,3)
yrange <- c(-3,3)

par(oma=c(1,0,0,0))
par(mar=c(4,4,2,2))
nf <- layout(matrix(c(1,1,2,2),2,2,byrow=FALSE), widths=c(4,1), heights=c(4,1), TRUE)
layout.show(nf)
plot(x, y, xlab="Obs", ylab="Sim",main="A Title for this page")
par(mar=c(1,1,1,1))
#textplot(print(as.data.frame(djf.gof)),halign="center",valign="top",cex=0.8)
djf.gof<-as.data.frame(djf.gof)
names(djf.gof)<-c("Stats")
textplot(capture.output(djf.gof),halign="left",valign="top",cex=0.8)







mtext(paste(shortname, " ",format(Sys.time(), "%Y-%m-%d %H:%M")),cex=0.75, line=0, side=SOUTH<-1, adj=0, outer=TRUE)


barplot(xhist$counts, axes=TRUE, ylim=c(0, top), space=0, ylab="true")
par(mar=c(3,0,1,1))
barplot(yhist$counts, axes=FALSE, xlim=c(0, top), space=0, horiz=TRUE)
mtext("Some Text")



#############Daily Time Series#############_1
pdf("B81_Daily.pdf")


ggof(Daily_Simulation,Daily_Observation, main="Daily - Observations vs Simulations", ylab="Discharge")
dev.off()

#############Weekly Time Series#############_2
#pdf("B81_Weekly.pdf")
#Weekly<-cbind(Simulation,Observation)
#names(Weekly)<-c("Simulation","Observation")
#Weekly.agg <- aggregate(Weekly, as.Date(7 * floor(as.numeric(time(Weekly)) / 7)), sum)
#ggof(Weekly.agg$Simulation,Weekly.agg$Observation, main="Weekly - Observations vs Simulations", ylab="Discharge")
#dev.off()

#############Monthly Time Series#############_3
pdf("B81_Monthly.pdf")
Monthly<-cbind(Daily_Simulation,Daily_Observation)
names(Monthly)<-c("Simulation","Observation")
Monthly.agg <- aggregate(Monthly, as.Date(as.yearmon(time(Monthly))), sum)
Monthly_Simulation<-Monthly.agg$Simulation
Monthly_Observation<-Monthly.agg$Observation
ggof(Monthly_Simulation,Monthly_Observation, main="Monthly - Observations vs Simulations", ylab="Discharge")
dev.off()

#############Annual Time Series#############_4
pdf("B81_Annual.pdf")
Annual.agg <- aggregate(Monthly.agg, as.Date(365 * floor(as.numeric(time(Monthly.agg)) / 365)), sum)
names(Annual.agg)<-c("Simulation","Observation")
Annual_Simulation<-Annual.agg$Simulation
Annual_Observation<-Annual.agg$Observation
ggof(Annual_Simulation,Annual_Observation, main="Annual - Observations vs Simulations", ylab="Discharge")
dev.off()









#############DJF Time Series#############_5
djf.day<-Daily.sea[seas == 1]
djf.gof<-gof(as.zoo(djf.day$Simulation),as.zoo(djf.day$Observation))
djf.lm<-lm(as.zoo(djf.day$Observation)~as.zoo(djf.day$Simulation))
par(oma=c(1,0,0,0))
par(mar=c(4,4,2,2))
nf <- layout(matrix(c(1,1,2,2),2,2,byrow=FALSE), widths=c(4,1), heights=c(4,1), TRUE)
plot(as.zoo(djf.day$Observation),as.zoo(djf.day$Simulation), xlab="Obs", ylab="Sim",main="DJF Observed vs Modeled")
abline(djf.lm)
abline(0,1)
djf.gof<-as.data.frame(djf.gof)
names(djf.gof)<-c("Stats")
textplot(capture.output(djf.gof),halign="left",valign="top",cex=0.8)

#############MAM Time Series#############_6
mam.day<-Daily.sea[seas == 2]
mam.gof<-gof(as.zoo(mam.day$Simulation),as.zoo(mam.day$Observation))
mam.lm<-lm(as.zoo(mam.day$Simulation)~as.zoo(mam.day$Observation))
par(oma=c(1,0,0,0))
par(mar=c(4,4,2,2))
nf <- layout(matrix(c(1,1,2,2),2,2,byrow=FALSE), widths=c(4,1), heights=c(4,1), TRUE)
plot(as.zoo(mam.day$Observation),as.zoo(mam.day$Simulation), xlab="Obs", ylab="Sim",main="MAM Observed vs Modeled")
abline(mam.lm)
abline(0,1)
mam.gof<-as.data.frame(mam.gof)
names(mam.gof)<-c("Stats")
textplot(capture.output(mam.gof),halign="left",valign="top",cex=0.8)

#############JJA Time Series#############_7
jja.day<-Daily.sea[seas == 3]
jja.gof<-gof(as.zoo(jja.day$Simulation),as.zoo(jja.day$Observation))
jja.lm<-lm(as.zoo(jja.day$Simulation)~as.zoo(jja.day$Observation))
par(oma=c(1,0,0,0))
par(mar=c(4,4,2,2))
nf <- layout(matrix(c(1,1,2,2),2,2,byrow=FALSE), widths=c(4,1), heights=c(4,1), TRUE)
plot(as.zoo(jja.day$Observation),as.zoo(jja.day$Simulation), xlab="Obs", ylab="Sim",main="JJA Observed vs Modeled")
abline(jja.lm)
abline(0,1)
jja.gof<-as.data.frame(jja.gof)
names(jja.gof)<-c("Stats")
textplot(capture.output(jja.gof),halign="left",valign="top",cex=0.8)

#############SON Time Series#############_8
son.day<-Daily.sea[seas == 4]
son.gof<-gof(as.zoo(son.day$Simulation),as.zoo(son.day$Observation))
son.lm<-lm(as.zoo(son.day$Simulation)~as.zoo(son.day$Observation))
par(oma=c(1,0,0,0))
par(mar=c(4,4,2,2))
nf <- layout(matrix(c(1,1,2,2),2,2,byrow=FALSE), widths=c(4,1), heights=c(4,1), TRUE)
plot(as.zoo(son.day$Observation),as.zoo(son.day$Simulation), xlab="Obs", ylab="Sim",main="SON Observed vs Modeled")
abline(son.lm)
abline(0,1)
son.gof<-as.data.frame(son.gof)
names(son.gof)<-c("Stats")
textplot(capture.output(son.gof),halign="left",valign="top",cex=0.8)






















































 