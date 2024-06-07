clc 
clear 

%% Initialization 

% --- Set the following directories --- 

% Directory of the BIDS formated data:
bids_dir = '';
% Save directory of the fMRI processing:
save_dir = '';

%##########################################################################
% --- Set the Acquisition Parameters --- 

% The name of the functional task
task_name = 'VDT';
% Repetition Time (RT) of the functional acquisition (seconds)
func_TR = 1; 
% Echo time of (TE) of the functional data (ms)
echo_time = [4.92 7.38];
% Total EPI read-out time (ms)
total_EPI_rot = 46.48;

%##########################################################################
% --- Set the Participants Information --- 

% Subjects list [Ex: {'sub-XXX'; 'sub-YYY'}]
subj_list = {'sub-Test'};

% Sessions list [Ex: {'ses-ZZZ'; 'ses-TTT'}]
ses_list = {'ses-1'};

%##########################################################################
% --- Creating Handy Variables and AddPath Required Directories ---

% Directories Struct
art_dir = which('art');
art_dir(end-4:end) = []; 
spm_dir = which('spm');
spm_dir(end-4:end) = [];
Dirs = struct();
Dirs.bids = bids_dir; 
Dirs.out = save_dir;
Dirs.spm = spm_dir;
Dirs.art = art_dir;

% Acquisition Parameters Struct
AcqParams = struct();
AcqParams.name = task_name;
AcqParams.tr = func_TR; 
AcqParams.et = echo_time;
AcqParams.trot = total_EPI_rot; 

% Subject Information Struct
Subjects(length(subj_list)) = struct();
for i=1:length(subj_list)
    Subjects(i).name = subj_list{i};
    Subjects(i).dir = fullfile(bids_dir, subj_list{i});
    Subjects(i).sessions = ses_list; 
end

% Adding required paths 
addpath(art_dir);
addpath(spm_dir);
addpath(fullfile(spm_dir, 'src'));
addpath('./functions');

%% Functional Pipeline 

for subj_num = 1:numel(subj_list)
    subj = subj_list{subj_num};
    func_PipelineSS(Dirs, Subjects(subj_num), AcqParams);
end