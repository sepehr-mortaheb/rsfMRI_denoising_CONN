function func_denoisingSS(Dirs, Subjects, AcqParams)

preproc_dir = Dirs.preproc;
ses_list = Subjects.sessions; 

for i = 1:length(ses_list)
    subj = Subjects.name;
    ses = ses_list{i};
    
    % Reading necessary files
    
    files = struct();
    % smoothed functional data in the MNI space 
    fname = dir(fullfile(preproc_dir, subj, ses, ...
        'func/MotionCorrected/swra*.nii'));
    files.func = cellstr(fullfile(fname.folder, fname.name));
    % structural data in the MNI space 
    sname = dir(fullfile(preproc_dir, subj, ses, 'anat/wm*.nii'));
    files.struct = cellstr(fullfile(sname.folder, sname.name));
    % GM mask in the MNI space 
    gname = dir(fullfile(preproc_dir, subj, ses, 'anat/mwp1*.nii'));
    files.gm = cellstr(fullfile(gname.folder, gname.name));
    % WM mask in the MNI space 
    wname = dir(fullfile(preproc_dir, subj, ses, 'anat/mwp2*.nii'));
    files.wm = cellstr(fullfile(wname.folder, wname.name));
    % CSF mask in the MNI space 
    cname = dir(fullfile(preproc_dir, subj, ses, 'anat/mwp3*.nii'));
    files.csf = cellstr(fullfile(cname.folder, cname.name));
    % Movement regressors 
    movname = dir(fullfile(preproc_dir, subj, ses, ...
        'func/MotionCorrected/rp_*.txt'));
    files.movment = cellstr(fullfile(movname.folder, movname.name));
    % Outlier volumes regressors
    outname = dir(fullfile(preproc_dir, subj, ses, ...
        'func/MotionCorrected/art_regression_outliers_swra*.mat'));
    files.outlier = cellstr(fullfile(outname.folder, outname.name));
    
    
    % Reading the denoising batch 
    batch = func_denoisingBatch(files, AcqParams);

    % running batch 
    conn_batch(batch);
    
    % converting the output to the nifti format and saving it to the save
    % directory 
    curr_path = pwd;
    cd(fullfile(pwd, 'conn_temp/results/preprocessing/'));
    conn_matc2nii
    denoised_dir = Dirs.save_dir;
    if ~isfolder(fullfile(denoised_dir, subj, ses))
        mkdir(fullfile(denoised_dir, subj, ses));
    end
    movefile('niftiDATA*.nii', fullfile(denoised_dir, subj, ses));
    cd(curr_path)
    
    % =====================================================================
    % removing unnecessary files and directories 
    delete('conn_temp.mat');
    rmdir('conn_temp*', 's');
end
