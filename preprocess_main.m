%% the main script for preprocess eye-link data (one subject version)
%basic value 
% nun_data=8; name_data={'HL021010','HR022314','LL020812','LR022114','UL021615','UR020111','VL021714','VU020214'};
% pathway='F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Experimental_SetUp\Data\ET\Full_distance_radialtangential\Block1\eyedata\MATs\';
% pathway_csv='F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Experimental_SetUp\Data\ET\Full_distance_radialtangential\Block1\';
% stim_name='_Dat_stim.mat';
% tabname='_tab.mat';
% csv_file_name='expResET_RadialBias_pilot1_';
% csv_con_name={'HL.csv','HR.csv','LL.csv','LR.csv','UL.csv','UR.csv','VL.csv','VU.csv'};
% loc={'loc_315','loc_135','loc_225','loc_45','loc_270','loc_90','loc_180','loc_0'};
csv_filepath='F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Experimental_SetUp\Data\SX\Full_distance_radialtangential\Block1\expResSX_RadialBias_pilot1_LL.csv';
edf2asc = 'F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Analysis\edf2asc';
edf_path='F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Experimental_SetUp\Data\SX\Full_distance_radialtangential\Block1\eyedata\LL110912.edf';
[path_folder,~,~] = fileparts(edf_path);
%%
[path_tab,path_stim,path_blink]=convert(edf_path,edf2asc);%create raw tab file and stim file and blink file
path_newtab=converge(path_tab,csv_filepath);
outside_path=check_outside(path_stim);
outside_tab=add_outside(path_newtab,outside_path);
final_tab=add_blink(outside_tab,path_blink);