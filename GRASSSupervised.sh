



# Import data into Training and vallidation
i.group group=LandsatTMint1984 subgroup=LandsatTMint1984 input=LT1984.1@PERMANENT,LT1984.2@PERMANENT,LT1984.3@PERMANENT,LT1984.4@PERMANENT,LT1984.5@PERMANENT,LT1984.6@PERMANENT
r.in.gdal --overwrite input=/home/wesley/work/Laikipia_forest/Train_Supervised/Training_1984_UTM37N.tif output=Training_1984
r.in.gdal --overwrite input=/home/wesley/work/Laikipia_forest/Train_Supervised/Validation_1984_UTM37N.tif output=Validation_1984
r.mapcalc "Training_1984_F=if(Training_1984>0,Training_1984,null())"
r.mapcalc "Validation_1984_F=if(Validation_1984>0,Validation_1984,null())"
i.gensigset trainingmap=Training_1984_F@Supervised_Classification group=LandsatTMint1984 subgroup=LandsatTMint1984 signaturefile=Train_1984_smap_Supervised maxsig=10
i.smap --overwrite group=LandsatTMint1984 subgroup=LandsatTMint1984 signaturefile=Train_1984_smap_Supervised output=smap_1984_9
r.kappa -w classification=smap_1984_9@Supervised_Classification reference=Validation_1984_F@Supervised_Classification output=1984_9Class_smap_Kappa.txt


i.group group=LandsatTMint2010 subgroup=LandsatTMint2010 input=LT2010.1@PERMANENT,LT2010.2@PERMANENT,LT2010.3@PERMANENT,LT2010.4@PERMANENT,LT2010.5@PERMANENT,LT2010.6@PERMANENT
r.in.gdal --overwrite input=/home/wesley/work/Laikipia_forest/Train_Supervised/Training_2010_UTM37N.tif output=Training_2010
r.in.gdal --overwrite input=/home/wesley/work/Laikipia_forest/Train_Supervised/Validation_2010_UTM37N.tif output=Validation_2010
r.mapcalc "Training_2010_F=if(Training_2010>0,Training_2010,null())"
r.mapcalc "Validation_2010_F=if(Validation_2010>0,Validation_2010,null())"
i.gensigset trainingmap=Training_2010_F@Supervised_Classification group=LandsatTMint2010 subgroup=LandsatTMint2010 signaturefile=Train_2010_smap_Supervised maxsig=10
i.smap --overwrite group=LandsatTMint2010 subgroup=LandsatTMint2010 signaturefile=Train_2010_smap_Supervised output=smap_2010_9
r.kappa -w classification=smap_2010_9@Supervised_Classification reference=Validation_2010_F@Supervised_Classification output=2010_9Class_smap_Kappa.txt


# 1984 Image
