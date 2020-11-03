###This script will conduct the quantitative QC for DWI scans

#Load the csv file:
df <- read.csv("/path/to/csv")

#loading necessary libraries
library(dplyr)
library(ggplot2)
library(glue)
library(rmarkdown)
library(plotly)
library(readr)
library(stringr)
library(table1)
library(tidyr)
library(wesanderson)
library(ggpubr)
library(cowplot)
library(gridExtra)
library(grid)
library(gridGraphics)


##Step 1: Density Plots of the diffusion metrics to understand the distribution of each metric

density_plot_cnr1000 <- function(df) {
                   df2 <- df %>% filter(avg_cnr_1000 < 9999)
                   plot <- ggplot(df2, aes(x = avg_cnr_1000)) +
                                     geom_density(size = 2, aes(color = "#440154FF"), fill="lightblue") +
                                     geom_vline(data = df2, aes(xintercept = mean(avg_cnr_1000), color = "lightblue"), linetype = "dashed", size = 1) +
                                     labs(title = "Distribution of B1000 CNR Values", x = "B1000 CNR Values", y = "Density") +
                                     theme_bw()
                    return(plot)
}


density_plot_snr <- function(df) {
  df2 <- df %>% filter(avg_snr_0 < 9999)
  plot <- ggplot(df2, aes(x = avg_snr_0)) +
    geom_density(size = 2, aes(color = "#440154FF"), fill = "lightblue") +
    geom_vline(data = df2, aes(xintercept = mean(avg_snr_0), color = "lightblue"), linetype = "dashed", size = 1) +
    labs(title = "Distribution of CNR Values", x = "SNR Values", y = "Density") +
    theme_bw()
  return(plot)
}


density_plot_rel_mot <- function(df) {
  plot <- ggplot(df, aes(x = qc_mot_rel)) +
    geom_density(size = 2, aes(color = "#440154FF"), fill = "lightblue") +
    geom_vline(data = df, aes(xintercept = mean(qc_mot_rel), color = "lightblue"), linetype = "dashed", size = 1) +
    labs(title = "Distribution of Relative Motion Values", x = "Relative Motion Values", y = "Density") +
    theme_bw()
  return(plot)
}

density_plot_outliers <- function(df) {
  plot <- ggplot(df, aes(x = qc_outliers_tot)) +
    geom_density(size = 2, aes(color = "#440154FF"), fill = "lightblue") +
    geom_vline(data = df, aes(xintercept = mean(qc_outliers_tot), color = "lightblue"), linetype = "dashed", size = 1) +
    labs(title = "Distribution of Outlier Values", x = "Outlier Values", y = "Density") +
    theme_bw()
  return(plot)
}

plot_grid(density_plot_outliers(df), density_plot_rel_mot(df), density_plot_snr(df) + rremove("x.text"), 
          labels = c("A", "B", "C"),
          ncol = 1, nrow = 3)

plot_grid(density_plot_cnr1000(df), density_plot_cnr1600(df), density_plot_cnr2600(df) + rremove("x.text"), 
          labels = c("D", "E", "F"),
          ncol = 1, nrow = 3)


#Step 2: Excluding participants based on QC metrics derived from eddy QC: CNR, SNR, relative motion, and outliers  
#participants were excluded based on being 2 standard deviations away from the mean)

#Step 2.a: excluding bad CNR
bad_cnr_1000 <- df %>%
  mutate(cnr_std = scale(avg_cnr_1000)) %>% #This provides us with their STD so that we can determine if the distribution is Guassian
  filter(cnr_std < -2 | cnr_std > 2) #this will inform you of the subjects who had CNR that was greater and less than 2 standard deviations away from the mean. Anyone less than 2 STD should be excluded.
  #Those with 2 STD greater than the mean should be checked to make sure their other metrics are in the normal range and their visual QC is alright, however, they shouldn't be excluded unless there are other problems with their acquisitions.

#Note: if its multishell then you will have different average CNRs for every B values, and in that case, be sure to check all of them
#In the case of multishell acquisitions, use this if loop and feel free to change the B values to suit your study specific acquisitions


#Step 2.b: Excluding based on bad SNR
bad_snr <- df %>%
  mutate(snr_std = scale(avg_snr_0)) %>%
  filter(snr_std < -2 | snr_std > 2)


#Step 2.c: Excluding based on too much relative motion
bad_rel_mot <- df %>%
  mutate(rel_mot_std = scale(qc_mot_rel)) %>%
  filter(rel_mot_std > 2) #for motion, we're only concerned about participants with too much motion


#Step 2.d: Excluding based on too many outliers
bad_outliers <- df %>%
  mutate(outliers_std = scale(qc_outliers_tot)) %>%
  filter(outliers_std > 2)  #for outliers, we're only concerned about participants with too many outliers 


#Step 3: Creating a dataframe all the subjects that failed the Quantitative QC and their problematic values
library(plyr)
library(formattable)
bad_cnr_1000$ExclusionReason <- "too low (or high) CNR"
bad_snr$ExclusionReason <- "too low (or high) SNR"
bad_rel_mot$ExclusionReason <- "Too much relative motion"
bad_outliers$ExclusionReason <- "Too many outlier volumes"

Failed_Quant_QC <- rbind.fill(bad_cnr_1000, bad_snr, bad_rel_mot, bad_outliers)

Failed_Quant_QC_DF <- Failed_Quant_QC[,c("subject_id", "avg_cnr_1000", "avg_snr_0", "qc_mot_rel", "qc_outliers_tot", 'ExclusionReason')]
  
#Step 4: Create a table in R to visually see the participants excluded 
library(formattable)
  
formattable(DWI.Metrics.Table,
            list(`subject_id` = formatter("span", style = ~style(color = "grey", font.weight = "bold")),
                 `avg_snr_0` = color_bar("#FA614B"),
                 `avg_cnr_1000` = color_bar("green"),
                 `qc_mot_rel` = color_bar("sienna"),
                 `qc_outliers_tot` = color_bar("palevioletred")))
