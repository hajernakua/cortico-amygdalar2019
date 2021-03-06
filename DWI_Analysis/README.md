This README.md file explains the step-by-step process of all the pre-processing and analyses in the correct order for the DWI data

Step 1: concatenate the three DWI acquisitions (script: concatenate_DWI_aquisitions.sh)

Step 2: process the DWI data; bind the bval and bvec files (script: Binding_bvals_and_bvecs.R), create synthetic fieldmap (script: making_fieldmaps.sh), and pre-process using DTIFIT and MRTrix (script: DWI_pre-processing.sh)

Step 3: perform quality control on all the DWI data using an a priori protocol (Quantitative QC Script: quantitative_DWI_QC.R; [Quantitative QC manual](https://htmlpreview.github.io/?https://github.com/hajernakua/cortico-amygdalar2019/blob/master/DWI_Analysis/DWI-Quant-QC-Manual.html); [Visual (Qualitative) QC manual](https://htmlpreview.github.io/?https://github.com/nat-tigr/DWI_QC/blob/master/DWI_QC_protocol.html))

Step 4: Using dMRIprep and the processed DWI data, run the Slicer Tractography script to provide the files required for building a white matter atlas (script: SlicerTractography.sh)

Step 5: Use the VTK from the SlicerTractography.sh script to build the clusters needed to put the white matter tracts together (script: slicer_atlas_creation.sh)

Step 6: Create the dataset-specific atlas using the Slicer dMRI software (https://github.com/SlicerDMRI)

Step 7: Register the created atlas to all subjects (script: slicer_apply_atlas_to_subjects.sh)

Step 8: Extract diffusion metrics of interest for each participant (script: slicer_extracting_metrics.sh)

Step 9: Determine the best fitting age model (script: Age_DiffusionMetrics.R)

Step 10: Conduct the linear regression analyses using R (script: diffusion_linear_models.R)
