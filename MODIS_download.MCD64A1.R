

library(RCurl)
library(httr)

wd <- "C:/Users/RobertsJo/Documents/FAO_Rome_2017/Data/GIS/Projects/PNG_Burn/Raster"
setwd(wd)


pattern <- c("*.h31v09.*","*.h32v09.*","*.h33v09.*","*.h32v10.*","*.h33v10.*")
time <- 2000

while (time < 2018){
  url<- paste("ftp://user:burnt_data@ba1.geog.umd.edu/Collection6/HDF","/",time,"/",sep="")
  curl <- getCurlHandle()
  curlSetOpt(.opts=list(forbid.reuse=1),curl=curl)
  filenames <- getURL(url,ftp.use.epsv=TRUE, dirlistonly = TRUE, curl=curl) #reading filenames from ftp-server
  filenames <- strsplit(filenames, "\r\n")
  filenames <- unlist(filenames)
  df.filenames <- as.data.frame(filenames)
  j <- 1
  for (j in j:length(df.filenames[,1])) {
    url2 <- paste("ftp://user:burnt_data@ba1.geog.umd.edu/Collection6/HDF","/",time,"/", df.filenames[j,],"/",sep="")
    curl <- getCurlHandle()
    curlSetOpt(.opts=list(forbid.reuse=1),curl=curl)
    filenames2 <- getURL(url2,ftp.use.epsv=TRUE, dirlistonly = TRUE, curl=curl)
    filenames2 <- strsplit(filenames2, "\r\n")
    filenames2 <- unlist(filenames2)
    df.filenames2 <- as.data.frame(filenames2)
    d.files <- as.data.frame(df.filenames2[ with(df.filenames2, grepl(paste(pattern,collapse = "|"),filenames2) ),])
    names(d.files) <- c("data")
    #download the files
    k <- 1
    for (k in k:length(d.files[,1])){  
      url3 <- paste("ftp://user:burnt_data@ba1.geog.umd.edu/Collection6/HDF","/",time,"/", df.filenames[j,],"/",sep="")
      print(k)
      download.file(paste(url3,d.files[k,], sep = ""), paste(getwd(), "/", d.files[k,],sep = ""),mode = "wb")
    }
    #Mosaic files here
    
  }
  
  
  time<-time+1
  print(time)
  print(filenames)
}



# This works, leave it be
url = "ftp://user:burnt_data@ba1.geog.umd.edu/Collection6/HDF/2000/306/"
filenames = getURL(url,userpwd="user:burnt_data", dirlistonly = TRUE)
filenames <- strsplit(filenames, "\r\n")
filenames = unlist(filenames)
filenames
a<-filenames[2]
a
for (filename in a) {
  download.file(paste(url,filename, sep = ""), paste(getwd(), "/", filename,sep = ""),mode = "wb")
}

curl=httr::handle_find(url)$handle
Sys.sleep(2)