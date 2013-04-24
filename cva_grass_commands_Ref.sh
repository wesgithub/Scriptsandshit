#Updated to use reflectance bands as opposed to components of TC transformation
#21-11-2012
#Wesley Roberts 
#BioCarbon Partners (Kalk Bay)
#Errors present in this code do not use!

#CVA r.mapcalc Commands
r.mask -i input=New_Cloud_Mask
r.mapcalc 'cva_sandwe_gma_ref=sqrt(pow((2011.4-2001.4),2)+pow((2011.3-2001.3),2))'
r.mapcalc 'Q1=if(2011.4>2001.4 && 2011.3>2001.3,1,null())'
r.mapcalc 'Q2=if(2011.4>2001.4 && 2011.3<2001.3,1,null())'
r.mapcalc 'Q3=if(2011.4<2001.4 && 2011.3<2001.3,1,null())'
r.mapcalc 'Q4=if(2011.4<2001.4 && 2011.3>2001.3,1,null())'
CVA r.mapcalc thresholding Commands
r.mapcalc 'Q1_mag=if(cva_sandwe_gma_ref@Work>0.05 && Q1@Work==1,1,null())'
r.mapcalc 'Q2_mag=if(cva_sandwe_gma_ref@Work>0.075 && Q2@Work==1,1,null())' 
r.mapcalc 'Q3_mag=if(cva_sandwe_gma_ref@Work>0.075 && Q3@Work==1,1,null())'
r.mapcalc 'Q4_mag=if(cva_sandwe_gma_ref@Work>0.075 && Q4@Work==1,1,null())'


cloud_Mask=if(2001.1>0.25 && 2001.1<0.35 && 2011.1>0.2 && 2011.1<0.35,1,null())


2001_clouds=if(2001.1>0.5 && 2001.1<10,1,null())

r.mapcalc '2001_shadows=if(2001.1>0 && 2001.1<0.17,1,null())'

2011_clouds=if(2011.1>0.5 && 2011.1<10,1,null())
r.mapcalc '2011_shadows=if(2011.1>0 && 2011.1<0.15,1,null())'

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


