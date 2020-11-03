#This script will be creating the design matrix for PALM TFCE use for the main cohort


#Step 1: Importing dataframe with all variables and sub IDs
Pre_Matrix <- read.csv("/path/to/csv")


#Step 2: creating variables for the interactions

#2.a: making diagnosis and gender a numeric variable so it can be used in the interaction
Pre_Matrix$clin_diagnosis[Pre_Matrix$clin_diagnosis == "ASD"] <- 1
Pre_Matrix$clin_diagnosis[Pre_Matrix$clin_diagnosis == "ADHD"] <- 2
Pre_Matrix$clin_diagnosis[Pre_Matrix$clin_diagnosis == "OCD"] <- 3
Pre_Matrix$clin_diagnosis[Pre_Matrix$clin_diagnosis == "CTRL"] <- 4
Pre_Matrix$clin_diagnosis <- as.numeric(as.factor(Pre_Matrix$clin_diagnosis))

Pre_Matrix$GENDER <- as.numeric(Pre_Matrix$GENDER)

#Step 2.b: Preparing the structural covariance variables. 
#This step creates an interaction term of externalizing or internalizing and left or right amygdala volume. 
#This term will be used as the independent variable for the structural covariance analyses 
Pre_Matrix$EB_Lamyg <- Pre_Matrix$CB68EPTOT*Pre_Matrix$Lamyg
Pre_Matrix$EB_Ramyg <- Pre_Matrix$CB68EPTOT*Pre_Matrix$Ramyg

Pre_Matrix$IB_Lamyg <- Pre_Matrix$CB68IPTOT*Pre_Matrix$Lamyg
Pre_Matrix$IB_Ramyg <- Pre_Matrix$CB68IPTOT*Pre_Matrix$Ramyg

#Step 2.c: preparing triple interaction between behaviour-amygdala-diagnosis
Pre_Matrix$EB_Lamyg_diag <- Pre_Matrix$CB68EPTOT*Pre_Matrix$Lamyg*Pre_Matrix$clin_diagnosis
Pre_Matrix$EB_Ramyg_diag <- Pre_Matrix$CB68EPTOT*Pre_Matrix$Ramyg*Pre_Matrix$clin_diagnosis
Pre_Matrix$IB_Lamyg_diag <- Pre_Matrix$CB68IPTOT*Pre_Matrix$Lamyg*Pre_Matrix$clin_diagnosis
Pre_Matrix$IB_Ramyg_diag <- Pre_Matrix$CB68IPTOT*Pre_Matrix$Ramyg*Pre_Matrix$clin_diagnosis


#Step 3: Demeaning variables which will be included in the models 
#FSL PALM was used for this analysis and it requires variables to be demeaned (mean of 0 and standard deviation of 1)

#Step 3.b: demeaning the cortico-amygdalar variables.
Pre_Matrix$EB_Lamyg <- scale(Pre_Matrix$EB_Lamyg, scale = FALSE)
Pre_Matrix$EB_Ramyg <- scale(Pre_Matrix$EB_Ramyg, scale = FALSE)
Pre_Matrix$IB_Lamyg <- scale(Pre_Matrix$IB_Lamyg, scale = FALSE)
Pre_Matrix$IB_Ramyg <- scale(Pre_Matrix$IB_Ramyg, scale = FALSE)

#Step 3.c: demeaning triple interaction variables
Pre_Matrix$EB_Lamyg_diag <- scale(Pre_Matrix$EB_Lamyg_diag, scale = FALSE)
Pre_Matrix$EB_Ramyg_diag <- scale(Pre_Matrix$EB_Ramyg_diag, scale = FALSE)
Pre_Matrix$IB_Lamyg_diag <- scale(Pre_Matrix$IB_Lamyg_diag, scale = FALSE)
Pre_Matrix$IB_Ramyg_diag <- scale(Pre_Matrix$IB_Ramyg_diag, scale = FALSE)

#Step 3.d: demeaning externalizing and internalizing behaviours
Pre_Matrix$CB68EPTOT <- scale(Pre_Matrix$CB68EPTOT, scale = FALSE)
Pre_Matrix$CB68IPTOT <- scale(Pre_Matrix$CB68IPTOT, scale = FALSE)

#Step 3.e: Demeaning age 
Pre_Matrix$age <- scale(Pre_Matrix$age, scale = FALSE)

#Step 3.f: Demeaning gender
Pre_Matrix$GENDER <- scale(Pre_Matrix$GENDER, scale = FALSE)

#Step 3.h:  demeaning clinical diagnosis
Pre_Matrix$clin_diagnosis <- scale(Pre_Matrix$clin_diagnosis, scale = FALSE)

#Step 3.i: Demeaning Intracranial Volume
#ICV values were divided by 1000 to reduce the order of magnitude difference between them and the rest of the variables.
#Without doing this, the matrix was rank deficient
Pre_Matrix$ICV <- Pre_Matrix$ICV/1000
Pre_Matrix$ICV <- scale(Pre_Matrix$ICV, scale = FALSE)

#Step 6: Adding new covariates: scanner and medication status 
Scanner <- read.csv("/path/to/csv")
names(Scanner)[names(Scanner) == "bids"] <- "ID"
Scanner$ID <- gsub('/ses-01', '', Scanner$ID)
Scanner$ID <- gsub('/ses-02', '', Scanner$ID)
Scanner$ID <- gsub('/ses-03', '', Scanner$ID)
Scanner$ID <- gsub('/ses-04', '', Scanner$ID)
Scanner$ID <- gsub('/ses-05', '', Scanner$ID)
Scanner$ID <- gsub('/ses-06', '', Scanner$ID)

Pre_Matrix <- merge(Pre_Matrix, Scanner, by = "ID")

#demeaning scanner
Pre_Matrix$scanner <- as.numeric(Pre_Matrix$scanner)
Pre_Matrix$scanner <- scale(Pre_Matrix$scanner, scale = FALSE)


write.csv(Pre_Matrix2, "/path/pre_design_matrix.csv")
#to use this matrix in PALM, there should be no variable names or subject IDs and the first column should be a series of 1's
