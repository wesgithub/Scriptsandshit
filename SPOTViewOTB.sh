# Bash script to processing SPOTView basic data - the script calls 2 scripts to calculate four different vegetation indices as well as a number of 
# textural measures.
# 
# Command used to sub-set the SPOT DIMAP data //gdalwarp -te 722441.55 8299278.78 724454.35 8301742.93 METADATA.DIM SPOT_Ndu_Clip.tif//
# Latifur Rahman Sarker, Janet E. Nichol, Improved forest biomass estimates using ALOS AVNIR-2 texture indices, Remote Sensing of Environment 115 (2011) 968-977

# Compile the DataPreperation.cxx
cmake ./
make

# Prepare the Vegetation Indices from the SPOT Imagery
./DataPreperation Red_input_1.tif NIR_input_0.tif Green_input_2.tif NDVI.tif SAVI.tif GEMI.tif AVI.tif
# Prepare the textural features
otbcli_HaralickTextureExtraction -in Red_input_1.tif -channel 1 -parameters.xrad 2 -parameters.yrad 2 -texture higher -out texture_2x2.tif
# Extract individual bands from the texture_7x7.tif image.
otbcli_SplitImage -in texture_2x2.tif -out texture.tif
# Merge all bans into one image with multiple channels
gdal_merge.py -o SPOT_NDU_biomass.tif -of GTiff -seperate Green_input_2.tif Red_input_1.tif NIR_input_0.tif NDVI.tif SAVI.tif GEMI.tif AVI.tif texture_0.tif texture_1.tif texture_2.tif texture_3.tif texture_4.tif texture_5.tif texture_6.tif texture_7.tif texture_8.tif

# House keeping

rm -rf AVI.tif GEMI.tif NDVI.tif SAVI.tif texture_0.tif texture_1.tif texture_2.tif texture_3.tif texture_4.tif texture_5.tif texture_6.tif texture_7.tif texture_2x2.tif texture_8.tif

# Use R to process the output using the field measured biomass.




