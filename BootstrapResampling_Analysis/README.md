This README.md file will describe the steps taken to complete the bootstrap resampling analysis of this project.

Both the structural covariance and functional connectivity models underwent the exact same steps just with different input files. Steps below:

Step 1: Generate all the iterations of the design matrices (script: GenerateDesignMatrix.R)

Step 2: Once all the design matrices are generated and saved to whatever computer/cloud you will be using, run PALM on each of the design matrices (script: Running_PALM_bootstrap_utility_script.sh and Running_PALM_bootstrap_driver_script.sh).
The utility script are all the commands you want to run and the driver script sets up a parallel command which allows the script to run multiple times simultaneously.

Step 3: Once you have all the CSV files for each of the parameter estimates for all your resampled models, use an iteration of this command (paste -d, `ls /scratch/a/arisvoin/nakuah/POND_rerun/Bootstrapping/T1w/1Months/T1_subsample_analysis/IB_Ramyg_output_*/IB_Ramyg_output_*_allsubs_merged_cohen_c12.csv` >> /scratch/a/arisvoin/nakuah/POND_rerun/Bootstrapping/T1w/1Months/T1_subsample_analysis/IB_Ramyg_cohen_bootstrap_subsample.csv
) to create a giant CSV file in which each of the 1000 individual CSVs are combined to make up the columns and the rows are each of the vertices.

Step 4: This giant CSV was inputted to R and used to make the figures featured in the paper. 

Diffusion Bootstrapping Steps:

Since all the diffusion models were analyzed in R, it is simpler to carry out the bootstrap analysis. This was carried out using the Bootstrap_Analysis_Diffusion.R script 
