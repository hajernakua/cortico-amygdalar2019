#This script will be creating the design matrix for PALM TFCE use for the main cohort
#predictor variables: CBCL Externalizing Scores, CBCL Internalizing Scores, amygdala volume (via DK atlas)
#covariates: sex, age, ICV

#Step 1: Importing dataframe with all variables and sub ID
subs <- read.csv("/path/to/subjects")

fd <- read.csv("/path/to/fd_data")
fd$ID <- ifelse(grepl("^88",fd$ID), paste("sub-0", fd$ID, sep=""), paste("sub-", fd$ID, sep=""))

Session <- read.csv("/projects/hnakua/POND/Functional.Connectivity.Analysis/docs/sessioninfo-rsfmri.csv")
Session$ID <- sub("MR160-*", "", Session[,1]) 
Session$ID <- sub("-", "", Session[,1]) 
Session$ID <- paste0('sub-', Session$ID)
Session <- Session[!duplicated(Session$ID), ]

Pre_Matrix2 <- merge(Pre_Matrix2, fd, by = "ID")
Pre_Matrix2 <- merge(Pre_Matrix2, Session, by = "ID")


#Step 2.a: creating variables for the interactions
Pre_Matrix2$clin_diagnosis[Pre_Matrix2$clin_diagnosis == "ASD"] <- 1
Pre_Matrix2$clin_diagnosis[Pre_Matrix2$clin_diagnosis == "ADHD"] <- 2
Pre_Matrix2$clin_diagnosis[Pre_Matrix2$clin_diagnosis == "OCD"] <- 3
Pre_Matrix2$clin_diagnosis[Pre_Matrix2$clin_diagnosis == "CTRL"] <- 4

Pre_Matrix2$EB_Age <- Pre_Matrix2$CB68EPTOT*Pre_Matrix2$age

Pre_Matrix2$clin_diagnosis <- as.numeric(as.character(Pre_Matrix2$clin_diagnosis))
Pre_Matrix2$EB_Diag <- Pre_Matrix2$CB68EPTOT*Pre_Matrix2$clin_diagnosis

Pre_Matrix2$GENDER <- as.numeric(Pre_Matrix2$GENDER)
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


#Step 3: Demean CBCL Scores

Pre_Matrix2$CB68EPTOT <- scale(Pre_Matrix2$CB68EPTOT, scale = FALSE)

Pre_Matrix2$CB68IPTOT <- scale(Pre_Matrix2$CB68IPTOT, scale = FALSE)


#Step 4: Preparing covariates
#4.A: Demeaning age 

Pre_Matrix2$age <- scale(Pre_Matrix2$age, scale = FALSE)

#4.C: Demeaning gender

Pre_Matrix2$GENDER <- as.numeric(Pre_Matrix2$GENDER)
Pre_Matrix2$GENDER <- scale(Pre_Matrix2$GENDER, scale = FALSE)

#4.D: Demeaning Intracranial Volume
Pre_Matrix2$ICV <- Pre_Matrix2$ICV/1000
Pre_Matrix2$ICV <- scale(Pre_Matrix2$ICV, scale = FALSE)


#Step 5.a: Assigning dummy variables to their rs-fMRI condition (some children viewed a fixation cross and others watched a short film)
Pre_Matrix2$condition[Pre_Matrix2$RS.Cross == "1"] <- 2
Pre_Matrix2$condition[Pre_Matrix2$RS.Cross == "0"] <- 4
Pre_Matrix2$condition[Pre_Matrix2$RS..Inscapes == "1"] <- 3

#5.b: Demeaning the dummy variable for condition
Pre_Matrix2$condition <- scale(Pre_Matrix2$condition, scale = FALSE)

#6: Demeaning mean framewise displacement
Pre_Matrix2$fd_mean <- scale(Pre_Matrix2$fd_mean, scale = FALSE)

#Step 7.a: adding scanner and medication as covariates
Scanner <- read.csv("path")
names(Scanner)[names(Scanner) == "bids"] <- "ID"
Scanner$ID <- gsub('/ses-01', '', Scanner$ID)
Scanner$ID <- gsub('/ses-02', '', Scanner$ID)
Scanner$ID <- gsub('/ses-03', '', Scanner$ID)
Scanner$ID <- gsub('/ses-04', '', Scanner$ID)
Scanner$ID <- gsub('/ses-05', '', Scanner$ID)
Scanner$ID <- gsub('/ses-06', '', Scanner$ID)
Scanner <- Scanner[!duplicated(Scanner$ID), ]

Pre_Matrix2 <- merge(Pre_Matrix2, Scanner, by = "ID")

#Step 7.b: demeaning scanner
Pre_Matrix2$scanner <- as.numeric(Pre_Matrix2$scanner)
Pre_Matrix2$scanner <- scale(Pre_Matrix2$scanner, scale = FALSE)

#Step 8: demeaning medication
Pre_Matrix2$ST_MED_6M <- as.numeric(Pre_Matrix2$ST_MED_6M)
Pre_Matrix2$ST_MED_6M <- scale(Pre_Matrix2$ST_MED_6M, scale = FALSE)


write.csv(Pre_Matrix2, "/path/pre_designmatrix.csv")

