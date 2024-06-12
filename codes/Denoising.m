clc 
clear 

%% Initialization 

% --- Set the following directories --- 

% Directory of the preprocessed data:
preproc_dir = '';
% Save directory of the results:
save_dir = '';

%##########################################################################
% --- Set the Acquisition Parameters --- 

% The name of the functional task
task_name = 'rest';
% Repetition Time (RT) of the functional acquisition (seconds)
func_TR = 1; 

%##########################################################################
% --- Set the Participants Information --- 

% Subjects list [Ex: {'sub-XXX'; 'sub-YYY'}]
subj_list = {'sub-Test'};

% Sessions list [Ex: {'ses-ZZZ'; 'ses-TTT'}]
ses_list = {'ses-1'};

%##########################################################################
% --- Creating Handy Variables and AddPath Required Directories ---

% Directories Struct 
spm_dir = which('spm');
spm_dir(end-4:end) = [];
conn_dir = which('conn');
conn_dir(end-5:end) = [];
Dirs = struct();
Dirs.preproc = preproc_dir; 
Dirs.out = save_dir;
Dirs.spm = spm_dir;
Dirs.conn = conn_dir;

% Acquisition Parameters Struct
AcqParams = struct();
AcqParams.name = task_name;
AcqParams.tr = func_TR; 

% Subject Information Struct
Subjects(length(subj_list)) = struct();
for i=1:length(subj_list)
    Subjects(i).name = subj_list{i};
    Subjects(i).dir = fullfile(bids_dir, subj_list{i});
    Subjects(i).sessions = ses_list; 
end

% Adding required paths 
addpath(conn_dir);
addpath(spm_dir);
addpath(fullfile(spm_dir, 'src'));
addpath('./functions');

%% Denoising Pipeline 

for subj_num = 1:numel(Subjects)
    func_denoisingSS(Dirs, Subjects(subj_num), AcqParams);
end