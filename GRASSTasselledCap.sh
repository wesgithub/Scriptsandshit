#updated on 21-11-2012 using coefficients from Marcello_TasselledCap.pdf 
#removed 4th component and only used coefficients for first three components

echo 'tasseled cap transformation'
echo 'TC.1'
gdal_calc.py -A 2011.n.tif --A 1 -B 2011.n.tif --B 2 -C 2011.n.tif --C 3 -D 2011.n.tif --D 4 -E 2011.n.tif --E 5 -F 2011.n.tif --F 6 --outfile tc1.2011.tif --calc="(0.3037*A)+(0.2793*B)+(0.4343*C)+(0.5585*D)+(0.5082*E)+(0.1863*F)" --type Float32 --NoDataValue 0
echo 'TC.2'
gdal_calc.py -A 2011.n.tif --A 1 -B 2011.n.tif --B 2 -C 2011.n.tif --C 3 -D 2011.n.tif --D 4 -E 2011.n.tif --E 5 -F 2011.n.tif --F 6 --outfile tc2.2011.tif --calc="(-0.2848*A)-(0.2435*B)-(0.5436*C)+(0.7243*D)+(0.0840*E)-(0.1800*F)" --type Float32 --NoDataValue 0
echo 'TC.3'
gdal_calc.py -A 2011.n.tif --A 1 -B 2011.n.tif --B 2 -C 2011.n.tif --C 3 -D 2011.n.tif --D 4 -E 2011.n.tif --E 5 -F 2011.n.tif --F 6 --outfile tc3.2011.tif --calc="(0.1509*A)+(0.1793*B)+(0.3299*C)+(0.3406*D)-(0.7112*E)-(0.4572*F)" --type Float32 --NoDataValue 0

echo 'combining into one image'
gdal_merge.py -n 0 -separate -of GTiff -o TC.2011.tif tc1.2011.tif tc2.2011.tif tc3.2011.tif
rm -rf tc1.2011.tif tc2.2011.tif tc3.2011.tif


#updated on 21-11-2012 using coefficients from tasseledL7.pdf
#removed 4th component and only used coefficients for first three components

echo 'tasseled cap transformation'
echo 'TC.1'
gdal_calc.py -A 2001.tif --A 1 -B 2001.tif --B 2 -C 2001.tif --C 3 -D 2001.tif --D 4 -E 2001.tif --E 5 -F 2001.tif --F 6 --outfile tc1.2001.tif --calc="(0.3561*A)+(0.3972*B)+(0.3904*C)+(0.6966*D)+(0.2286*E)+(0.1596*F)" --type Float32 --NoDataValue 0
echo 'TC.2'
gdal_calc.py -A 2001.tif --A 1 -B 2001.tif --B 2 -C 2001.tif --C 3 -D 2001.tif --D 4 -E 2001.tif --E 5 -F 2001.tif --F 6 --outfile tc2.2001.tif --calc="(-0.3344*A)-(0.3544*B)-(0.4556*C)+(0.6966*D)-(0.0242*E)-(0.263*F)" --type Float32 --NoDataValue 0
echo 'TC.3'
gdal_calc.py -A 2001.tif --A 1 -B 2001.tif --B 2 -C 2001.tif --C 3 -D 2001.tif --D 4 -E 2001.tif --E 5 -F 2001.tif --F 6 --outfile tc3.2001.tif --calc="(0.2626*A)+(0.2141*B)+(0.0926*C)+(0.0656*D)-(0.7629*E)-(0.5388*F)" --type Float32 --NoDataValue 0

echo 'combine into new image'
gdal_merge.py -n 0 -separate -of GTiff -o TC.2001.tif tc1.2001.tif tc2.2001.tif tc3.2001.tif
rm -rf tc1.2001.tif tc2.2001.tif tc3.2001.tif
