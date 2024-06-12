# A resting state fMRI denoising pipeline 

This is an automatic resting state fMRI temporal denoising pipeline based on the [CONN](https://web.conn-toolbox.org). It consists of the following steps: 

- General Linear Modeling (GLM) to regress out the nuisance regressors.
  - 6 motion-related regressors
  - the first derivative of motion-related regressors
  - outlier regressors
  - 5 principal components of eroded WM time series
  - 5 principal components of eroded CSF time series 
- BandPass Filtering 
  - Filtering of GLM residuals in the [0.008, 0.09] Hz frequency band.
    
I tried to make this pipeline as automatic as possible. You just need to set some directories and acquisition parameters, run the pipeline, and sit and drink your coffee!

## Useful info: 

- Make sure that before running the pipeline, you have downloaded the [CONN](https://web.conn-toolbox.org) and have added its directory to the Matlab paths.
- The pipeline considers that your data is already preprocessed using SPM (Check [preprocessing pipeline repository](https://github.com/sepehr-mortaheb/fMRI_preproc_SPM)) and the preprocessed files are organized as follows:
  ```
  preproc_dir -->
              sub-XXX
              sub-YYY
              .
              .
              .
              sub-ZZZ -->
                         ses-xxx
                         ses-yyy
                         .
                         .
                         .
                         ses-zzz -->
                                    anat -->
                                            mwp1sub-ZZZ_ses-zzz_T1w.nii
                                            mwp2sub-ZZZ_ses-zzz_T1w.nii
                                            mwp3sub-ZZZ_ses-zzz_T1w.nii
                                            wmsub-ZZZ_ses-zzz_T1w.nii  
                                    func -->
                                            artResults
                                            MotionCorrected -->
                                                               swrausub-ZZZ_ses-zzz_task-<TaskName>_bold.nii
                                                               rp_sub-ZZZ_ses-zzz_task-<TaskName>_bold.txt
                                                               art_regression_outliers_swrausub-ZZZ_ses-zzz_task-<TaskName>_bold.mat
  ```
- To run the pipeline, open the `Denoising.m` file, set the requested directories and parameters, and run the file.
- If you need to change the hyperparmeters of different denoising steps, open the `func_denoisingBatch.m` file, and set the parameters with your own values accordingly.
- I have tested the pipeline on `macOS Sonoma Version 14.5` and it works without any error.

**Do not hesitate to send your feedback to improve this pipeline!**
