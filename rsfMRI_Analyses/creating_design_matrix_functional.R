#This script will be creating the design matrix for PALM TFCE use for the main cohort
#predictor variables: CBCL Externalizing Scores, CBCL Internalizing Scores, amygdala volume (via DK atlas)
#covariates: sex, age, ICV

#Step 1: Importing dataframe with sub ID + variables of interest
subs <- read.csv("/path/to/csv")

#1.a: adding mean framewise displacement data
fd <- read.csv("/path/to/csv")

#1.b: adding condition (whether they viewed a movie or fixation cross) 
viewing_condition <- read.csv("/path/to/csv")

#1.c: adding scanner information (Trio or Prisma)
Scanner_Info <- read.csv("/path/to/csv")

Pre_Matrix_fMRI <- merge(Pre_Matrix_fMRI, fd, by = "ID")
Pre_Matrix_fMRI <- merge(Pre_Matrix_fMRI, viewing_condition, by = "ID")
Pre_Matrix_fMRI <- merge(Pre_Matrix_fMRI, Scanner_Info, by = "ID")


#Step 2: creating variables for the interactions

#2.a: making diagnosis and gender a numeric variable
Pre_Matrix_fMRI$clin_diagnosis[Pre_Matrix_fMRI$clin_diagnosis == "ASD"] <- 1
Pre_Matrix_fMRI$clin_diagnosis[Pre_Matrix_fMRI$clin_diagnosis == "ADHD"] <- 2
Pre_Matrix_fMRI$clin_diagnosis[Pre_Matrix_fMRI$clin_diagnosis == "OCD"] <- 3
Pre_Matrix_fMRI$clin_diagnosis[Pre_Matrix_fMRI$clin_diagnosis == "CTRL"] <- 4
Pre_Matrix_fMRI$clin_diagnosis <- as.numeric(as.factor(Pre_Matrix_fMRI$clin_diagnosis))
Pre_Matrix_fMRI$GENDER <- as.numeric(Pre_Matrix_fMRI$GENDER)

#2.b: interactions of behaviour and diagnosis 

Pre_Matrix_fMRI$EB_Diag <- Pre_Matrix_fMRI$CB68EPTOT*Pre_Matrix_fMRI$clin_diagnosis
Pre_Matrix_fMRI$IB_Diag <- Pre_Matrix_fMRI$CB68IPTOT*Pre_Matrix_fMRI$clin_diagnosis

#Step 3: Demeaning the variables
#The FSL PALM Tool requires variables to be demeaned 

#Step 3.a: demeaning behaviour-diagnosis interaction variable
Pre_Matrix_fMRI$EB_Diag <- scale(Pre_Matrix_fMRI$EB_Diag, scale = FALSE)
Pre_Matrix_fMRI$IB_Diag <- scale(Pre_Matrix_fMRI$IB_Diag, scale = FALSE)


#Step 3.b: Demean raw (non-normalized) CBCL Scores

Pre_Matrix_fMRI$CB68EPTOT <- scale(Pre_Matrix_fMRI$CB68EPTOT, scale = FALSE)
Pre_Matrix_fMRI$CB68IPTOT <- scale(Pre_Matrix_fMRI$CB68IPTOT, scale = FALSE)

#Step 3.c: demeaning diagnosis 
Pre_Matrix_fMRI$clin_diagnosis <- scale(Pre_Matrix_fMRI$clin_diagnosis, scale = FALSE)

#Step 3.d: demeaning age
Pre_Matrix_fMRI$age <- scale(Pre_Matrix_fMRI$age, scale = FALSE)

#Step 3.e: Demeaning gender
Pre_Matrix_fMRI$GENDER <- scale(Pre_Matrix_fMRI$GENDER, scale = FALSE)

#Step 3.f: making the viewing condition numeric (1 or 2) and then demeaning 
Pre_Matrix_fMRI$viewing_condition <- as.numeric(Pre_Matrix_fMRI$viewing_condition)
Pre_Matrix_fMRI$viewing_condition <- scale(Pre_Matrix_fMRI$viewing_condition, scale = FALSE)

#Step 3.g: Demeaning mean framewise displacement
Pre_Matrix_fMRI$fd_mean <- scale(Pre_Matrix_fMRI$fd_mean, scale = FALSE)

#Step 3.h: demeaning scanner
Pre_Matrix_fMRI$scanner <- as.numeric(Pre_Matrix_fMRI$scanner)
Pre_Matrix_fMRI$scanner <- scale(Pre_Matrix_fMRI$scanner, scale = FALSE)


write.csv(Pre_Matrix2, "/path/pre_designmatrix.csv")
#Once this matrix has been saved to the proper directory, the column names + column of subject IDs need to be removed. The first column should be a column of 1's and then inputted as the design matrix for the PALM analysis

