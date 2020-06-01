#!/bin/bash
#partition=debug
#SBATCH --nodes=1
#SBATCH --array=1-200
#SBATCH --cpus-per-task=40
#SBATCH --distribution=block:block

#Step 1: Prepare paths
subject=${1}                  #path to csv with all the subjects in one row 
func_base="ses-01_task-rest_bold"
archive_pipedir=${2}          #path to folder containing all the individual subject folders
input=${3}                    #path to folder with the cleaned .dtseries.nii files (this is the output folder of the fmri cleaning script)
outdir=${4}                   #path to output directory 
seed=${5}                     #path to the folder with all the individual subject functional data
sing_home=${6}                #home folder 
ciftify_container=${7}        #path to singularity container
   
   
subjects=`cat $subject`

#Step 2: Setting up index function so that slurm calls each subject individually for each part of the analysis
index() {
   head -n $SLURM_ARRAY_TASK_ID $subject \
   | tail -n 1
}

#load module
module load singularity

#Step 3: Prepare function to obtain the functional correlation (connectivity) between the amygdala seed and cortical vertices 
ciftify_seed_corr() {
      singularity exec \
      -H ${sing_home} \
      -B ${input}:/input \
      -B ${outdir}:/output \
      -B ${seed}:/seed_file \
      ${ciftify_container} ciftify_seed_corr \
--outputname /output/`index`.LA.dscalar.nii \     #this is the output file name 
--fisher-z \                                      #providing the z scores
--roi-label 18 \                                  #number of the amygdala ROI
/input/`index`/`index`_${func_base}_clean_bold.dtseries.nii \
/seed_file/`index`/MNINonLinear/ROIs/ROIs.2.nii.gz
}

#Step 4: running the function on the condition that input file exists 
if [[ -e "/${input}/`index`/`index`_${func_base}_clean_bold.dtseries.nii" ]]; then
echo "completed ciftify seed correlation for," `index`
ciftify_seed_corr

fi
