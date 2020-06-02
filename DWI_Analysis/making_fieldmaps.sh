#!/usr/bin/env bash

##This script was written by Natalie Forde from the TIGR Lab to synthesize fieldmaps 

module load FSL/5.0.10

SUBJECTS=`ls -d sub-*`

for subj in $SUBJECTS; do
	if [[ -d "/data/$subj/ses-01/fmap" ]]; then
    inDir=/data/$subj/ses-01/fmap
    if [[ ! -d "/fmap/$subj" ]]; then
      cd /fmap/
      mkdir $subj
    fi
    tmpdir=/fmap/$subj/tmp
    mkdir $tmpdir

    cd $tmpdir

    # bet $inDir/$subj\_ses-01_magnitude1.nii.gz mag1_bet.nii.gz -R -f 0.6
		# bet $inDir/$subj\_ses-01_run-01_magnitude1.nii.gz mag1_bet.nii.gz -R -f 0.6
		bet $inDir/$subj\_ses-01_run-02_magnitude1.nii.gz mag1_bet.nii.gz -R -f 0.6

    # fsl_prepare_fieldmap SIEMENS $inDir/$subj\_ses-01_phasediff.nii.gz mag1_bet dwi_fieldmap_rads 2.46
		# fsl_prepare_fieldmap SIEMENS $inDir/$subj\_ses-01_run-01_phasediff.nii.gz mag1_bet dwi_fieldmap_rads 2.46
	  fsl_prepare_fieldmap SIEMENS $inDir/$subj\_ses-01_run-02_phasediff.nii.gz mag1_bet dwi_fieldmap_rads 2.46

    # fslmaths dwi_fieldmap_rads -div 6.28 dwi_fieldmap_Hz
		fslmaths dwi_fieldmap_rads -div 6.28 dwi_fieldmap_Hz_run-02

    # mv dwi_fieldmap_Hz.nii.gz /fmap/$subj/
	  mv dwi_fieldmap_Hz_run-02.nii.gz /fmap/$subj/

		cd /fmap/$subj/

    # if [[ -f "dwi_fieldmap_Hz.nii.gz" ]]; then
		if [ -f "dwi_fieldmap_Hz.nii.gz" ] || [ -f "dwi_fieldmap_Hz_run-02.nii.gz" ]; then
      rm -r tmp
    fi
  fi
done
