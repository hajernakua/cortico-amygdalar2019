###This will perform the linear regression analysis for of the diffusion metrics for the cingulum and uncinate fasciculus


#Step 0: sourcing necessary scripts
source(gettingDFs.R)


#Step 1: putting together the overall noise DF which uses an algorithm to calculate the overall noise of each participant 
Overall_Noise <- read.csv("/path/to/csv")

#Step 2: getting scanner and medication covariates
#2.a: scanner
Scanner <- read.csv("/home/hnakua/Downloads/2019-11-28_inventory-for-grace.csv")
names(Scanner)[names(Scanner) == "bids"] <- "ID"
Scanner$ID <- gsub('/ses-01', '', Scanner$ID)
Scanner$ID <- gsub('/ses-02', '', Scanner$ID)
Scanner$ID <- gsub('/ses-03', '', Scanner$ID)
Scanner$ID <- gsub('/ses-04', '', Scanner$ID)
Scanner$ID <- gsub('/ses-05', '', Scanner$ID)
Scanner$ID <- gsub('/ses-06', '', Scanner$ID)
Scanner <- Scanner[!duplicated(Scanner$ID), ]

#2.b: medication
POND_ClinicalData <- read.csv("/path/to/csv")

#Step 3: merging noise and scanner DF with the diffusion metric DF
right_UF <- merge(right_UF, Overall_Noise, by = "ID")
right_UF<- merge(right_UF, Scanner, by = "ID")
right_UF <- merge(right_UF, POND_ClinicalData[, c('ST_MED_6M', 'ID')], by = "ID")

left_UF <- merge(left_UF, Overall_Noise, by = "ID")
left_UF<- merge(left_UF, Scanner, by = "ID")
left_UF <- merge(left_UF, POND_ClinicalData[, c('ST_MED_6M', 'ID')], by = "ID")

left_Complete_UncFas <- merge(left_Complete_UncFas, Overall_Noise, by = "ID")
left_Complete_UncFas <- merge(left_Complete_UncFas, Scanner, by = "ID")
left_Complete_UncFas <- merge(left_Complete_UncFas, POND_ClinicalData[, c('ST_MED_6M', 'ID')], by = "ID")

right_Complete_UF <- merge(right_Complete_UF, Overall_Noise, by = "ID")
right_Complete_UncFas <- merge(right_Complete_UncFas, Scanner, by = "ID")
right_Complete_UncFas <- merge(right_Complete_UncFas, POND_ClinicalData[, c('ST_MED_6M', 'ID')], by = "ID")


#############################################################################
##########                              RIGHT UNCINATE FASCICULUS
#############################################################################

##Analysis 1: right UF FA as a function of externalizing behaviour, controlling for age, gender, and overall noise 
#Predictor variables: externalizing behaviour
#dependent variable: right UF FA
#covariate: age, sex, overall noise

right_UF_FA_ExtBeh <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_FA~CB68EPTOT + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}

#adding internalizing behaviour as a covariate
right_UF_FA_ExtBeh2 <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_FA~CB68EPTOT + age + GENDER + CB68IPTOT + Overall_DWI_Noise + ST_MED_6M, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


##Analysis 1.B - adding interaction with diagnosis 

right_UF_FA_ExtBeh <- function(right_UF){
  library(car)
  library(olsrr)
  right_UF$clin_diagnosis[right_UF$clin_diagnosis == "GAD"] <- NA
  cat("Printing linear model \n")
  LinModel <- lm(Mean_FA~CB68EPTOT + CB68EPTOT*clin_diagnosis + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


##Analysis 2: right total UF MD as a function of externalizing behaviour, controlling for age, gender, and overall noise 
#Predictor variables: externalizing behaviour
#dependent variable: right total UF MD
#covariate: age, sex, overall noise

right_UF_MD_ExtBeh <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_MD~CB68EPTOT + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


#adding internalizing behaviour as a covariate
right_UF_MD_ExtBeh2 <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_MD~CB68EPTOT + age + GENDER + Overall_DWI_Noise + CB68IPTOT + ST_MED_6M, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


### Analysis 2.B - adding interaction by diagnosis 
right_UF_MD_ExtBeh_diag <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  right_UF$clin_diagnosis[right_UF$clin_diagnosis == "GAD"] <- NA
  LinModel <- lm(Mean_MD~CB68EPTOT + CB68EPTOT*clin_diagnosis + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


##Analysis 3: right total UF FA as a function of internalizing behaviour, controlling for age, gender, and overall noise 
#Predictor variables: internalizing behaviour
#dependent variable: right total UF FA
#covariate: age, sex, overall noise

right_UF_FA_IntBeh <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_FA~CB68IPTOT + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


#adding externalizing behaviour as a covariate
right_UF_FA_IntBeh2 <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_FA~CB68IPTOT + age + GENDER + Overall_DWI_Noise + CB68EPTOT + ST_MED_6M, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}

### Analysis 3.B - adding interaction by diagnosis 
right_UF_FA_IntBeh_diag <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  right_UF$clin_diagnosis[right_UF$clin_diagnosis == "GAD"] <- NA
  LinModel <- lm(Mean_FA~CB68IPTOT + CB68IPTOT*clin_diagnosis + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}



##Analysis 4: right total UF MD as a function of internalizing behaviour, controlling for age, gender, and overall noise 
#Predictor variables: internalizing behaviour
#dependent variable: right total UF MD
#covariate: age, sex, overall noise

right_UF_MD_IntBeh <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_MD~CB68IPTOT + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


#adding externalizing behaviour as a covariate
right_UF_MD_IntBeh2 <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_MD~CB68IPTOT + age + GENDER + Overall_DWI_Noise + CB68EPTOT + ST_MED_6M, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}

### Analysis 4.B - adding interaction by diagnosis 
right_UF_MD_IntBeh_diag <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  right_UF$clin_diagnosis[right_UF$clin_diagnosis == "GAD"] <- NA
  LinModel <- lm(Mean_MD~CB68IPTOT + CB68IPTOT*clin_diagnosis + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


#######################################################################################
#####################                  LEFT TOTAL UNCINATE FASCICULUS
#######################################################################################


##Analysis 1: left UF FA as a function of externalizing behaviour, controlling for age, gender, and overall noise 
#Predictor variables: externalizing behaviour
#dependent variable: left UF FA
#covariate: age, sex, overall noise

left_UF_FA_ExtBeh <- function(left_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_FA~CB68EPTOT + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


#adding internalizing behaviour as a covariate
left_UF_FA_ExtBeh2 <- function(left_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_FA~CB68EPTOT + age + GENDER + CB68IPTOT + Overall_DWI_Noise + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


##Analysis 1.B - adding interaction with diagnosis 
left_UF_FA_ExtBeh_diag <- function(left_UF){
  library(car)
  library(olsrr)
  left_UF$clin_diagnosis[left_UF$clin_diagnosis == "GAD"] <- NA
  cat("Printing linear model \n")
  LinModel <- lm(Mean_FA~CB68EPTOT*clin_diagnosis + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}

##Analysis 1.C - adding interaction with age 
left_UF_FA_ExtBeh_age <- function(left_UF){
  library(car)
  library(olsrr)
  left_UF$clin_diagnosis[left_UF$clin_diagnosis == "GAD"] <- NA
  cat("Printing linear model \n")
  LinModel <- lm(Mean_FA~CB68EPTOT*age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}

##Analysis 1.C - adding interaction with gender
left_UF_FA_ExtBeh_gender <- function(left_UF){
  library(car)
  library(olsrr)
  left_UF$clin_diagnosis[left_UF$clin_diagnosis == "GAD"] <- NA
  cat("Printing linear model \n")
  LinModel <- lm(Mean_FA~CB68EPTOT*GENDER + age + Overall_DWI_Noise + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


##Analysis 2: left total UF MD as a function of externalizing behaviour, controlling for age, gender, and overall noise 
#Predictor variables: externalizing behaviour
#dependent variable: left total UF MD
#covariate: age, sex, overall noise

left_UF_MD_ExtBeh <- function(left_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_MD~CB68EPTOT + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


#adding internalizing behaviour as a covariate
left_UF_MD_ExtBeh2 <- function(left_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_MD~CB68EPTOT + age + GENDER + Overall_DWI_Noise + CB68IPTOT + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


### Analysis 2.B - adding interaction by diagnosis 
left_UF_MD_ExtBeh_diag <- function(left_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  left_UF$clin_diagnosis[left_UF$clin_diagnosis == "GAD"] <- NA
  LinModel <- lm(Mean_MD~CB68EPTOT*clin_diagnosis + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


### Analysis 2.c - adding interaction by age
left_UF_MD_ExtBeh_age <- function(left_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  left_UF$clin_diagnosis[left_UF$clin_diagnosis == "GAD"] <- NA
  LinModel <- lm(Mean_MD~CB68EPTOT*age + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


### Analysis 2.D - adding interaction by gender
left_UF_MD_ExtBeh_gender <- function(left_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  left_UF$clin_diagnosis[left_UF$clin_diagnosis == "GAD"] <- NA
  LinModel <- lm(Mean_MD~CB68EPTOT*GENDER + age + Overall_DWI_Noise + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


##Analysis 3: left total UF FA as a function of internalizing behaviour, controlling for age, gender, and overall noise 
#Predictor variables: internalizing behaviour
#dependent variable: left total UF FA
#covariate: age, sex, overall noise

left_UF_FA_IntBeh <- function(left_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_FA~CB68IPTOT + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


#adding externalizing behaviour as a covariate
left_UF_FA_IntBeh2 <- function(left_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_FA~CB68IPTOT + age + GENDER + Overall_DWI_Noise + CB68EPTOT + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}

### Analysis 3.B - adding interaction by diagnosis 
left_UF_FA_IntBeh_diag <- function(left_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  left_UF$clin_diagnosis[left_UF$clin_diagnosis == "GAD"] <- NA
  LinModel <- lm(Mean_FA~CB68IPTOT*clin_diagnosis + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


### Analysis 3.C - adding interaction by age 
left_UF_FA_IntBeh <- function(left_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  left_UF$clin_diagnosis[left_UF$clin_diagnosis == "GAD"] <- NA
  LinModel <- lm(Mean_FA~CB68IPTOT*age + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


### Analysis 3.D - adding interaction by gender 
left_UF_FA_IntBeh_gender <- function(left_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  left_UF$clin_diagnosis[left_UF$clin_diagnosis == "GAD"] <- NA
  LinModel <- lm(Mean_FA~CB68IPTOT*GENDER + age + Overall_DWI_Noise + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}



##Analysis 4: left total UF MD as a function of internalizing behaviour, controlling for age, gender, and overall noise 
#Predictor variables: internalizing behaviour
#dependent variable: left total UF MD
#covariate: age, sex, overall noise

left_UF_MD_IntBeh <- function(left_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_MD~CB68IPTOT + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


#adding externalizing behaviour as a covariate
left_UF_MD_IntBeh2 <- function(left_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_MD~CB68IPTOT + age + GENDER + Overall_DWI_Noise + CB68EPTOT + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}

### Analysis 4.B - adding interaction by diagnosis 
left_UF_MD_IntBeh <- function(left_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  left_UF$clin_diagnosis[left_UF$clin_diagnosis == "GAD"] <- NA
  LinModel <- lm(Mean_MD~CB68IPTOT*clin_diagnosis + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


### Analysis 4.C - adding interaction by age 
left_UF_MD_IntBeh_age <- function(left_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  left_UF$clin_diagnosis[left_UF$clin_diagnosis == "GAD"] <- NA
  LinModel <- lm(Mean_MD~CB68IPTOT*age + age + GENDER + Overall_DWI_Noise + ST_MED_6M, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


### Analysis 4.C - adding interaction by gender
left_UF_MD_IntBeh_gender <- function(left_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  left_UF$clin_diagnosis[left_UF$clin_diagnosis == "GAD"] <- NA
  LinModel <- lm(Mean_MD~CB68IPTOT*GENDER + age + Overall_DWI_Noise, data = left_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  #print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}

