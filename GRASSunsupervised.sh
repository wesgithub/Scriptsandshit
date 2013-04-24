i.group group=LandsatTM2010 subgroup=LandsatTM2010 input=LandsatTM2010.1@PERMANENT,LandsatTM2010.2@PERMANENT,LandsatTM2010.3@PERMANENT,LandsatTM2010.4@PERMANENT,LandsatTM2010.5@PERMANENT,LandsatTM2010.6@PERMANENT

i.cluster group=LandsatTM2010 subgroup=LandsatTM2010 sigfile=sig_clust_lsat2010 classes=15 report=rep_clust_lsat2010.txt

i.maxlik --overwrite group=LandsatTM2010 subgroup=LandsatTM2010 sigfile=sig_clust_lsat2010 class=lsat5_2010_clust_classes reject=lsat5_2010_clust_classes.rej

r.neighbors --overwrite input=lsat5_2010_clust_classes@Unsupervised_Classification output=lsat5_2010_clust_classes_ModeFilter3X3 method=mode size=3

r.to.vect -s -v --overwrite input=lsat5_2010_clust_classes_ModeFilter3X3@Unsupervised_Classification output=lsat5_2010_clust_classes_ModeFilter3X3 feature=area

r.out.gdal --overwrite input=lsat5_2010_clust_classes_ModeFilter3X3@Unsupervised_Classification output=lsat5_2010_clust_classes_ModeFilter3X3.tif

v.out.ogr -c --overwrite input=lsat5_2010_clust_classes_ModeFilter3X3@Unsupervised_Classification type=area dsn=.


## recode according to GE Eyeball of classes
r.recode 
r.to.vect -s -v --overwrite input=lsat5_2010_clust_classes_ModeFilter3X3_recode@Unsupervised_Classification output=lsat5_2010_clust_classes_ModeFilter3X3_recode feature=area

r.out.gdal --overwrite input=lsat5_2010_clust_classes_ModeFilter3X3_recode@Unsupervised_Classification output=lsat5_2010_clust_classes_ModeFilter3X3_recode.tif

v.out.ogr -c --overwrite input=lsat5_2010_clust_classes_ModeFilter3X3_recode@Unsupervised_Classification type=area dsn=.




