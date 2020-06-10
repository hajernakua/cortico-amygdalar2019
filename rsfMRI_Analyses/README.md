This README.md file explains the step-by-step process of all the pre-processing and analyses in the correct order for the rs-fMRI data

Step 1: pre-processing all raw rs-fMRI using the fMRIprep pipeline and MRIQC pipeline (script in T1_Structural_Analyses directory)

Step 2: clean the fMRI data using ciftify within a singularity container (script: fMRI_cleaning.sh)

Step 3: exclude participants with too much motion using mean framewise displacement (this will be provided by the MRIQC pipeline in the bold.csv file)

Step 4: seed-based connectivity analysis. This script will parcellate the amygdala ROI and correlate the mean time series between the amygdala and each cortical vertex (script: seed_based_connectivity_left-amygdala.sh & seed_based_connectivity_right-amygdala.sh)

Step 5: create the design matrix to use for PALM (script: creating_design_matrix_functional.R)

Step 6: run PALM for the seed-based functional connectivity (script: running_PALM-FSL_fMRI.sh)
