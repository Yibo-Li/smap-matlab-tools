clc
clear

% Get Data from SMAP and write to csv file
dataFieldName = {'Observations_Data/tb_h_obs' ...
    'Observations_Data/tb_v_obs' ...
    'Analysis_Data/sm_profile_analysis' ...
    'Analysis_Data/sm_rootzone_analysis' ...
    'Analysis_Data/sm_surface_analysis' ...
    'Analysis_Data/soil_temp_layer1_analysis' ...
    'Analysis_Data/surface_temp_analysis'};

SMAP_L4_SM_aup_GetMultiData('D:\matlab\data', dataFieldName, 286, 2968, './result/shulehe2.csv')
