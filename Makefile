
vpath %.gz nc
vpath %.nc nc

crops = Barley.Winter Barley Cassava Cotton Groundnuts Maize.2 Maize Millet Oats.Winter Oats Potatoes Pulses Rapeseed.Winter Rice.2 Rice Rye.Winter Sorghum.2 Sorghum Soybeans Sugarbeets Sunflower Sweet.Potatoes Wheat.Winter Wheat Yams

.PHONY: all wget clean $(crops)

nc = $(crops:%=%.crop.calendar.nc)
fill.nc   = $(crops:%=%.crop.calendar.fill.nc)
# nc = $(unfilled) $(filled)
# gz = $(unfilled:%=%.gz)
# gz += $(filled:%=%.gz)
gz = $(nc:%=%.gz)
fill.gz = $(fill.nc:%=%.gz)

all: $(nc) $(fill.nc) doc

$(crops): %: %.crop.calendar.nc %.crop.calendar.fill.nc

# $(unfilled): %: %.gz
# 	gunzip $<

# $(filled): %: %.gz
# 	gunzip $<

$(nc) $(fill.nc): %: %.gz
	gunzip --force nc/$<

# $(gz): filled unfilled

# filled unfilled: ALL_CROPS_netCDF_5min_$@.tar
# 	tar --extract --directory $@ --file $<
# 

# $(filter-out fill, $(gz)): ALL_CROPS_netCDF_5min_unfilled.tar
$(gz): ALL_CROPS_netCDF_5min_unfilled.tar
	tar -xf ALL_CROPS_netCDF_5min_unfilled.tar -C nc $@


#$(filter fill, $(gz)): ALL_CROPS_netCDF_5min_filled.tar
$(fill.gz): ALL_CROPS_netCDF_5min_filled.tar
	tar -xf ALL_CROPS_netCDF_5min_filled.tar -C nc $@

ALL_CROPS_netCDF_5min_filled.tar:
	wget -nc http://www.sage.wisc.edu/download/sacks/netcdf/5min/ALL_CROPS_netCDF_5min_unfilled.tar

ALL_CROPS_netCDF_5min_unfilled.tar:
	wget -nc http://www.sage.wisc.edu/download/sacks/netcdf/5min/ALL_CROPS_netCDF_5min_filled.tar

doc:
	wget --directory-prefix doc http://www.sage.wisc.edu/download/sacks/README.txt
	wget --directory-prefix doc http://www.sage.wisc.edu/pubs/articles/M-Z/Sacks/sacksetalGEB2010.pdf


clean:
	rm nc/*