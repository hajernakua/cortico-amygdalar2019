#!/bin/bash 
 
#This script will smooth the cortical thickness data using ciftify prior to running PALM

#Load necessary modules
#module load python/3.6_ciftify_01
#module load connectome-workbench/1.3.2


#Step 1: Setting the file paths
output_dir=${1}         #directory where the outputs are specified to go
SUBJECT_FILES=${2}      #subject files path


#Step 2: Converting FWHM to sigma
FWHM=12
Sigma=`echo "${FWHM} / 2.355" | bc -l`


#Step 3: running the function to smooth the structural data
for sub in `ls -d ${SUBJECT_FILES}/sub-* | xargs -I '{}' basename {}`;

do

wb_command -cifti-smoothing \
${SUBJECT_FILES}/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.thickness.32k_fs_LR.dscalar.nii \
${Sigma} \
3 \
COLUMN \
${out_dir}/${sub}.thickness.32k_fs_LR.S12.dscalar.nii \
-left-surface ${SUBJECT_FILES}/${sub}/MNINonLinear/fsaverage_LR32k/*L.midthickness.32k_fs_LR.surf.gii \
-right-surface ${SUBJECT_FILES}/${sub}/MNINonLinear/fsaverage_LR32k/*R.midthickness.32k_fs_LR.surf.gii \

echo "Completed Smoothing for ${sub}"

done

 
#link used to convert FWHM to sigma: https://brainder.org/2011/08/20/gaussian-kernels-convert-fwhm-to-sigma/
