#!/bin/bash


# starts loading the modules
module load slicer/4.8.1 ##4.4 has DWIToDTIEstimation
module load FSL/5.0.7
module load DTIPrep/1.2.8
# module load UKFTractography/2017-10-30
# UKFTractography is already included slicer/4.8.1


inputimage=$1           # input NRRD DWI image
dtiprep_protocol=$2     # xml spec for DTIPrep
outputfolder=$3         # output folder for all outputs
threads=8

#creating the functions
TractographyLabelMapSeeding() {
    Slicer --launch TractographyLabelMapSeeding \
	 "${output_name}_DTI.nrrd" \
	 "${output_name}_SlicerTractography.vtk" \
	 --inputroi "${output_name}_MASK.nrrd" \
	 --useindexspace \
	 --stoppingvalue 0.10
}

DiffusionWeightedVolumeMasking() {
    Slicer --launch DiffusionWeightedVolumeMasking \
	 --removeislands \
	 "${inputimage}" \
	 "${output_name}*_SCALAR.nrrd" \
	 "${output_name}_MASK.nrrd" &&
	TractographyLabelMapSeeding
}

DWIToDTIEstimation() {
    Slicer --launch DWIToDTIEstimation \
	 --enumeration WLS \
	 --shiftNeg \
	 "${inputimage}" \
	 "${output_name}_DTI.nrrd" \
	 "${output_name}_SCALAR.nrrd" &&
	DiffusionWeightedVolumeMasking
}

#running the functions on the condition that the file does not exist
if [[ ! -e "${output_name}_DTI.nrrd" ]]; then
    echo "Running DWIToDTIEstimate on this subject!" &&
	DWIToDTIEstimation;
elif [[ ! -e "${output_name}_MASK.nrrd" ]]; then
    echo "DWIToDTIEstimate was already run on this subject!" &&
	DiffusionWeightedVolumeMasking;
elif [[ ! -e "${output_name}_SlicerTractography.vtk" ]]; then
    echo "DiffusionWeightedVolumeMasking was already run on this subject!" &&
	TractographyLabelMapSeeding;
else echo "Error: ${output_name} has no NRRD files in ${outputfolder}"
fi
