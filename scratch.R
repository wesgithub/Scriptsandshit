library(raster)
library(gdalUtils)


dir <- file.path(rasterOptions()$tmpdir, 'MODIS')
dir.create(dir, recursive=TRUE)