


setwd("C:/Users/biocarbon/Documents/BCP_Blog/VCSRemoteSensingTool/Data")
a<-read.csv(file="Plot_Data.csv",header=T,sep=",")
area<-33338
plot_area<-0.045238934211693
pos_plots<-area/plot_area
dd=data.frame(matrix(nrow=186, ncol=1))
names(dd)<-c("P_Uncer")
dd$ID<-1:186
ee<-dd
#Iteratively Remove only one plot and calculate uncertainty
i=1
for (i in 1:length(a$AGB)){
  b<-a[-i,]
  b_sd<-sd(b$AGB)
  b_var<-b_sd^2
  uncer<-sqrt((area^2*b_var/186)*((pos_plots-186)/pos_plots))
  tot_C<-area*mean(b$AGB)
  uncer_P<-uncer/tot_C*100
  dd[i,1]<-uncer_P
  print(i)
  i=i+1
}

#Remove successive numbers of plots starting at 1 and continuing till 100
p=1
i=186
while (i != 1){
#  b<-a[sample(a,i),]
  b<-a[sample(nrow(a), i), ]
  b_sd<-sd(b$AGB)
  b_var<-b_sd^2
  uncer<-sqrt((area^2*b_var/(i))*((pos_plots-(i))/pos_plots))
  tot_C<-area*mean(b$AGB)
  uncer_P<-uncer/tot_C*100
  ee[p,1]<-uncer_P
  print(i)
  i=i-1
  p=p+1
}

x<-ee$ID
y<-ee$P_Uncer

plot(x,y)
curve(do.call(f,c(list(x),coef(fit))),add=TRUE)



#polynomial
f <- function(x,a,b,d) {(a*x^2) + (b*x) + d}
fit <- nls(y ~ f(x,a,b,d), start = c(a=1, b=1, d=1)) 
co <- coef(fit)
curve(f(x, a=co[1], b=co[2], d=co[3]), add = TRUE, col="pink", lwd=2) 

#eponential
f <- function(x,a,b) {a * exp(b * x)}
st <- coef(nls(log(y) ~ log(f(x, a, b)), ee, start = st))
fit <- nls(y ~ f(x,a,b), start = st) 
co <- coef(fit)
curve(f(x, a=co[1], b=co[2]), add = TRUE, col="green", lwd=2) 
 
#logarithmic
f <- function(x,a,b) {a * log(x) + b}
fit <- nls(y ~ f(x,a,b), start = c(a=1, b=1)) 
co <- coef(fit)
curve(f(x, a=co[1], b=co[2]), add = TRUE, col="orange", lwd=2) 









a_sum<-summary(a$AGB)
a_sd<-sd(a$AGB)
std<-function(x) sd(x)/sqrt(length(x))
a_se<-std(a$AGB)
a_var<-a_sd^2
me<-qnorm(0.975)*(a_sd/sqrt(186))

ci_u<-mean(a$AGB)+me
ci_l<-mean(a$AGB)-me
co.var <- function(x) ( 100*sd(x)/mean(x) )
c_var<-co.var(a$AGB)
tot_C<-area*mean(a$AGB)
uncer<-sqrt((area^2*a_var/186)*((pos_plots-186)/pos_plots))
