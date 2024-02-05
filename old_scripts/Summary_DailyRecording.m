% Daily recording summary
% Last updated: Jaemin Seol (20/01/10)

close all;clear all;clc;

%% Select file directory

animal_id=input('Nabi or Yoda?','s');
session_date = input('Date(YYYYMMDD) ::','s');
day_num=str2double(input('What Day? :: ','s'));
matlab_num=input('Matlab File Num. :: ','s');
TetrodeNumber = str2double(input('TT Num. :: ','s'));
Session_num = str2double(input('Session Num. :: ','s'));
MaxClusterNum = str2double(input('Max Cluster Num. :: ','s'));

mother_drive = 'D:\NHP project\Data\';

raw_folder_unreal=[mother_drive animal_id '\Behavior\Cxt-Obj Association_6 Objects\' session_date '\Unreal' ];
raw_folder_datapixx=[mother_drive animal_id '\Behavior\Cxt-Obj Association_6 Objects\' session_date '\Datapixx\' session_date matlab_num];
raw_folder_neuralynx=[mother_drive animal_id '\Behavior\Cxt-Obj Association_6 Objects\' session_date '\Neuralynx' ];
processed_folder_neuralynx = [mother_drive animal_id '\processed_data\' session_date];
program_folder= [mother_drive '\Program'];

addpath(genpath(program_folder))


cd(program_folder)

%% Import Behavior data

% Import Unreal Data
import_unreal

% Import Datapixx Data
import_datapixx

% Import Neuralynx Data
import_neuralynx

%% Parsing event, position, and eye data
Parsing_EventAndPosition
Parsing_Eye
%% Spike data loading, parsing, and display
Parsing_Display_Spike

%% Save workspace
cd(processed_folder_neuralynx)
savefilename=[animal_id '_' num2str(session_date) '_ProcessedData.mat']; 
save(savefilename)

%% Eye gaze position 3D map module

% ImportContext