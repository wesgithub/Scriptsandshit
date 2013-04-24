## Script to convert a number of gpx files to shapefiles extracting only the waypoints from the
## 
#!/bin/bash


ls *.gpx $1 | while read file; do
  echo $file
	output=$(echo $file | sed -e 's/.gpx//')
	echo $output
	ogr2ogr -append -f "ESRI Shapefile" output $file waypoints
	
done
