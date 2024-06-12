function batch = func_denoisingBatch(files, AcqParams)

batch = [];
batch.filename = fullfile(pwd,'conn_temp.mat');

% =====================================================================
% CONN Setup
batch.Setup.nsubjects=1;
batch.Setup.functionals{1}{1} = files.func;
batch.Setup.structurals{1} = files.struct;
batch.Setup.RT = AcqParams.TR;
batch.Setup.conditions.names = {'rest'};
batch.Setup.conditions.onsets{1}{1}{1} = 0;
batch.Setup.conditions.durations{1}{1}{1} = inf;
batch.Setup.masks.Grey{1} = files.gm;
batch.Setup.masks.White{1} = files.wm;
batch.Setup.masks.CSF{1} = files.csf;
batch.Setup.covariates.names = {'movement'; 'outliers'};
batch.Setup.covariates.files = {files.movment; files.outlier};
batch.Setup.analyses = 2;
batch.Setup.isnew = 1;
batch.Setup.done = 1;

% =====================================================================
% CONN Denoising
batch.Denoising.filter=[0.008, 0.09];
batch.Denoising.detrending = 1;
batch.Denoising.confounds.names = {'White Matter'; 'CSF'; ...
    'movement'; 'outliers'};
batch.Denoising.confounds.deriv = {0, 0, 1, 0};
batch.Denoising.confounds.dimensions{1} = 5;
batch.Denoising.confounds.dimensions{2} = 5;
batch.Denoising.done=1;