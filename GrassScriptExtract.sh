
r.mapcalc "Train_For1=if(CrossProduct1984_2010_recode@Unsupervised_Classification==1,1,null())"
r.mapcalc "Train_For2=if(CrossProduct1984_2010_recode@Unsupervised_Classification==13,1,null())"
r.patch --overwrite input=Train_For1,Train_For2 output=Train_For

r.mapcalc "Train_Wdl1=if(CrossProduct1984_2010_recode==6,1,null())"
r.mapcalc "Train_Wdl2=if(CrossProduct1984_2010_recode==19,1,null())"
r.patch --overwrite input=Train_Wdl1,Train_Wdl2 output=Train_Wdl


r.mapcalc "Train_Sav=if((CrossProduct1984_2010_recode)==25,1,null())"

r.mapcalc "Train_Grs=if((CrossProduct1984_2010_recode)==30,1,null())"


r.to.vect -s -v --overwrite input=Train_For output=Train_For feature=area

r.to.vect -s -v --overwrite input=Train_Wdl output=Train_Wdl feature=area

r.to.vect -s -v --overwrite input=Train_Sav output=Train_Sav feature=area

r.to.vect -s -v --overwrite input=Train_Grs output=Train_Grs feature=area


v.out.ogr -c -e input=Train_For@Unsupervised_Classification type=area dsn=. olayer=Train_For

v.out.ogr -c -e input=Train_Wdl@Unsupervised_Classification type=area dsn=. olayer=Train_Wdl

v.out.ogr -c -e input=Train_Sav@Unsupervised_Classification type=area dsn=. olayer=Train_Sav

v.out.ogr -c -e input=Train_Grs@Unsupervised_Classification type=area dsn=. olayer=Train_Grs
