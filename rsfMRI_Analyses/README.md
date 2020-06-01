This README.md file explains the step-by-step process of all the pre-processing and analyses in the correct order for the rs-fMRI data

Step 1: pre-processing all raw rs-fMRI using the fMRIprep pipeline (script: ___)

Step 2: run the raw rs-fMRI acquisitions through the MRIQC pipeline (script: ___)

Step 3: clean the fMRI data using ciftify within a singularity container (script: fMRI_cleaning.sh)

Step 4: exclude participants with too much motion using mean framewise displacement (this will be provided by the MRIQC pipeline in the bold.csv file)

Step 5: seed-based connectivity analysis. This script will parcellate the amygdala ROI and correlate the mean time series between the amygdala and each cortical vertex (script: seed_based_connectivity_left-amygdala.sh & seed_based_connectivity_right-amygdala.sh)

Step 6: create the design matrix to use for PALM (script: creating_design_matrix_functional.R)

Step 7: run PALM for the seed-based functional connectivity (script: running_PALM-FSL_fMRI.sh)
