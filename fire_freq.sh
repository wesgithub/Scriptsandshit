# usage ./fire_freq.sh file_with_image_fileNames yearbeingprocessed
# eg: ./fire_freq.sh 2012.txt 2012



while read file ; do
  eval echo $file
  eval echo null_$file
  r.mapcalculator --overwrite amap=$file@$2 formula=if'(A<=365&&A>0,1,0)' outfile=sc_$file
done < $1

#r.mapcalculator amap=sc_2012153 bmap=sc_2012183 cmap=sc_2012214 dmap=sc_2012245 emap=sc_2012275 fmap=sc_2012306 formula='(A+B+C+D+E+F)' outfile=FF_2012

