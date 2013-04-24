#!/bin/bash

# Path to ancillary data on your HD
export ANC_PATH="/home/wesley/work/lndsat_proc/model_archive/LEDAPS_preprocessing_tool"
tar -zxvf $1
gob_A=$(echo $1 | sed -e 's/.tar.gz/_MTL.txt/')
echo $gob_A

meta=$(echo $gob_A | sed -e 's/.txt//' -e 's/_MTL//' -e 's/.met//')

# Run atmospheric correction of the Landsat imagery

echo $meta
lndpm $gob_A
lndcal lndcal.$meta.txt
lndcsm lndcsm.$meta.txt
lndsr lndsr.$meta.txt
lndsrbm.ksh lndsr.$meta.txt


# Extract the bands of interest from the hdf file created by ledaps
gob_B=$(echo lndsr.$meta.txt | sed -e 's/.txt/.hdf/')

# gdal_translate -of GTiff HDF4_EOS:EOS_GRID:"lndsr.L5170071_07119910610.hdf":Grid:band7 temp_ref7.tif


for i in 1 2 3 4 5 7 
do 

  gdal_translate -of GTiff HDF4_EOS:EOS_GRID:"$gob_B":Grid:band$i $i.tif
	gdal_calc.py -A $i.tif --outfile=band$i.scale.tif --calc="A*0.0001" --type Float32 --NoDataValue=-9999
	gdalwarp -te 251920.43 -3647.46 333409.94 56356.2 band$i.scale.tif sub.band$i.scale.tif
done

gdal_merge.py -o $meta.ref_sub.tif -n -9999 -separate -of GTiff sub.band1.scale.tif sub.band2.scale.tif sub.band3.scale.tif sub.band4.scale.tif sub.band5.scale.tif sub.band7.scale.tif 

rm -rf 1.tif 2.tif 3.tif 4.tif 5.tif 7.tif 
rm -rf *.xml
rm -rf band*
rm -rf sub.*
rm -rf *.hdf
rm -rf *.hdr
rm -rf *.TIF
rm -rf *.txt
rm -rf README.GTF
rm -rf *.jpg
rm -rf b6clouds200.temp.file cloud_mask.log






