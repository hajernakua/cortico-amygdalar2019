#!/bin/bash 


#This script will extract FA and MD measures from the Slicer Atlas that is applied to all subjects

#Step 1: load necessary modules
module load slicer/0,nightly SGE-extras/1.0


#Step 2: specify the variables for a single subject 
subjects=/path/to/csv

sub="`cat ${subjects}`"


path_to_created_atlas=${1}   #path to the modified mrml file 
heirarchy_file=${2}          #txt file with the heirarchies created
output_dir=${3}              #path to specified output directory


#Step 3: Getting the assigned Node number which is associated with the heirarchy
name_of_heirarchy=${4}   #this is the name of the heirarchy which should match the name on Slicer 

grep -i \
${4} /projects/hnakua/Slicer/Registration_Output/clustered_atlas/iteration_00002/initial_clusters/clustered_tracts_display_100_percent.modified.mrml | cut -d ' ' -f 3

#Step 4: Extracting the left and right hemisphere of each tract (the cingulum and uncinate fasciculus)

#4.a: extracting left hemisphere 
extract_LH() {
/opt/quarantine/slicer/nightly/build/lib/Slicer-4.9/cli-modules/FiberTractMeasurements \
       --outputfile ${output_dir}/${sub}.txt \  #can specify the name of the text file here
       --inputdirectory \ #path to input directory where the applied atlas clusters are located
       --fiberHierarchy \ #path to the mrml cluster file and linking it to the heirarchy node 
       --inputtype Fibers_Hierarchy \
       --separator Comma 
}


#4.b: extracting right hemisphere 
extract_RH() {
/opt/quarantine/slicer/nightly/build/lib/Slicer-4.9/cli-modules/FiberTractMeasurements \
       --outputfile ${output_dir}/${sub}.txt \
       --inputdirectory \
       --fiberHierarchy \
       --inputtype Fibers_Hierarchy \
       --separator Comma 
}


#running the actual functions
while read sub; do
echo "$sub"
extract_LH
echo "done"
done

while read sub; do
echo "$sub"
extract_LH
echo "done"
done 
