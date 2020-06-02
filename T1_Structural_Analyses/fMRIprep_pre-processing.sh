#!/bin/bash -l

#version 1.1.1 of fMRIprep was used to pre-process this data
#This was carried out using Compute Canada's SciNet Niagara supercomputer cluster 

#SBATCH --partition=high-moby
#SBATCH --array=1-470
#SBATCH --nodes=1
#SBATCH --time=24:00:00
#SBATCH --export=ALL
#SBATCH --job-name fmriprep
#SBATCH --output=fmriprep_%j.txt

cd $SLURM_SUBMIT_DIR

STUDY="POND"

sublist="/${STUDY}/code/subject_list.txt"

index() {
   head -n $SLURM_ARRAY_TASK_ID $sublist \
   | tail -n 1
}

BIDS_DIR=/${STUDY}
OUT_DIR=/${STUDY}/derivatives
WORK_DIR=/tmp/${STUDY}

mkdir -p $BIDS_DIR $OUT_DIR $WORK_DIR

singularity run \
  -H /tmp \
  -B ${BIDS_DIR}:/bids \
  -B ${OUT_DIR}:/out \
  -B ${WORK_DIR}:/work \
  -B /tmp/freesurfer_license/license.txt:/li \
  /mnt/tigrlab/archive/code/containers/FMRIPREP/poldracklab_fmriprep_1.1.1-2018-06-07-2f08547a0732.img \
  /bids /out participant \
  --participant_label `index` \
  -w /work \
  --fs-license-file /li \
  --nthreads 8 \
  --output-space T1w template fsaverage fsaverage5 \
  --use-aroma \
  --notrack
