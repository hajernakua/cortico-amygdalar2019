#!/bin/bash
source /etc/profile.d/modules.sh
source /etc/profile.d/quarantine.sh
module load SGE-extras/1.0
#module load cuda/7.5
module load FSL/5.0.11
module load MRtrix3/20180123


##This script creates a txt file with a number indicating the overall noise in each participants diffusion scan 

############################################################################################
####################### Script created by John Anderson (2019)
############################################################################################

input_dir=${1}                #input directory
output_dir=${2}               #output directory

for i in `cat Noise_Subs.txt`
do
cp ${indir}/${i}/residualSH_masked.nii.gz ${outdir}/${i}_resSH_masked.nii.gz
done
#now to calculate the average noise ...
for j in `cat Noise_Subs.txt`
do
#reset the noise command...
rm Noise.txt
#first remove the NA values from the image
fslmaths ${j}_resSH_masked.nii.gz -nan ${j}_resSH_masked.nii.gz
#then calculate the average noise for each image...
fslstats ${j}_resSH_masked.nii.gz -M >> Noise.txt
done
