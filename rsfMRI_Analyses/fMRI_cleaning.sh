#!/bin/bash
#SBATCH --partition=debug
#SBATCH --ntasks=15
#SBATCH --cpus-per-task=8
#SBATCH --distribution=block:block

#Step 1: provide necessary paths
subject=${1}                   #path to csv with all the subjects in a single row 
func_base="ses-01_task-rest_bold"
archive_pipedir=${2}           #folder with all the subjects folders
outdir=${3}                    #output directory
sing_home=${4}                 #home directory
ciftify_container=${5}         #path to singularity container

subs=`cat $subject`            #this allows the script to read in one subject at a time

#These are the parameters for the cleaning of the raw data 
#   "--detrend": true,
#   "--standardize": true,
#   "--cf-cols": "X,Y,Z,RotX,RotY,RotZ,CSF,WhiteMatter,GlobalSignal",
#   "--cf-sq-cols": "X,Y,Z,RotX,RotY,RotZ,CSF,WhiteMatter,GlobalSignal",
#   "--cf-td-cols": "X,Y,Z,RotX,RotY,RotZ,CSF,WhiteMatter,GlobalSignal",
#   "--cf-sqtd-cols": "X,Y,Z,RotX,RotY,RotZ,CSF,WhiteMatter,GlobalSignal",
#   "--low-pass": 0.009,
#   "--high-pass": 0.08,
#   "--drop-dummy-TRs": 3,
#   "--smooth-fwhm": 8


#Step 2: load necessary modules 
module load singularity/2.5.2

#Step 3: cleaning function
ciftify_clean_img() {
      #mkdir -p ${outdir}/ciftify_clean_img/${subs}
      singularity exec \
      -H ${sing_home} \
      -B ${outdir}:/output \
      -B ${archive_pipedir}:/archiveout \
      ${ciftify_container} ciftify_clean_img \
          --output-file=/output/${sub}/${sub}_${func_base}_clean_bold.dtseries.nii \
          --clean-config=/output/ciftify_clean/24MP_8Phys_4GSR.json \  #json file with the cleaning parameters
          --confounds-tsv=/archiveout/fmriprep/${sub}/ses-01/func/${sub}_${func_base}_confounds.tsv \
          --left-surface=/archiveout/ciftify/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.L.midthickness.32k_fs_LR.surf.gii \  #surface file 
          --right-surface=/archiveout/ciftify/${sub}/MNINonLinear/fsaverage_LR32k/${sub}.R.midthickness.32k_fs_LR.surf.gii \ #surface file
          /archiveout/ciftify/${sub}/MNINonLinear/Results/${func_base}/${func_base}_Atlas_s0.dtseries.nii  #output file
}

#Step 4: run the cleaning function
for sub in $subs
do
ciftify_clean_img
echo "Cleaning the rsfMRI data" 
done
