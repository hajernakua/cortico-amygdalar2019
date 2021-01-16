#!/bin/bash


###Step 1. Setting up all the arguments of this script (these are the components of the script that will change for each loop/parallel run)
output_dir=/scratch/a/arisvoin/nakuah/POND_rerun/Bootstrapping/fMRI/1Month/rsfMRI_Boot_Subsample/${1}
mkdir -p ${output_dir}/tmp
sublist=${2}
DesignMatrix=${3}

##need to get the design matrices associated with each output dir into that output dir
mv ${DesignMatrix} ${output_dir}/
cp ContrastMatrix.csv ${output_dir}

#Step 2: setting the main variables and paths for all the consistent paths
main_dir=/scratch/a/arisvoin/nakuah/POND_rerun
SUBJECT_FILES=/scratch/a/arisvoin/mjoseph/POND/derivatives/baseline/ciftify
input_files=/scratch/a/arisvoin/nakuah/POND_rerun/fMRI_Analysis/RA_seed_based_connectivity
infile=${output_dir}/allsubs_merged_RA.dscalar.nii
fname=${output_dir}/allsubs_merged

subjects=`sed 's|"||g' $sublist`
echo $subjects


#Step 3: Merge smoothed dscalar files for all participants
#this is done with a new subject file each time
###this basically provides us with a file of all the subjects brains
args=""
for newsub in $subjects
do
    args="${args} -cifti ${input_files}/${newsub}.RA.dscalar.nii"
done
echo $args


#Step 4: merge the cifti files into the allsubs_merged.dscalar.nii file
##this is one file
wb_command -cifti-merge ${infile} ${args}


#Step 5: Convert the CIFTI files to GIFTI files
wb_command -cifti-separate $infile COLUMN -metric CORTEX_LEFT ${fname}_L_RA.func.gii -metric CORTEX_RIGHT ${fname}_R_RA.func.gii
wb_command -gifti-convert BASE64_BINARY ${fname}_L_RA.func.gii ${fname}_L_RA.func.gii
wb_command -gifti-convert BASE64_BINARY ${fname}_R_RA.func.gii ${fname}_R_RA.func.gii



#Step 6: Creating a va.shape.gii file
##this is the only loop

subjects=`sed 's|"||g' $sublist`
echo $subjects

for sub in $subjects
  do
wb_command -surface-vertex-areas ${SUBJECT_FILES}/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.L.midthickness.32k_fs_LR.surf.gii \
${output_dir}/tmp/${sub}_L_midthick_va.shape.gii

wb_command -surface-vertex-areas ${SUBJECT_FILES}/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.R.midthickness.32k_fs_LR.surf.gii \
${output_dir}/tmp/${sub}_R_midthick_va.shape.gii
done


#Step 7: Calculate the mean surface
#Step 7.a.2: Left hemisphere
MERGELIST=""
for sub2 in ${subjects}
do
  MERGELIST="${MERGELIST} -metric ${output_dir}/tmp/${sub2}_L_midthick_va.shape.gii";
done


#Step 7.a.2: Creating a func file from the shape file.
wb_command -metric-merge L_RA_midthick_va.func.gii ${MERGELIST}
wb_command -metric-reduce L_RA_midthick_va.func.gii MEAN L_RA_area.func.gii

#Step 7.b.1: Right hemisphere
MERGELIST=""
for sub3 in ${subjects}
do
  MERGELIST="${R_MERGELIST} -metric ${output_dir}/tmp/${sub3}_R_midthick_va.shape.gii";
done

#Step 7.b.2: Creating a func file from the shape file.
wb_command -metric-merge R_RA_midthick_va.func.gii ${MERGELIST}
wb_command -metric-reduce R_RA_midthick_va.func.gii MEAN R_RA_area.func.gii

##Step 8: Running PALM through singularity
##running right hemisphere 
##running with no TFCE and one permutation because all I need are the parameter estimates
singularity run --cleanenv \
-H /scratch/a/arisvoin/nakuah/tmp2 \
-B ${output_dir}:/dir \
-B /scratch/a/arisvoin/mjoseph/POND/derivatives/baseline/ciftify:/subfiles \
/scratch/a/arisvoin/mjoseph/containers/PALM/andersonwinkler_palm_alpha115-2019-07-02-fc29916398cd.simg \
-i /dir/allsubs_merged_R_RA.func.gii \
-d /dir/${DesignMatrix} \
-t /dir/ContrastMatrix.csv \
-o /dir/results_R_RA_cort \
-s /subfiles/sub-0880002/MNINonLinear/fsaverage_LR32k/sub-0880002.R.midthickness.32k_fs_LR.surf.gii /dir/R_RA_area.func.gii \
-saveglm \
-logp -n 1 -precision "double"

##running left hemisphere
singularity run --cleanenv \
-H /scratch/a/arisvoin/nakuah/tmp2 \
-B ${output_dir}:/dir \
-B /scratch/a/arisvoin/mjoseph/POND/derivatives/baseline/ciftify:/subfiles \
/scratch/a/arisvoin/mjoseph/containers/PALM/andersonwinkler_palm_alpha115-2019-07-02-fc29916398cd.simg \
-i /dir/allsubs_merged_L_RA.func.gii \
-d /dir/${DesignMatrix} \
-t /dir/ContrastMatrix.csv \
-o /dir/results_L_RA_cort \
-s /subfiles/sub-0880002/MNINonLinear/fsaverage_LR32k/sub-0880002.R.midthickness.32k_fs_LR.surf.gii /dir/L_RA_area.func.gii \
-saveglm \
-logp -n 1 -precision "double"


##Step 9: after getting the outputs from PALM - these commands provide us with the final file we're interested in
wb_command -cifti-create-dense-from-template ${output_dir}/allsubs_merged_RA.dscalar.nii ${output_dir}/results_cort_tfce_tstat_c1_RA.dscalar.nii -metric CORTEX_LEFT ${output_dir}/results_L_RA_cort_dpv_tstat_c1.gii -metric CORTEX_RIGHT ${output_dir}/results_R_RA_cort_dpv_tstat_c1.gii
wb_command -cifti-create-dense-from-template ${output_dir}/allsubs_merged_RA.dscalar.nii ${output_dir}/results_cort_tfce_tstat_c2_RA.dscalar.nii -metric CORTEX_LEFT ${output_dir}/results_L_RA_cort_dpv_tstat_c2.gii -metric CORTEX_RIGHT ${output_dir}/results_R_RA_cort_dpv_tstat_c2.gii
wb_command -cifti-math '(x-y)' ${output_dir}/allsubs_merged_fMRI_${1}_RA_tstat_c12.dscalar.nii -var x ${output_dir}/results_cort_tfce_tstat_c1_RA.dscalar.nii -var y ${output_dir}/results_cort_tfce_tstat_c2_RA.dscalar.nii

wb_command -cifti-convert -to-text ${output_dir}/allsubs_merged_fMRI_${1}_RA_tstat_c12.dscalar.nii ${output_dir}/${1}_allsubs_merged_fMRI_RA_tstat_c12.csv

wb_command -cifti-create-dense-from-template ${output_dir}/allsubs_merged_RA.dscalar.nii results_cope_RA_c1.dscalar.nii -metric CORTEX_LEFT ${output_dir}/results_L_RA_cort_dpv_cope_c1.gii -metric CORTEX_RIGHT ${output_dir}/results_R_RA_cort_dpv_cope_c1.gii
wb_command -cifti-create-dense-from-template ${output_dir}/allsubs_merged_RA.dscalar.nii results_cope_RA_c2.dscalar.nii -metric CORTEX_LEFT ${output_dir}/results_L_RA_cort_dpv_cope_c2.gii -metric CORTEX_RIGHT ${output_dir}/results_R_RA_cort_dpv_cope_c2.gii
wb_command -cifti-math '(x-y)' ${output_dir}/allsubs_merged_RA_${1}_cope_c12.dscalar.nii -var x ${output_dir}/results_cope_RA_c1.dscalar.nii -var y ${output_dir}/results_cope_RA_c2.dscalar.nii

wb_command -cifti-convert -to-text ${output_dir}/allsubs_merged_RA_${1}_cope_c12.dscalar.nii ${output_dir}/${1}_allsubs_merged_fMRI_RA_cope_c12.csv


wb_command -cifti-create-dense-from-template ${output_dir}/allsubs_merged_RA.dscalar.nii results_cohen_RA_c1.dscalar.nii -metric CORTEX_LEFT ${output_dir}/results_L_RA_cort_dpv_cohen_c1.gii -metric CORTEX_RIGHT ${output_dir}/results_R_RA_cort_dpv_cohen_c1.gii
wb_command -cifti-create-dense-from-template ${output_dir}/allsubs_merged_RA.dscalar.nii results_cohen_RA_c2.dscalar.nii -metric CORTEX_LEFT ${output_dir}/results_L_RA_cort_dpv_cohen_c2.gii -metric CORTEX_RIGHT ${output_dir}/results_R_RA_cort_dpv_cohen_c2.gii
wb_command -cifti-math '(x-y)' ${output_dir}/allsubs_merged_RA_${1}_cohen_c12.dscalar.nii -var x ${output_dir}/results_cohen_RA_c1.dscalar.nii -var y ${output_dir}/results_cohen_RA_c2.dscalar.nii

wb_command -cifti-convert -to-text ${output_dir}/allsubs_merged_RA_${1}_cohen_c12.dscalar.nii ${output_dir}/${1}_allsubs_merged_fMRI_RA_cohen_c12.csv
