
image=$1
# Difference Vegetation Index
r.mapcalc "DVI=($image.4@PERMANENT-$image.3@PERMANENT)"
eval `r.info -r DVI`
echo 'DVI min is:' $min
echo 'DVI max is:' $max
r.mapcalc "DVInorm=((DVI)+abs($min))/($max+abs($min))"
eval `r.info -r DVInorm`
echo 'DVInorm min is:' $min
echo 'DVInorm max is:' $max


# Green Difference Vegetation Index
r.mapcalc "GDVI=($image.4@PERMANENT-$image.2@PERMANENT)"
eval `r.info -r GDVI`
echo 'GDVI min is:' $min
echo 'GDVI max is:' $max
r.mapcalc "GDVInorm=((GDVI)+abs($min))/($max+abs($min))"
eval `r.info -r GDVInorm`
echo 'GDVInorm min is:' $min
echo 'GDVInorm max is:' $max

# Green Normalized Difference Vegetation Index
r.mapcalc "GNDVI=($image.4@PERMANENT-$image.2@PERMANENT)/($image.4@PERMANENT+$image.2@PERMANENT)"
eval `r.info -r GNDVI`
echo 'GNDVI min is:' $min
echo 'GNDVI max is:' $max
r.mapcalc "GNDVInorm=((GNDVI)+abs($min))/($max+abs($min))"
eval `r.info -r GNDVInorm`
echo 'GNDVInorm min is:' $min
echo 'GNDVInorm max is:' $max

# Normalized Difference Vegetation Index
r.mapcalc "NDVI=($image.4@PERMANENT-$image.3@PERMANENT)/($image.4@PERMANENT+$image.3@PERMANENT)"
eval `r.info -r NDVI`
echo 'NDVI min is:' $min
echo 'NDVI max is:' $max
r.mapcalc "NDVInorm=((NDVI)+abs($min))/($max+abs($min))"
eval `r.info -r GNDVInorm`
echo 'NDVInorm min is:' $min
echo 'NDVInorm max is:' $max

# Normalized Green Vegetation Index
r.mapcalc "NG=$image.2@PERMANENT/($image.4@PERMANENT+$image.3@PERMANENT+$image.2@PERMANENT)"
eval `r.info -r NG`
echo 'NG min is:' $min
echo 'NG max is:' $max
r.mapcalc "NGnorm=((NG)+abs($min))/($max+abs($min))"
eval `r.info -r NGnorm`
echo 'NGnorm min is:' $min
echo 'NGnorm max is:' $max

# Normalized Red Vegetation Index
r.mapcalc "NR=$image.3@PERMANENT/($image.4@PERMANENT+$image.3@PERMANENT+$image.2@PERMANENT)"
eval `r.info -r NR`
echo 'NR min is:' $min
echo 'NR max is:' $max
r.mapcalc "NRnorm=((NR)+abs($min))/($max+abs($min))"
eval `r.info -r NRnorm`
echo 'NRnorm min is:' $min
echo 'NRnorm max is:' $max

# Normalized NIR Vegetation Index
r.mapcalc "NNIR=$image.4@PERMANENT/($image.4@PERMANENT+$image.3@PERMANENT+$image.2@PERMANENT)"
eval `r.info -r NNIR`
echo 'NNIR min is:' $min
echo 'NNIR max is:' $max
r.mapcalc "NNIRnorm=((NNIR)+abs($min))/($max+abs($min))"
eval `r.info -r NNIRnorm`
echo 'NNIRnorm min is:' $min
echo 'NNIRnorm max is:' $max

# Ratio Vegetation Index
r.mapcalc "RVI=$image.4@PERMANENT/$image.3@PERMANENT"
eval `r.info -r RVI`
echo 'RVI min is:' $min
echo 'RVI max is:' $max
r.mapcalc "RVInorm=((RVI)+abs($min))/($max+abs($min))"
eval `r.info -r RVInorm`
echo 'RVInorm min is:' $min
echo 'RVInorm max is:' $max

# Ratio Green Vegetation Index
r.mapcalc "GRVI=$image.4@PERMANENT/$image.2@PERMANENT"
eval `r.info -r GRVI`
echo 'GRVI min is:' $min
echo 'GRVI max is:' $max
r.mapcalc "GRVInorm=((GRVI)+abs($min))/($max+abs($min))"
eval `r.info -r GRVInorm`
echo 'GRVInorm min is:' $min
echo 'GRVInorm max is:' $max

# Ratio Green Atmospherically Resistant Vegetation Index
r.mapcalc "GARVI=($image.4@PERMANENT-($image.2@PERMANENT-($image.1@PERMANENT-$image.3@PERMANENT)))/($image.4@PERMANENT*($image.2@PERMANENT-($image.1@PERMANENT-$image.3@PERMANENT)))"
eval `r.info -r GARVI`
echo 'GARVI min is:' $min
echo 'GARVI max is:' $max
r.mapcalc "GARVInorm=((GARVI)+abs($min))/($max+abs($min))"
eval `r.info -r GARVInorm`
echo 'GARVInorm min is:' $min
echo 'GARVInorm max is:' $max

# Global Environmental Monitoring Index
r.mapcalc "GEMI=(( (2*(($image.4@PERMANENT * $image.4@PERMANENT)-($image.3@PERMANENT * $image.3@PERMANENT))+1.5*$image.4@PERMANENT+0.5*$image.3@PERMANENT) / ($image.4@PERMANENT + $image.3@PERMANENT + 0.5)) * (1 - 0.25 * (2*(($image.4@PERMANENT * $image.4@PERMANENT)-($image.3@PERMANENT * $image.3@PERMANENT))+1.5*$image.4@PERMANENT+0.5*$image.3@PERMANENT) /($image.4@PERMANENT + $image.3@PERMANENT + 0.5)))-( ($image.3@PERMANENT - 0.125) / (1 - $image.3@PERMANENT))"
eval `r.info -r GEMI`
echo 'GEMI min is:' $min
echo 'GEMI max is:' $max
r.mapcalc "GEMInorm=((GEMI)+abs($min))/($max+abs($min))"
eval `r.info -r GEMInorm`
echo 'GEMInorm min is:' $min
echo 'GEMInorm max is:' $max

# Vegetation Index Green
r.mapcalc "VIG=($image.2@PERMANENT-$image.3@PERMANENT)/($image.2@PERMANENT+$image.3@PERMANENT)"
eval `r.info -r VIg`
echo 'VIg min is:' $min
echo 'VIg max is:' $max
r.mapcalc "VIgnorm=((VIg)+abs($min))/($max+abs($min))"
eval `r.info -r VIgnorm`
echo 'VIgnorm min is:' $min
echo 'VIgnorm max is:' $max

# Vegetation Index Green2
r.mapcalc "VARIg=($image.2@PERMANENT-$image.3@PERMANENT)/($image.2@PERMANENT+$image.3@PERMANENT-$image.1@PERMANENT)"
eval `r.info -r VARIg`
echo 'VARIg min is:' $min
echo 'VARIg max is:' $max
r.mapcalc "VARIgnorm=((VARIg)+abs($min))/($max+abs($min))"
eval `r.info -r VARIgnorm`
echo 'VARIgnorm min is:' $min
echo 'VARIgnorm max is:' $max

# Enhanced Vegetation Index 
r.mapcalc "EVI=2.5*(($image.4@PERMANENT-$image.3@PERMANENT)/($image.4@PERMANENT+6*$image.3@PERMANENT-7.5*$image.1@PERMANENT+1))"
eval `r.info -r EVI`
echo 'EVI min is:' $min
echo 'EVI max is:' $max
r.mapcalc "EVInorm=((EVI)+abs($min))/($max+abs($min))"
eval `r.info -r EVInorm`
echo 'EVInorm min is:' $min
echo 'EVInorm max is:' $max

# Modified Soil Adjusted Vegetation Spectral Index 
r.mapcalc "MSAVI2=(2*$image.4@PERMANENT+1-sqrt((2*$image.4@PERMANENT+1))-8*($image.4@PERMANENT-$image.3@PERMANENT))/2"
eval `r.info -r MSAVI2`
echo 'MSAVI2 min is:' $min
echo 'MSAVI2 max is:' $max
r.mapcalc "MSAVI2norm=((MSAVI2)+abs($min))/($max+abs($min))"
eval `r.info -r MSAVI2norm`
echo 'MSAVI2norm min is:' $min
echo 'MSAVI2norm max is:' $max

# Optimized Soil Adjusted Vegetation Index 
r.mapcalc "OSAVI=(($image.4@PERMANENT-$image.3@PERMANENT)/($image.4@PERMANENT+$image.3@PERMANENT+0.16))*(1+0.16)"
eval `r.info -r OSAVI`
echo 'OSAVI min is:' $min
echo 'OSAVI max is:' $max
r.mapcalc "OSAVInorm=((OSAVI)+abs($min))/($max+abs($min))"
eval `r.info -r OSAVInorm`
echo 'OSAVInorm min is:' $min
echo 'OSAVInorm max is:' $max

# Soil Adjusted Vegetation Index 
r.mapcalc "SAVI=(($image.4@PERMANENT-$image.3@PERMANENT)/($image.4@PERMANENT+$image.3@PERMANENT+0.5))*(1+0.5)"
eval `r.info -r SAVI`
echo 'SAVI min is:' $min
echo 'SAVI max is:' $max
r.mapcalc "SAVInorm=((SAVI)+abs($min))/($max+abs($min))"
eval `r.info -r SAVInorm`
echo 'SAVInorm min is:' $min
echo 'SAVInorm max is:' $max

# Green Soil Adjusted Vegetation Index 
r.mapcalc "GSAVI=(($image.4@PERMANENT-$image.2@PERMANENT)/($image.4@PERMANENT+$image.2@PERMANENT+0.5))*(1+0.5)"
eval `r.info -r GSAVI`
echo 'GSAVI min is:' $min
echo 'GSAVI max is:' $max
r.mapcalc "GSAVInorm=((GSAVI)+abs($min))/($max+abs($min))"
eval `r.info -r GSAVInorm`
echo 'GSAVInorm min is:' $min
echo 'GSAVInorm max is:' $max

# Normalised Difference Water Index
r.mapcalc "NDWI=$image.2@PERMANENT-$image.4@PERMANENT/$image.2@PERMANENT-$image.4@PERMANENT"
eval `r.info -r NDWI`
echo 'NDWI min is:' $min
echo 'NDWI max is:' $max
r.mapcalc "NDWInorm=((NDWI)+abs($min))/($max+abs($min))"
eval `r.info -r NDWInorm`
echo 'GSAVInorm min is:' $min
echo 'GSAVInorm max is:' $max


i.pca input=DVInorm@ForestCover,EVInorm@ForestCover,GARVInorm@ForestCover,GDVInorm@ForestCover,GEMInorm@ForestCover,GNDVInorm@ForestCover,GRVInorm@ForestCover,GSAVInorm@ForestCover,MSAVI2norm@ForestCover,NDVInorm@ForestCover,NGnorm@ForestCover,NNIRnorm@ForestCover,NRnorm@ForestCover,OSAVInorm@ForestCover,RVInorm@ForestCover,SAVInorm@ForestCover,VARIgnorm@ForestCover,VIgnorm@ForestCover output_prefix=VI

eval `r.stats -r VI.1`
