README:
Folders:
The /data folder contains a set of netcdf4 files, which can be read using the NetCDF library for Python. Each file corresponds to a single variable, measured over the TAO array. 

/data/sst_anom contains a set of netcdf4 files, each corresponding to the temperature anomaly for a single station. These files are used to calculate ONI for the NINO 3.4 region.


ipynb files: 
Ocean_Prophet.ipynb is the most recent model, and implements the Prophet time-series model to predict ONI one year in advance using a time-lagged ONI compared to ocean properties. The trained model is stored in the variable 'p'.


Lin_reg_buoy, Ocean_Avg, and Ocean_ARIMA all attempt to do similar predictions using lagged ONI, using respectively linear regression on buoy properties, linear regression on the averaged ocean, and ARIMA regression on buoys over time. Lin_reg_buoy and Ocean_Avg use a randomized train_test_split instead of an initial training period chronologically followed by a training set, and so are effectively trained on test data. This error was corrected in later models. 


Data requirements:
All sites in one file
One variable
Select all sites
Netcdf, 4 byte, julian
Start date: 1979, Jan 20.
5-day

Ocean anomaly was obtained through the time section option.-