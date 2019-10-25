## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(
  echo = TRUE,
  eval = TRUE, # switch to TRUE when compiling final documentation
  message=FALSE,
  warning=FALSE
)

## ------------------------------------------------------------------------
library(rdwplus)

## ------------------------------------------------------------------------
dem <- system.file("extdata", "dem.tif", package = "rdwplus")
lus <- system.file("extdata", "landuse.tif", package = "rdwplus")
sts <- system.file("extdata", "site.shp", package = "rdwplus")
stm <- system.file("extdata", "streams.shp", package = "rdwplus")

## ------------------------------------------------------------------------
# Path to GRASS
my_grass <- "C:/Program Files/GRASS GIS 7.6"
# If you don't know where the GRASS installation sits on your
# computer, use the following.
# Note this may yield more than one directory, hence the [1]
# my_grass <- search_for_grass()[1]

## ------------------------------------------------------------------------
initGRASS(my_grass, mapset = "PERMANENT", override = TRUE)

## ------------------------------------------------------------------------
check_running()

## ------------------------------------------------------------------------
# Give this function a filepath for a raster
set_envir(dem)

## ------------------------------------------------------------------------
raster_to_mapset(c(dem, lus), as_integer = c(FALSE, TRUE), overwrite = TRUE)

## ------------------------------------------------------------------------
vector_to_mapset(c(sts, stm), overwrite = TRUE)

## ------------------------------------------------------------------------
rasterise_stream("streams", "streams.tif", TRUE)
reclassify_streams("streams.tif", "streams01.tif", overwrite = TRUE)


## ------------------------------------------------------------------------
# Drainage reinforcement
burn_in(dem, "streams01.tif", "burndem.tif", overwrite = TRUE)

## ------------------------------------------------------------------------
# Fill dem
fill_sinks("burndem.tif", "filldem.tif", flags = "a", overwrite = TRUE)

## ------------------------------------------------------------------------
# Derive flow direction and accumulation rasters
derive_flow("filldem.tif", "flowdir.tif", "flowacc.tif", overwrite = TRUE)

## ------------------------------------------------------------------------
plot_GRASS("filldem.tif", col = topo.colors(15))
plot_GRASS("flowdir.tif", col = topo.colors(15))
plot_GRASS("flowacc.tif", col = topo.colors(15))

## ------------------------------------------------------------------------
# Snap sites to flow accumulation grid
snap_sites("site", "flowacc.tif", 2, "snapsite", TRUE)

## ------------------------------------------------------------------------
# Compute metrics
compute_metrics(
  c("lumped", "iFLO", "iEDO", "HAiFLO", "iFLS", "iEDS", "HAiFLS"),
  "landuse.tif", # needs to be integer 
  sts, 
  "dem.tif",
  "flowdir.tif",
  "flowacc.tif", 
  "streams.tif", # needs to be integer
  -1
)

