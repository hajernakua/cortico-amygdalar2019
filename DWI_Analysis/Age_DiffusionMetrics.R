##This script will assess the best fitting age term (linear or quadratic) for each of the diffusion metrics

##Notes:
#1. Models of the right uncinate fasiculus are included here but they were identical to the other diffusion metrics
#2. The better fitting age variable will be used in the linear models (age or age + age-squared)

################################################################################################################################################################
##########                                  RIGHT UNCINATE FASCICULUS
################################################################################################################################################################

right_UF_FA_age <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_FA~age, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  print(lm.beta(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


right__UF_FA_age2 <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  age2 <- right_UF$age^2
  LinModel <- lm(Mean_FA~age + age2, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  print(lm.beta(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}



right_UF_MD_age <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  LinModel <- lm(Mean_MD~age, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  print(lm.beta(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}


right_UF_MD_age2 <- function(right_UF){
  library(car)
  library(olsrr)
  cat("Printing linear model \n")
  age2 <- right_UF$age^2
  LinModel <- lm(Mean_MD~age + age2, data = right_UF, na.action = na.omit)
  print(summary(LinModel))
  cat("Printing beta coefficient values \n")
  print(lm.beta(LinModel))
  par(mfrow = c(2,2))
  plot(LinModel)
  plot(cooks.distance(LinModel))
  ols_plot_cooksd_bar(LinModel)
}
