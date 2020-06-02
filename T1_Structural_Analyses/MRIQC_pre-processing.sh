#!/bin/bash


#This code was mostly written by Kevin Witczak 
#version 0.11.0 of MRIQC was used 
#This was carried out using Compute Canada's SciNet Niagara supercomputer cluster 

#SBATCH --account=rrg-arisvoin
#SBATCH --job-name=PNC_MRIQC
#SBATCH --output=/scratch/%x_%j.out
#SBATCH --error=/scratch/%x_%j.err
#SBATCH --chdir=/scratch
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=80
#SBATCH --time=24:00:00export BASE_DIR=/scratch/PNC_fmriprep/MRIQC


export BIDS_DIR=/scratch/data/bids
export SUBJECTS=${BASE_DIR}/subject_list.csv
export SING_CONTAINER=/scratch/containers/MRIQC/poldracklab_mriqc_0.15.1-2019-07-27-957679b56dc5.simg
export SINGULARITYENV_TEMPLATEFLOW_HOME=/home/fmriprep/.cache
export SIZE=$(( $(( $(cat ${SUBJECTS} | wc -l) / $SLURM_JOB_NUM_NODES )) + 1 ))
export SUBSETS=$(realpath $(split --lines=$SIZE \
                                  --numeric-suffixes=1 \
                                  --suffix-length=$(printf "%s" "$SLURM_JOB_NUM_NODES" | wc -c) \
                                  --verbose ${SUBJECTS} \
                                  ${SLURM_JOB_NAME}_subset_ \
                                | cut -d \‘ -f 2 \
                                | cut -d \’ -f 1))echo "Number of allocated nodes: $SLURM_JOB_NUM_NODES :::: Number of subjects per node: <=$SIZE"
echo "$SLURMD_NODENAME acting as batch host submitted to: $SLURM_JOB_NODELIST"main() {
    if [[ $SLURM_JOB_NUM_NODES -gt 1 ]]
    then export INDEX=$(echo "$(while read line
                                do if [[ -n `echo $line | grep '-'` ]]
                                   then eval `echo $line | sed 's/-/ /;s/^/seq -w /'`
                                   else echo $line
                                   fi
                                done < <(echo $SLURM_JOB_NODELIST \
                                             | sed 's/nia//;s/\[//;s/\]//' \
                                             | tr -s ',' '\n' \
                                             | sort -n) \
                                    | awk '{acc += 1}
                                           {print acc" nia"$1}')" \
                                               | grep "$SLURMD_NODENAME" \
                                               | cut -d ' ' -f 1)
         export INDEX_MAP=$(echo "$SUBSETS" \
                                | head -n $INDEX \
                                | tail -n 1)
    else cp ${SUBJECTS} $PWD
         export INDEX_MAP=$(realpath $(basename ${SUBJECTS}))
    fi    echo "$SLURMD_NODENAME was lexicographic ordinate ${INDEX}, and worked on ${INDEX_MAP}, a subset of `cat ${INDEX_MAP} | wc -l` elements."    parallel_run() {
         export ID=$1
         export OUTPUT_DIR=${BASE_DIR}/mriqc
         export WORK_DIR=${BASE_DIR}/work
         export TMP_DIR=${BASE_DIR}/tmp
         
         singularity run \
       -H ${TMP_DIR} \
       -B ${BIDS_DIR}:/bids \
       -B ${OUTPUT_DIR}:/out \
       -B ${WORK_DIR}:/work \
       -B /scratch/tmp/templateflow:/home/fmriprep/.cache/ \
       ${SING_CONTAINER} \
       /bids /out participant \
       --participant_label=${ID} \
       -w /work \
       --no-sub \
       --n_cpus 4 \
       --fd_thres 0.5    }; export -f parallel_run    
       
       echo "Starting run of mriqc on ${ID} on ${SLURMD_NODENAME}."
    parallel \
        --no-notice \
        --keep-order \
        --jobs=20 \
        "parallel_run {}" :::: ${INDEX_MAP}}; export -f main
        
        ##Running the actual functions
module load gnu-parallel/20180322
module load singularity/2.5.2srun --nodelist="$SLURM_JOB_NODELIST" \
     --export=ALL \
     bash -c "main"
