# usage ./burn_date.sh file_with_image_fileNames yearbeingprocessed
# eg: ./burn_Date.sh 2012.txt 2012



while read file ; do
  eval echo $file
  r.mapcalculator --overwrite amap=$file@$2 formula=if'(A<=365&&A>0,A,0)' outfile=bd_$file
done < $1

#r.mapcalculator --overwrite amap=bd_2012153 bmap=bd_2012183 cmap=bd_2012214 dmap=bd_2012245 emap=bd_2012275 fmap=bd_2012306 formula='max(A,B,C,D,E,F)' outfile=BD_2012

