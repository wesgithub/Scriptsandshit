
ls *.hdf $1 | while read file; do
	echo $file
	#gzip -d $file
	output=$(echo $file | sed 's/.hdf/.tiff/')	
	echo $output
	gdal_translate -of GTiff "HDF4_EOS:EOS_GRID:"$file":MOD_GRID_Monthly_500km_BA:burndate" tmp1_$output
	gdalwarp -t_srs "+proj=latlong +ellps=sphere" tmp1_$output tmp2_$output
	gdal_translate -a_srs "EPSG:4326" tmp2_$output tmp3_$output
	gdalwarp -te 28.9029 -15.742 29.4016 -15.2357 tmp3_$output $output
	rm -rf tmp*
done






