#!/bin/bash -l
#SBATCH --account=rrg-arisvoin
#SBATCH --job-name=POND_loop_Functional_IB_RA_Subsample_Jan12_Take2
#SBATCH --output=/scratch/a/arisvoin/nakuah/POND_rerun/Bootstrapping/fMRI/1Month/rsfMRI_Boot_Subsample/%x_%j.out
#SBATCH --error=/scratch/a/arisvoin/nakuah/POND_rerun/Bootstrapping/fMRI/1Month/rsfMRI_Boot_Subsample/%x_%j.out
#SBATCH --chdir=/scratch/a/arisvoin/nakuah/POND_rerun/Bootstrapping/fMRI/1Month/rsfMRI_Boot_Subsample
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=80
#SBATCH --time=24:00:00


##this next bit just sets up a python virtual environment with ciftify loaded so we can use the wb_commands in our utility scripts 
module load NiaEnv/2018a
module load gnu-parallel/20180322

cd ~/.conda
module load anaconda3/2018.12 intel/2018.2 hdf5/1.8.20 netcdf/4.6.1
cd envs
source activate env
cd /scratch/a/arisvoin/nakuah/POND_rerun/Bootstrapping/fMRI/1Month/rsfMRI_Boot_Subsample

##this is the parallel command which identifies the utility script + the three arguments 
     # 1. the output directory to be created and used 
     # 2. the subject ID file to be used 
     # 3. the design matrices that matrices the subject IDs
##the seq(1000) tells this script to run this 1000 times 

parallel -j$(nproc) './Running_PALM_bootstrap_utility_script.sh IB_output_{1.} {1.}_subs.csv {1.}_IB_DesignMatrix.csv' :::: <(seq 1000)

