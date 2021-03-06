#!/bin/bash
source /etc/profile.d/modules.sh
source /etc/profile.d/quarantine.sh
module load python/2.7.8-anaconda-2.1.0
module load python-extras/2.7.8
module load whitematteranalysis/latest

###############################################################################################
################## This Script was created by Saba Shahab (2018)
###############################################################################################

if [ -z "$2" ]; then
cat <<EOF

Runs the WMA pipeline on input VTK files

Usage:
$0 <inputfile> <outputdir> <atlas> <clusteredmrml>

Arguments:  
  <inputfile>      Path to TRACTS.vtk file for subject
  <outputdir>      Parent output dir
  <atlas>      	   atlas.vtp file from the atlas folder
  <clusteredmrml>  Path to the clustered mrml file

EOF
  exit 1
fi 

inputfolder=$1            # TRACTS.vtk file
outputfolder=$2              # output/
atlas=$3       	          # atlas/
clusteredmrml=$4          # mrml file
filename=`echo $1 | sed "s/.*\///" | sed "s/\..*//"` #replacing the filename and just getting the basename of the file 
atlasDirectory=`dirname $atlas`

mkdir -p $outputfolder

if [ ! -e $outputfolder/RegisterToAtlas/$filename/output_tractography/$filename'_reg.vtk' ]; then
wm_register_to_atlas_new.py \
  $inputfolder $atlas $outputfolder/RegisterToAtlas 
else 
  echo "wm_register_to_atlas_new.py was already run on this subject!"
fi

if [ ! -e $outputfolder/ClusterFromAtlas/$filename'_reg' ]; then
wm_cluster_from_atlas.py \
  -l 20 \
  $outputfolder/RegisterToAtlas/$filename/output_tractography/$filename'_reg.vtk' \
  $atlasDirectory $outputfolder/ClusterFromAtlas
else 
  echo "wm_cluster_from_atlas_new.py was already run on this subject!"
fi

if [ ! -e $outputfolder/OutliersPerSubject1/$filename'_reg_outlier_removed' ]; then
wm_cluster_remove_outliers.py \
  -cluster_outlier_std 4 \
  $outputfolder/ClusterFromAtlas/$filename'_reg' \
  $atlasDirectory \
  $outputfolder/OutliersPerSubject1
else 
  echo "wm_cluster_remove_outliers.py was already run on this subject!"
fi

if [ ! -e $outputfolder/ClusterByHemisphere/'OutliersPerSubject_'$filename ]; then
wm_separate_clusters_by_hemisphere.py \
  -atlasMRML $clusteredmrml \
  $outputfolder/OutliersPerSubject1/$filename'_reg_outlier_removed'/ \
  $outputfolder/ClusterByHemisphere/'OutliersPerSubject_'$filename
else 
  echo "wm_separate_clusters_by_hemisphere.py was already run on this subject!"
fi
