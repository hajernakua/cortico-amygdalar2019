This README.md file explains the step-by-step process of all the pre-processing and analyses in the correct order for the DWI data

Step 1: pre-processing all raw DWI acquisitions using the fMRIprep pipeline (script: ___)

Step 2: perform quality control on all the DWI data using an a priori protocol (link: ____)

Step 3: Using dMRIprep and the processed DWI data, run the Slicer Tractography script to provide the files required for building a white matter atlas (script: SlicerTractography.sh)

Step 4: Use the VTK from the SlicerTractography.sh script to build the clusters needed to put the white matter tracts together (script: slicer_atlas_creation.sh)

Step 5: Create the dataset-specific atlas (link to PDF of instructions: ___)

Step 6: Register the created atlas to all subjects (script: slicer_apply_atlas_to_subjects.sh)

Step 7: Extract diffusion metrics of interest for each participant (script: slicer_extracting_metrics.sh)

Step 8: Conduct the linear regression analyses using R (script: diffusion_linear_models.R)
