r.mapcalc "S2GF=if((LandsatTM2010.1-LandsatTM1984.1)<0 && (LandsatTM2010.2-LandsatTM1984.2)<0 && (LandsatTM2010.3-LandsatTM1984.3)<0 && (LandsatTM2010.4-LandsatTM1984.4)>0 && (LandsatTM2010.5-LandsatTM1984.5)<0 && (LandsatTM2010.6-LandsatTM1984.6)<0 ,1 ,null())"

r.mapcalc "V2S=if((LandsatTM2010.1-LandsatTM1984.1)>0 && (LandsatTM2010.2-LandsatTM1984.2)>0 && (LandsatTM2010.3-LandsatTM1984.3)>0 && (LandsatTM2010.4-LandsatTM1984.4)<0 && (LandsatTM2010.5-LandsatTM1984.5)>0 && (LandsatTM2010.6-LandsatTM1984.6)>0 ,1 ,null())"

r.mapcalc "BS2DS=if((LandsatTM2010.1-LandsatTM1984.1)<0 && (LandsatTM2010.2-LandsatTM1984.2)<0 && (LandsatTM2010.3-LandsatTM1984.3)<0 && (LandsatTM2010.4-LandsatTM1984.4)<0 && (LandsatTM2010.5-LandsatTM1984.5)<0 && (LandsatTM2010.6-LandsatTM1984.6)<0 ,1 ,null())"
