clc
clear 
close 

%% Parameters and Directories

% Subject List
subj_names = {'BRÉDO_Chantal'};

% Directories
raw_dir = '/data/project/concussion/Data/clinical/raw/main/'; 
organized_dir = '/data/project/concussion/Data/clinical/raw/organized/';
preproc_dir = '/data/project/concussion/Data/clinical/preprocessed/';
denoised_dir = '/data/project/concussion/Data/clinical/denoised/';
spm_dir = '/home/smortaheb/Softwares/spm12/';
conn_dir = '/home/smortaheb/Softwares/conn/';

addpath(conn_dir);
addpath('./utils');

% fMRI Acquisition Parameters
TR = 0.728;
nslices = 39;
slice_order = 4; % 1: ascending [1:1:nslices]
                 % 2: descending [nsclices:-1:1]
                 % 3: interleaved (bottom -> up): [1:2:nslices 2:2:nslices]
                 % 4: interleaved (top -> down): [nslices:-2:1, nslices-1:-2:1]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fParams = struct();
fParams.TR = TR;
fParams.SO = slice_order;
fParams.NS = nslices;
%% Data Conversion 

data_conversion(subj_names, raw_dir, organized_dir);

%% Preprocessing 

preprocessing_clinical(subj_names, organized_dir, preproc_dir, spm_dir, fParams)

%% Denoising

denoising_clinical(preproc_dir, denoised_dir, subj_names, fParams)

