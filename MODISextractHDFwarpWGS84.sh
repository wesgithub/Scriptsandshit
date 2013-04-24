gdal_translate -of GTiff "HDF4_EOS:EOS_GRID:"MOD13Q1.A2005257.h20v11.005.2008216174541.hdf":MODIS_Grid_16DAY_250m_500m_VI:250m 16 days NDVI" 2005257_NDVI_Sinu.tif
gdalwarp -t_srs "+proj=latlong +ellps=sphere" 2005257_NDVI_Sinu.tif 2005257_NDVI_LatLong.tif
gdal_translate -a_srs "EPSG:4326" 2005257_NDVI_LatLong.tif 2005257_NDVI_WGS84.tif
