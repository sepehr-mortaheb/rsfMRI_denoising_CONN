function denoising_clinical(preproc_dir, denoised_dir, subject_list, fParams)
% Denoising pipeline based on CONN 
% It is considered that the data has already been preprocessed and saved in
% the proper organized format. 
% Written by Sepehr Mortaheb, PoC lab, CRC-In Vivo Imaging
% 2022-06

% =========================================================================

for i = 1:length(subject_list)
    subj = subject_list{i};
    % =====================================================================
    % reading files 
    
    % reading smoothed functional data in the MNI space 
    fname = dir(fullfile(preproc_dir, subj, ...
        'func/restMotionCorrected/swra*.nii'));
    func_file = cellstr(fullfile(fname.folder, fname.name));
    % reading structural data in the MNI space 
    sname = dir(fullfile(preproc_dir, subj, 'anat/wm*.nii'));
    struct_file = cellstr(fullfile(sname.folder, sname.name));
    % reading GM mask in the MNI space 
    gname = dir(fullfile(preproc_dir, subj, 'anat/wc1*.nii'));
    gm_file = cellstr(fullfile(gname.folder, gname.name));
    % reading WM mask in the MNI space 
    wname = dir(fullfile(preproc_dir, subj, 'anat/wc2*.nii'));
    wm_file = cellstr(fullfile(wname.folder, wname.name));
    % reading CSF mask in the MNI space 
    cname = dir(fullfile(preproc_dir, subj, 'anat/wc3*.nii'));
    csf_file = cellstr(fullfile(cname.folder, cname.name));
    
    % reading movement regressors 
    movname = dir(fullfile(preproc_dir, subj, ...
        'func/restMotionCorrected/rp_*.txt'));
    mov_file = cellstr(fullfile(movname.folder, movname.name));
    % reading outlier volumes 
    outname = dir(fullfile(preproc_dir, subj, ...
        'func/restMotionCorrected/art_regression_outliers_swra*.mat'));
    out_file = cellstr(fullfile(outname.folder, outname.name));
    
    
    % =====================================================================
    % CONN batch initialization 
    batch.filename = fullfile(pwd,'conn_temp.mat');
    
    % =====================================================================
    % CONN Setup
    batch.Setup.nsubjects=1;
    batch.Setup.functionals{1}{1} = func_file;
    batch.Setup.structurals{1} = struct_file;
    batch.Setup.RT = fParams.TR;
    batch.Setup.conditions.names = {'rest'};
    batch.Setup.conditions.onsets{1}{1}{1} = 0;
    batch.Setup.conditions.durations{1}{1}{1} = inf;
    batch.Setup.masks.Grey{1} = gm_file;
    batch.Setup.masks.White{1} = wm_file;
    batch.Setup.masks.CSF{1} = csf_file;
    batch.Setup.covariates.names = {'movement'; 'outliers'};
    batch.Setup.covariates.files = {mov_file; out_file};
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
    
    % =====================================================================
    % running batch 
    conn_batch(batch);
    
    % =====================================================================
    % converting the output to the nifti format and saving it to the save
    % directory 
    curr_path = pwd;
    cd(fullfile(pwd, 'conn_temp/results/preprocessing/'));
    conn_matc2nii
    if ~isfolder(fullfile(denoised_dir, subj))
        mkdir(fullfile(denoised_dir, subj));
    end
    movefile('niftiDATA*.nii', fullfile(denoised_dir, subj));
    cd(curr_path)
    
    % =====================================================================
    % removing unnecessary files and directories 
    delete('conn_temp.mat');
    rmdir('conn_temp*', 's');
end
