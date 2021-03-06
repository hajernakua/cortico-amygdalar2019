#!/bin/bash
source /etc/profile.d/modules.sh
source /etc/profile.d/quarantine.sh
module load python/2.7.8-anaconda-2.1.0
module load python-extras/2.7.8
module load whitematteranalysis/2018-07-19

###Script created by Saba Shahab (2018)

if [ -z "$2" ]; then
cat <<EOF

Runs the WMA pipeline on input VTK files

Usage:
$0 <inputdir> <outputdir>

Arguments:  
  <inputdir>       Folder of subject whole brain vtks (expects dir/*/*_TRACTS.vtk)
  <outputdir>      Parent dir
EOF
  exit 1
fi 

inputfolder=$1            # output/vtks
targetdir=$2              # output/

threads=8
nclusters=500
outputfolder=$targetdir

mkdir -p $outputfolder
mkdir -p $outputfolder/registered_subjects


wm_register_multisubject_faster.py \
  -j $threads \
  -norender \
  $inputfolder $outputfolder

wm_cluster_atlas.py \
  -j $threads \
  -k $nclusters \
  $outputfolder/output_tractography \
  $outputfolder/clustered_atlas
#  #-remove_outliers \
