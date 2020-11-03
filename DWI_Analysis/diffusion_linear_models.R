###This will perform the linear regression analysis for of the diffusion metrics for the cingulum and uncinate fasciculus
###these analyses were performed in the main and subsample cohorts 


#Step 1: getting data frames 
#Step 1.a: these dataframes are from the Slicer dMRI outputs. Each tract had its own DF. These were merged with the clinical data of interest 
#medication was included in this CSV but only added in the model if subsequent models were significant
left_UF <- read.csv("/path/to/csv")
right_UF <- read.csv("/path/to/csv")
left_cingulum <- read.csv("/path/to/csv")
right_cingulum <- read.csv("/path/to/csv")

#Step 1.b: adding the dataframe with the mean overall noise which will only be included in models if the baseline model was significant 
Overall_Noise <- read.csv("/path/to/csv")

#Step 2: merging noise and scanner DF with the diffusion metric DF
right_cingulum <- merge(right_cingulum, Overall_Noise, by = "ID")
left_cingulum <- merge(left_cingulum, Overall_Noise, by = "ID")
left_UF <- merge(left_UF, Overall_Noise, by = "ID")
right_UF <- merge(right_UF, Overall_Noise, by = "ID")

####NOTES:
#1. Models here are shown for the right uncinate fasiculus, but were identically employed for the other white matter tracts
#2. Only baseline models are shown here. If the baseline was significant, then the model was rerun removing outliers. If it was still significant, then it was re-run adding the other behavioural variable. If this model was significant, then it was re-run adding overall noise. If this model was significant, then it was re-run adding medication status.
#3. If the best fitting age term was quadratic, then the model featured 'age' and 'age-squared' (age^2)
#4. The same models and steps were run for the subsample analyses

######################################################################################################################################################
##########                                            RIGHT UNCINATE FASCICULUS
######################################################################################################################################################

##Analysis 1: right UF FA as a function of externalizing behaviour, controlling for age + gender
#Predictor variables: externalizing behaviour
#dependent variable: right UF FA
#covariate: age, sex

right_UF_FA_ExtBeh <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_FA~CB68EPTOT + age + GENDER, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  print(lm.beta(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}

##Analysis 1.B - adding interaction with diagnosis 

right_UF_FA_ExtBeh <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_FA~CB68EPTOT*clin_diagnosis + age + GENDER, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  print(lm.beta(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


##Analysis 2: right total UF MD as a function of externalizing behaviour, controlling for age + gender 
#Predictor variables: externalizing behaviour
#dependent variable: right total UF MD
#covariate: age, sex

right_UF_MD_ExtBeh <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_MD~CB68EPTOT + age + GENDER, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  print(lm.beta(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}

##there was a main effect found in this analysis but wanted to redo without outliers
right_UF_MD_ExtBeh_NoOutlier <- function(right_UF_NoOutlier){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_MD~CB68EPTOT + age + GENDER, data = right_UF_NoOutlier, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  print(lm.beta(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}
##there was no main effect following outlier removal 


### Analysis 2.B - adding interaction by diagnosis 
right_UF_MD_ExtBeh_diag <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_MD~CB68EPTOT*clin_diagnosis + age + GENDER, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  print(lm.beta(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


##Analysis 3: right total UF FA as a function of internalizing behaviour, controlling for age + gender 
#Predictor variables: internalizing behaviour
#dependent variable: right total UF FA
#covariate: age, sex

right_UF_FA_IntBeh <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_FA~CB68IPTOT + age + GENDER, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  print(lm.beta(LinModel))
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
  LinModel <- lm(Mean_FA~CB68IPTOT*clin_diagnosis + age + GENDER, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  print(lm.beta(LinModel))
  cat("printing outlier test \n")
  print(outlierTest(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}



##Analysis 4: right total UF MD as a function of internalizing behaviour, controlling for age, gender 
#Predictor variables: internalizing behaviour
#dependent variable: right total UF MD
#covariate: age, sex

right_UF_MD_IntBeh <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_MD~CB68IPTOT + age + GENDER, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  print(lm.beta(LinModel))
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
  LinModel <- lm(Mean_MD~CB68IPTOT*clin_diagnosis + age + GENDER, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  print(lm.beta(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


