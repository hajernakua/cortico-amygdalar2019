#!/usr/bin/env bash


#This script was written by Natalie Forde in the TIGR Lab


module load FSL/5.0.10
module load R/3.4.3
module load rstudio/1.1.414

#select and merge dwi niftis


cd /scratch/bin
for subj in $(<single.txt); do
	if [[ -d "/external/data/$subj/ses-01/dwi" ]]; then
    inDir=/external/data/$subj/ses-01/dwi
    if [[ ! -d "/projects/dwi/$subj" ]]; then
    	mkdir /projects/dwi/$subj
    fi

    cd /projects/dwi/$subj

    #single
		if [[ ! -f dwi_single_concat.nii.gz ]]; then
    	if [ -f $inDir/$subj\_ses-01_acq-singleshell19dir_dwi.nii.gz ] & [ $(fslval $inDir/$subj\_ses-01_acq-singleshell19dir_dwi.nii.gz dim4) -ge 22 ]; then
      	dir19=$inDir/$subj\_ses-01_acq-singleshell19dir_dwi

      	if [ -f $inDir/$subj\_ses-01_acq-singleshell20dir_dwi.nii.gz ] & [ $(fslval $inDir/$subj\_ses-01_acq-singleshell20dir_dwi.nii.gz dim4) -ge 23 ]; then
        	dir20=$inDir/$subj\_ses-01_acq-singleshell20dir_dwi

        	if [ -f $inDir/$subj\_ses-01_acq-singleshell21dir_dwi.nii.gz ] &  [ $(fslval $inDir/$subj\_ses-01_acq-singleshell21dir_dwi.nii.gz dim4) -ge 24 ]; then
          	dir21=$inDir/$subj\_ses-01_acq-singleshell21dir_dwi

          	fslmerge -t dwi_single_concat.nii.gz ${dir19}.nii.gz ${dir20}.nii.gz ${dir21}.nii.gz

          	Rscript /scratch/nforde/homotopic/bin/bind_bvals_bvecs.r $subj ${dir19}.bval ${dir20}.bval ${dir21}.bval
          	Rscript /scratch/nforde/homotopic/bin/bind_bvals_bvecs.r $subj ${dir19}.bvec ${dir20}.bvec ${dir21}.bvec
        	fi
      	fi
    	fi
		fi
	fi
done

cd /scratch/nforde/homotopic/bin
for subj in $(<multi.txt); do
	if [[ -d "/external/data/$subj/ses-01/dwi" ]]; then
    inDir=/external/data/$subj/ses-01/dwi
    if [[ ! -d "/projects/dwi/$subj" ]]; then
    	mkdir /projects/dwi/$subj
    fi

    cd /projects/dwi/$subj

		if [[ ! -f dwi_multi_concat.nii.gz ]]; then
    	if [ -f $inDir/$subj\_ses-01_acq-multishell30dir_dwi.nii.gz ] & [ $(fslval $inDir/$subj\_ses-01_acq-multishell30dir_dwi.nii.gz dim4) -ge 35 ]; then
      	dir30=$inDir/$subj\_ses-01_acq-multishell30dir_dwi

      	if [ -f $inDir/$subj\_ses-01_acq-multishell40dir_dwi.nii.gz ] & [ $(fslval $inDir/$subj\_ses-01_acq-multishell40dir_dwi.nii.gz dim4) -ge 45 ]; then
        	dir40=$inDir/$subj\_ses-01_acq-multishell40dir_dwi

        	if [ -f $inDir/$subj\_ses-01_acq-multishell60dir_dwi.nii.gz ] & [ $(fslval $inDir/$subj\_ses-01_acq-multishell60dir_dwi.nii.gz dim4) -ge 66 ]; then
          	dir60=$inDir/$subj\_ses-01_acq-multishell60dir_dwi

          	fslmerge -t dwi_multi_concat.nii.gz $dir30.nii.gz $dir40.nii.gz $dir60.nii.gz

          	Rscript /scratch/homotopic/bin/bind_bvals_bvecs.r $subj $dir30.bval $dir40.bval $dir60.bval
          	Rscript /scratch/homotopic/bin/bind_bvals_bvecs.r $subj $dir30.bvec $dir40.bvec $dir60.bvec
        	fi
      	fi
    	fi
		fi
	fi

done
