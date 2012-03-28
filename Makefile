
vpath %.gz nc
vpath %.nc nc

# VPATH = nc

crops = Barley.Winter Barley Cassava Cotton Groundnuts Maize.2 Maize Millet Oats.Winter Oats Potatoes Pulses Rapeseed.Winter Rice.2 Rice Rye.Winter Sorghum.2 Sorghum Soybeans Sugarbeets Sunflower Sweet.Potatoes Wheat.Winter Wheat Yams

.PHONY: all wget clean $(crops)

nc = $(crops:%=%.crop.calendar.nc)
fill.nc   = $(crops:%=%.crop.calendar.fill.nc)
gz = $(nc:%=%.gz)
fill.gz = $(fill.nc:%=%.gz)

all: $(nc) $(fill.nc) doc rename

$(crops): %: %.crop.calendar.nc %.crop.calendar.fill.nc rename

$(nc) $(fill.nc): %: %.gz
	gunzip --force nc/$<
	ncrename -O -v plant.start,plant_start nc/$*
	ncrename -O -v plant.end,plant_end nc/$*
	ncrename -O -v tot.days,tot_days nc/$*

$(gz): ALL_CROPS_netCDF_5min_unfilled.tar
	tar -xf ALL_CROPS_netCDF_5min_unfilled.tar -C nc $@

$(fill.gz): ALL_CROPS_netCDF_5min_filled.tar
	tar -xf ALL_CROPS_netCDF_5min_filled.tar -C nc $@

ALL_CROPS_netCDF_5min_filled.tar:
	wget -nc http://www.sage.wisc.edu/download/sacks/netcdf/5min/ALL_CROPS_netCDF_5min_filled.tar

ALL_CROPS_netCDF_5min_unfilled.tar:
	wget -nc http://www.sage.wisc.edu/download/sacks/netcdf/5min/ALL_CROPS_netCDF_5min_unfilled.tar

doc:
	wget --directory-prefix doc http://www.sage.wisc.edu/download/sacks/README.txt
	wget --directory-prefix doc http://www.sage.wisc.edu/pubs/articles/M-Z/Sacks/sacksetalGEB2010.pdf


clean:
	rm nc/*