#!/bin/bash

#partition=debug
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --distribution=block:block

#This script will prepare the structural data for analysis in PALM 

#Step 1: load necessary modules
module load mcr/R2018a
module load palm/alpha102
module load connectome-workbench
module load freesurfer/6.0.0


#Step 2: Setting main variables/paths
dir=${1}                                   #output directory 
sublist=${2}                               #path to csv of subjects (organized in one row)
SUBJECT_FILES=${3}                         #path to subject folders (pre-processed)
infile=allsubs_merged.dscalar.nii          #a file we create in this script 
fname=allsubs_merged                       #a file we create in this script 

subjects=`cat $sublist`

#Step 3: Merge smoothed dscalar files of the left amygdala-cortical time series correlations for all participants
args=""
while read subjects
do
    args="${args} -cifti ${input_files}/${subjects}.LA.dscalar.nii"
done < ${sublist}
echo $args

#Step 4a: merge the cifti files into the allsubs_merged.dscalar.nii file 
wb_command -cifti-merge ${infile} ${args}

#Step 4b: Convert the CIFTI files to GIFTI files
wb_command -cifti-separate ${infile} COLUMN -metric CORTEX_LEFT ${fname}_L.func.gii -metric CORTEX_RIGHT ${fname}_R.func.gii
wb_command -gifti-convert BASE64_BINARY ${fname}_L.func.gii ${fname}_L.func.gii
wb_command -gifti-convert BASE64_BINARY ${fname}_R.func.gii ${fname}_R.func.gii


#Step 5: Creating a va.shape.gii file
for sub in $subjects
  do
wb_command -surface-vertex-areas ${SUBJECT_FILES}/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.L.midthickness.32k_fs_LR.surf.gii \
${dir}/tmp/${sub}_L_midthick_va.shape.gii

wb_command -surface-vertex-areas ${SUBJECT_FILES}/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.R.midthickness.32k_fs_LR.surf.gii \
${dir}/tmp/${sub}_R_midthick_va.shape.gii

done


#Step 6: Calculate the mean surface 
#Step 6.a.2: Left hemisphere
MERGELIST=""
while read subjects; do
  MERGELIST="${MERGELIST} -metric ${dir}/tmp/${subjects}_L_midthick_va.shape.gii";
done < ${sublist}

#Step 6.a.2: Creating a func file from the shape file. 
wb_command -metric-merge L_midthick_va.func.gii ${MERGELIST}
wb_command -metric-reduce L_midthick_va.func.gii MEAN L_area.func.gii

#Step 6.b.1: Right hemisphere
MERGELIST=""
while read subjects; do
  MERGELIST="${MERGELIST} -metric $dir/tmp/${subjects}_R_midthick_va.shape.gii";
done < ${sublist}

#Step 6.b.2: Creating a func file from the shape file. 
wb_command -metric-merge R_midthick_va.func.gii ${MERGELIST}
wb_command -metric-reduce R_midthick_va.func.gii MEAN R_area.func.gii
