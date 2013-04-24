## Rescale bands 4 for 1984 and 2010 using r.scale and the eval command
## Usage texture.sh <name of 1984 scene> <name of 2010 scene> 

g.region -d

A_1984=$1
B_2010=$2


echo $A_1984.4@PERMANENT
r.mapcalc "int_1984=int($A_1984.4@PERMANENT*10000)"
eval `r.info -r int_1984`
echo '1984 min is:' $min
echo '2010 max is:' $max
r.rescale --overwrite input=int_1984 from=$min,$max output=1984_nir_rescale_8bit to=0,255

echo $B_2010.4@PERMANENT
r.mapcalc "int_2010=int($B_2010.4@PERMANENT*10000)"
eval `r.info -r int_2010`
echo '1984 min is:' $min
echo '2010 max is:' $max
r.rescale --overwrite input=int_2010 from=$min,$max output=2010_nir_rescale_8bit to=0,255


# g.region region=Texture_test@Texture

r.texture -s input=1984_nir_rescale_8bit prefix=Tex_1984
r.texture -s input=2010_nir_rescale_8bit prefix=Tex_2010

r.mapcalc "var_chnge=Tex_2010_SA_0-Tex_1984_SA_0"

r.mapcalc "var_chnge_qnt=if(var_chnge>3.6,1,null())"



