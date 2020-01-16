#####################################################################
##### AMYGDALA VOLUME ANALYSIS - MAIN COHORT
####################################################################


#Step 0: load necessary libraries
library(dplyr)
library(plyr)
library(tidyverse)


#Step 1: Setting up dataframe
MainData <- read.csv("/path/to/csv") ##csv of subjects 

#1.a: adding clinical data and brain data
ClinicalData <- read.csv("path/to/csv")
MainData <- merge(ClinicalData[, c('clin_diagnosis', 'ID')], MainData, by = "ID")
AddingICV <- read.csv("/path/to/csv")
MainData <- merge(MainData, AddingICV[, c('ICV', 'ID')], by = "ID")


#1.b: adding scanner to the DF so I can have it as a covariate
Scanner <- read.csv("/path/to/csv")
names(Scanner)[names(Scanner) == "bids"] <- "ID"
Scanner$ID <- gsub('/ses-01', '', Scanner$ID)
Scanner$ID <- gsub('/ses-02', '', Scanner$ID)
Scanner$ID <- gsub('/ses-03', '', Scanner$ID)
Scanner$ID <- gsub('/ses-04', '', Scanner$ID)
Scanner$ID <- gsub('/ses-05', '', Scanner$ID)
Scanner$ID <- gsub('/ses-06', '', Scanner$ID)
Scanner <- Scanner[!duplicated(Scanner$ID), ]

MainData <- merge(MainData, Scanner, by = "ID")


#1.c: adding medication to the DF so I can have it as a covariate
MainData <- merge(MainData, POND_ClinicalData[, c('ST_MED_6M', 'ID')], by = "ID")



####################################################################################
#####                       REGRESSIION ANALYSIS
####################################################################################


#### EXTERNALIZING BEHAVIOUR - RIGHT AMYGDALA VOLUME

##Analysis 1: Right amygdala volume as a function of externalizing behaviour, controlling for age, gender, ICV, scanner, medication 
#Predictor variables: externalizing behaviour
#dependent variable: right amygdala volume
#covariate: age, gender, ICV, scanner, medication + Int Beh

Reg.RAmgV.EB <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Ramyg~CB68EPTOT + age + GENDER + ICV + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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

#adding internalizing behaviour as covariate 
Reg.RAmgV.EB2 <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Ramyg~CB68EPTOT + age + GENDER + ICV + CB68IPTOT + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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

#1.B - adding interaction by diagnosis
Reg.RAmgV.EB_diag <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Ramyg~CB68EPTOT*clin_diagnosis + age + GENDER + ICV + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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

#1.C - adding interaction by age 
Reg.RAmgV.EB_age <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Ramyg~CB68EPTOT*age + GENDER + ICV + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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

#1.D - adding interaction by gender
Reg.RAmgV.EB_GENDER <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Ramyg~CB68EPTOT*GENDER + age + ICV + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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


##Analysis 2: Left amygdala volume as a function of externalizing behaviour, controlling for age, gender, ICV, scanner, medication 
#Predictor variables: externalizing behaviour
#dependent variable: left amygdala volume
#covariate: age, gender, ICV, scanner, medication + Int Beh

Reg.LAmgV.EB <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Lamyg~CB68EPTOT + age + GENDER + ICV + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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

#adding internalizing behaviour as covariate 
Reg.LAmgV.EB2 <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Lamyg~CB68EPTOT + age + GENDER + ICV + CB68IPTOT + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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

#2.B - adding interaction by diagnosis
Reg.LAmgV.EB_diag <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Lamyg~CB68EPTOT*clin_diagnosis + age + GENDER + ICV + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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

#3.C - adding interaction by age 
Reg.LAmgV.EB_age <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Lamyg~CB68EPTOT*age + GENDER + ICV + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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

#2.D - adding interaction by gender
Reg.LAmgV.EB_GENDER <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Lamyg~CB68EPTOT*GENDER + age + ICV + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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



##Analysis 3: Right amygdala volume as a function of internalizing behaviour, controlling for age, gender, ICV, scanner, medication 
#Predictor variables: internalizing behaviour
#dependent variable: right amygdala volume
#covariate: age, gender, ICV, scanner, medication + Ext Beh

Reg.RAmgV.IB <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Ramyg~CB68IPTOT + age + GENDER + ICV + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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

#adding externalizing behaviour as covariate 
Reg.RAmgV.IB2 <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Ramyg~CB68IPTOT + age + GENDER + ICV + CB68EPTOT + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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


#3.B - adding interaction by diagnosis
Reg.RAmgV.IB_diag <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Ramyg~CB68IPTOT*clin_diagnosis + age + GENDER + ICV + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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


#3.B - adding interaction by age
Reg.RAmgV.IB_age <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Ramyg~CB68IPTOT*age + GENDER + ICV + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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


#3.B - adding interaction by gender
Reg.RAmgV.IB_GENDER <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Ramyg~CB68IPTOT*GENDER + age + ICV + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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




##Analysis 4: Left amygdala volume as a function of internalizing behaviour, controlling for age, gender, ICV, scanner, medication 
#Predictor variables: internalizing behaviour
#dependent variable: left amygdala volume
#covariate: age, gender, ICV, scanner, medication + Ext Beh

Reg.LAmgV.IB <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Lamyg~CB68IPTOT + age + GENDER + ICV + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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

#adding externalizing behaviour as covariate 
Reg.LAmgV.IB2 <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Lamyg~CB68IPTOT + age + GENDER + ICV + CB68EPTOT + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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

#4.B - adding interaction by diagnosis
Reg.LAmgV.IB_diag <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Lamyg~CB68IPTOT*clin_diagnosis + age + GENDER + ICV + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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

#4.C - adding interaction by age
Reg.LAmgV.IB_age <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Lamyg~CB68IPTOT*age + GENDER + ICV + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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

#4.D - adding interaction by gender
Reg.LAmgV.IB_GENDER <- function(MainData){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Lamyg~CB68IPTOT*GENDER + age + ICV + scanner + ST_MED_6M, data = MainData, na.action = na.omit)
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
