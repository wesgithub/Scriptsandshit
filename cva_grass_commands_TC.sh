#CVA r.mapcalc Commands
r.mask -i input=New_Cloud_Mask@PERMANENT
r.mapcalc 'cva_sandwe_gma=sqrt(pow((TC.2011.1@PERMANENT-TC.2001.1@PERMANENT),2)+pow((TC.2011.2@PERMANENT-TC.2001.2@PERMANENT),2))'
r.mapcalc 'Q1=if(TC.2011.1@PERMANENT>TC.2001.1@PERMANENT && TC.2011.2@PERMANENT>TC.2001.2@PERMANENT,1,0)'
r.mapcalc 'Q2=if(TC.2011.1@PERMANENT>TC.2001.1@PERMANENT && TC.2011.2@PERMANENT<TC.2001.2@PERMANENT,1,0)'
r.mapcalc 'Q3=if(TC.2011.1@PERMANENT<TC.2001.1@PERMANENT && TC.2011.2@PERMANENT>TC.2001.2@PERMANENT,1,0)'
r.mapcalc 'Q4=if(TC.2011.1@PERMANENT<TC.2001.1@PERMANENT && TC.2011.2@PERMANENT<TC.2001.2@PERMANENT,1,0)'
CVA r.mapcalc thresholding Commands
r.mapcalc 'Q1_mag=if(cva_sandwe_gma@Work>0.075 && Q1@Work==1,1,null())'
r.mapcalc 'Q2_mag=if(cva_sandwe_gma@Work>0.075 && Q2@Work==1,1,null())' 
r.mapcalc 'Q3_mag=if(cva_sandwe_gma@Work>0.075 && Q3@Work==1,1,null())'
r.mapcalc 'Q4_mag=if(cva_sandwe_gma@Work>0.075 && Q4@Work==1,1,null())'


cloud_Mask=if(TC.2001.1>0.25 && TC.2001.1<0.35 && TC.2011.1>0.2 && TC.2011.1<0.35,1,null())


2001_clouds=if(TC.2001.1>0.5 && TC.2001.1<10,1,null())

r.mapcalc '2001_shadows=if(TC.2001.1>0 && TC.2001.1<0.17,1,null())'

2011_clouds=if(TC.2011.1>0.5 && TC.2011.1<10,1,null())
r.mapcalc '2011_shadows=if(TC.2011.1>0 && TC.2011.1<0.15,1,null())'

#Check the following link for information on removing small pixels from the cva
#http://lists.osgeo.org/pipermail/grass-user/2007-January/037995.html

#Convert data to nulls for the 5x5 filter
r.mapcalc "Q1_mag.null = isnull(Q1_mag)"
r.mfilter.fp input=Q1_mag.null@Work output=Q1_mag.null.count filter=/home/wesley/work/lndsat_proc/model_archive/temp_proc/ring5X5
r.mapcalc 'Q1_mag.null.count.1=if(Q1_mag.null.count<7,1,null())'
r.mapcalc "Q1_mag.null.count.2 = isnull(Q1_mag.null.count.1)"
r.mfilter.fp input=Q1_mag.null.count.2 output=Q1_mag.null.count.3 filter=/home/wesley/work/lndsat_proc/model_archive/temp_proc/ring3X3
r.mapcalc 'Q1_mag.null.count.4=if(Q1_mag.null.count.3==0,1,null())'

r.out.gdal input=Q1_mag.null.count.4@Work type=Byte output=/home/wesley/work/lndsat_proc/model_archive/temp_proc/Biomass_loss-2001_2010.tif


