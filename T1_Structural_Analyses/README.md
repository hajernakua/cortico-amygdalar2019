This README.md file explains the step-by-step process of all the pre-processing and analyses in the correct order for the T1-weighted imaging. 

Step 1: pre-processing all raw T1 and rs-fMRI data using the fMRIprep pipeline (v1.1.1) using the freesurfer tag for anatomical reconstruction (script: fMRIprep_pre-processing.sh)

Step 2: run the raw T1 and rs-fMRI scans through the MRIQC pipeline (v0.11.0; script: MRIQC_pre-processing.sh)

Step 3: Smooth the pre-processed data (script: smoothing_T1w_data.sh)

Step 4: perform quality control using the QC Protocol ([T1w_Protocol](https://htmlpreview.github.io/?https://github.com/hajernakua/cortico-amygdalar2019/blob/master/T1_Structural_Analyses/T1w_Protocol.html))

Step 5: parcellate left and right amygdala volumes (script: DK_atlas_parcellations)

Step 7: run PALM for cortical thickness and cortico-amygdalar covariance analysis 
        7a. prepare design matrix (script: creating_design_matrix_structural.R)
        7b. run PALM using singularity containers (script: PALM_structural.sh & PALM_singularity_container_structural_data)
