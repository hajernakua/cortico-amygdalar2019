#This script will be creating the design matrix for PALM TFCE use for the main cohort

#predictor variables: CBCL Externalizing Scores, CBCL Internalizing Scores, amygdala volume (via DK atlas)
#covariates: sex, age, ICV, scanner, medication

#Step 1: Importing dataframe with all variables and sub ID
Pre_Matrix2 <- read.csv("/path/to/csv")

#Step 2.a: : reating variables for the interactions
Pre_Matrix2$clin_diagnosis[Pre_Matrix2$clin_diagnosis == "ASD"] <- 1
Pre_Matrix2$clin_diagnosis[Pre_Matrix2$clin_diagnosis == "ADHD"] <- 2
Pre_Matrix2$clin_diagnosis[Pre_Matrix2$clin_diagnosis == "OCD"] <- 3
Pre_Matrix2$clin_diagnosis[Pre_Matrix2$clin_diagnosis == "CTRL"] <- 4

Pre_Matrix2$EB_Age <- Pre_Matrix2$CB68EPTOT*Pre_Matrix2$age

Pre_Matrix2$clin_diagnosis <- as.numeric(as.character(Pre_Matrix2$clin_diagnosis))
Pre_Matrix2$EB_Diag <- Pre_Matrix2$CB68EPTOT*Pre_Matrix2$clin_diagnosis

Pre_Matrix2$EB_Gender <- Pre_Matrix2$CB68EPTOT*Pre_Matrix2$GENDER


Pre_Matrix2$IB_Age <- Pre_Matrix2$CB68IPTOT*Pre_Matrix2$age

Pre_Matrix2$IB_Diag <- Pre_Matrix2$CB68IPTOT*Pre_Matrix2$clin_diagnosis

Pre_Matrix2$IB_Gender <- Pre_Matrix2$CB68IPTOT*Pre_Matrix2$GENDER

#Step 2.b: demeaning the new variables

Pre_Matrix2$EB_Age <- scale(Pre_Matrix2$EB_Age, scale = FALSE)
Pre_Matrix2$EB_Diag <- scale(Pre_Matrix2$EB_Diag, scale = FALSE)
Pre_Matrix2$EB_Gender <- scale(Pre_Matrix2$EB_Gender, scale = FALSE)

Pre_Matrix2$IB_Age <- scale(Pre_Matrix2$IB_Age, scale = FALSE)
Pre_Matrix2$IB_Diag <- scale(Pre_Matrix2$IB_Diag, scale = FALSE)
Pre_Matrix2$IB_Gender <- scale(Pre_Matrix2$IB_Gender, scale = FALSE)

#Step 3.a: Preparing the structural covariance variables

Pre_Matrix2$EB_Lamyg <- Pre_Matrix2$CB68EPTOT*Pre_Matrix2$Lamyg
Pre_Matrix2$EB_Ramyg <- Pre_Matrix2$CB68EPTOT*Pre_Matrix2$Ramyg

Pre_Matrix2$TotalAmyg <- Pre_Matrix2$Lamyg + Pre_Matrix2$Ramyg
Pre_Matrix2$EB_Tamyg <- Pre_Matrix2$CB68EPTOT*Pre_Matrix2$TotalAmyg


Pre_Matrix2$IB_Lamyg <- Pre_Matrix2$CB68IPTOT*Pre_Matrix2$Lamyg
Pre_Matrix2$IB_Ramyg <- Pre_Matrix2$CB68IPTOT*Pre_Matrix2$Ramyg

Pre_Matrix2$TotalAmyg <- Pre_Matrix2$Lamyg + Pre_Matrix2$Ramyg
Pre_Matrix2$IB_Tamyg <- Pre_Matrix2$CB68IPTOT*Pre_Matrix2$TotalAmyg

#Step 3.b: demeaning the cortico-amygdalar variables
Pre_Matrix2$EB_Lamyg <- scale(Pre_Matrix2$EB_Lamyg, scale = FALSE)
Pre_Matrix2$EB_Ramyg <- scale(Pre_Matrix2$EB_Ramyg, scale = FALSE)
Pre_Matrix2$EB_Tamyg <- scale(Pre_Matrix2$EB_Tamyg, scale = FALSE)
Pre_Matrix2$IB_Lamyg <- scale(Pre_Matrix2$IB_Lamyg, scale = FALSE)
Pre_Matrix2$IB_Ramyg <- scale(Pre_Matrix2$IB_Ramyg, scale = FALSE)
Pre_Matrix2$IB_Tamyg <- scale(Pre_Matrix2$IB_Tamyg, scale = FALSE)


#Step 4: Demean CBCL Scores

Pre_Matrix2$CB68EPTOT <- scale(Pre_Matrix2$CB68EPTOT, scale = FALSE)

Pre_Matrix2$CB68IPTOT <- scale(Pre_Matrix2$CB68IPTOT, scale = FALSE)

#Step 5: Preparing covariates
#5.A: Demeaning age 

Pre_Matrix2$age <- scale(Pre_Matrix2$age, scale = FALSE)

#5.C: Demeaning gender

Pre_Matrix2$GENDER <- as.numeric(Pre_Matrix2$GENDER)
Pre_Matrix2$GENDER <- scale(Pre_Matrix2$GENDER, scale = FALSE)

#5.D: Demeaning Intracranial Volume
Pre_Matrix2$ICV <- Pre_Matrix2$ICV/1000
Pre_Matrix2$ICV <- scale(Pre_Matrix2$ICV, scale = FALSE)


#Step 6: Adding new covariates: scanner and medication status 

Scanner <- read.csv("/path/to/csv")
names(Scanner)[names(Scanner) == "bids"] <- "ID"
Scanner$ID <- gsub('/ses-01', '', Scanner$ID)
Scanner$ID <- gsub('/ses-02', '', Scanner$ID)
Scanner$ID <- gsub('/ses-03', '', Scanner$ID)
Scanner$ID <- gsub('/ses-04', '', Scanner$ID)
Scanner$ID <- gsub('/ses-05', '', Scanner$ID)
Scanner$ID <- gsub('/ses-06', '', Scanner$ID)
Scanner <- Scanner[!duplicated(Scanner$ID), ]

Pre_Matrix2 <- merge(Pre_Matrix2, Scanner, by = "ID")

#demeaning scanner
Pre_Matrix2$scanner <- as.numeric(Pre_Matrix2$scanner)
Pre_Matrix2$scanner <- scale(Pre_Matrix2$scanner, scale = FALSE)

#demeaning medication
Pre_Matrix2$ST_MED_6M <- as.numeric(Pre_Matrix2$ST_MED_6M)
Pre_Matrix2$ST_MED_6M <- scale(Pre_Matrix2$ST_MED_6M, scale = FALSE)


write.csv(Pre_Matrix2, "/path/pre_design_matrix.csv")
