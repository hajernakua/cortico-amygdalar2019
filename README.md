# cortico-amygdalar POND project
This repository contains the scripts used to pre-process and analyze the data for the manuscript which is currently under submission: Examination of cortico-amygdalar connectivity and externalizing or internalizing behaviors in a transdiagnostic sample of children with different neurodevelopmental disorders 

This repo contains 3 directories separated by the modalities used in this study. 

The T1_Structural_Analyses directory contains the scripts involved in pre-processing and analyzing the T1-weighted data from the POND dataset. The analysis included examining the relationship between externalizing and internalizing scores (from the Child Behavioral Checklist) and amygdala volume, cortical thickness and cortico-amygdalar structural correlations. Amygdala volume was parcellated using the DK Atlas and linear models were fit using R. Cortical thickness was analyzed at the vertex-level using FSL's Permutation of Linear Models (PALM). Cortico-amygdalar structural correlations (or covariance) was determined by an interaction term between behavioural score and amygdala volume. This term was regressed onto vertex wise cortical thickness. 

The rsfMRI_Analyes directory contains scripts involved in pre-processing and analysis of resting state functional data. This includes scripts to run fMRIprep, clean the data using ciftify, and prepare the analysis. Seed-based connectivity was used with left and right amygdalar ROI's as the seeds which were correlated to the mean time series in each cortical vertex. A linear model was fit with externalizing or internalizing behavioural scores as the independent variable. 

 The DWI_Analysis directory contains the scripts used to process the DWI data using the dMRI Slicer software package and the analysis carried out in R. The main analysis regressed behavioural scores onto diffusion metrics of the uncincate fasciculus and cingulum bundle. 
