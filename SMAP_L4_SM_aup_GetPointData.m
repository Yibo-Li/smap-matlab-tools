function [time, data] = SMAP_L4_SM_aup_GetPointData(inFileName, dataFieldName, latitude, longtitude, row, column)
% To access and get point data from SMAP_L4_SM_aup file
% Based on HDF-EOS Tools and Information Center(http://hdfeos.org/zoo/index_openNSIDC_Examples.php#SMAP)
% Paramters:
%   inFileName - SMAP_L4_SM_aup file name, eg SMAP_L4_SM_aup_20150814T090000_Vv2030_001
%   dateFieldName - group/dataset, eg 'Analysis_Data/sm_surface_analysis'
%   latitude, longtitude - point locations
%   row, column - point locations, optional
% Return:
%   data - SMAP level 4 point data value

% Developed by 'Yibo Li' <gansuliyibo@126.com>
% Tested under: MATLAB R2015b
% Last updated: 2018-1-3

% Open the HDF5 File.
file_id = H5F.open (inFileName, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');

Lat_NAME='cell_row';
lat_id=H5D.open(file_id, Lat_NAME);

Lon_NAME='cell_column';
lon_id=H5D.open(file_id, Lon_NAME);

% Read the dataset.
lat=H5D.read(lat_id,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT')';
lon=H5D.read(lon_id,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT')';

%%
for ii = 1 : length(dataFieldName)
    % Open the group/dataset.
    data_id = H5D.open (file_id, char(dataFieldName(ii)));
    temp = H5D.read (data_id,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT')';

    % Read the fill value.
    ATTRIBUTE = '_FillValue';
    attr_id = H5A.open_name (data_id, ATTRIBUTE);
    fillvalue=H5A.read (attr_id, 'H5T_NATIVE_DOUBLE');

    % Replace the fill value with NaN.
    temp(temp==fillvalue) = NaN;

    % Get soil moisture 3-D array
    sm = [lon(:) lat(:) temp(:)];

    % Select data which row and column
    if nargin < 5
        fprintf('You should always give row and column, expect the time when you do not know them. \n');
        [ row, column ] = SMAP_LatLon2RowCol( inFileName, latitude, longtitude );
    end
    temp = sm(sm(:,2)==(row - 1) & sm(:,1)==(column -1 ), 3);

    data(ii) = temp;
end

%%
% Close and release resources.
H5A.close (attr_id);
H5D.close (data_id);
H5F.close (file_id);

% Get time of data
temp = strsplit(inFileName,'_');
time = datetime(temp(5), 'InputFormat', 'yyyyMMdd''T''HHmmss');

% End of this funtion
end
