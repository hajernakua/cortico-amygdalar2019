##The bootstrap resampling analysis for the diffusion models were conducted in R using the Boot function from the car package

##loading library
library(car)

####running the bootstrap linear models

###left cingulum FA and EB
set.seed(1234)
LinModel_lCB_FA_EB <- lm(Mean_FA~CB68EPTOT + age_scan + GENDER, data = left_cingulum_final, na.action = na.omit)
model.boot <- Boot(LinModel_lCB_FA_EB, R=1000)
Confint(model.boot, level=.95, type="norm") ##this one uses normal theory with the bootstrap standard errors 
hist(model.boot, legend="separate")


###left cingulum MD and EB
set.seed(2)
LinModel_lCB_MD_EB <- lm(Mean_MD~CB68EPTOT + age_scan + GENDER, data = left_cingulum_final, na.action = na.omit)
model.boot2 <- Boot(LinModel_lCB_MD_EB, R=1000)
Confint(model.boot2, level=.95, type="norm") ##this one uses normal theory with the bootstrap standard errors 
hist(model.boot2, legend="separate")


###left cingulum FA and IB
set.seed(3)
LinModel_lCB_FA_IB <- lm(Mean_FA~CB68IPTOT + age_scan + GENDER, data = left_cingulum_final, na.action = na.omit)
model.boot3 <- Boot(LinModel_lCB_FA_IB, R=1000)
Confint(model.boot3, level=.95, type="norm") ##this one uses normal theory with the bootstrap standard errors 
hist(model.boot3, legend="separate")

###left cingulum MD and IB
set.seed(4)
LinModel_lCB_MD_IB <- lm(Mean_MD~CB68IPTOT + age_scanx + GENDER, data = left_cingulum_final, na.action = na.omit)
model.boot4 <- Boot(LinModel_lCB_MD_IB, R=1000)
Confint(model.boot4, level=.95, type="norm") ##this one uses normal theory with the bootstrap standard errors 
hist(model.boot4, legend="separate")


###right cingulum FA and EB
set.seed(5)
LinModel_rCB_FA_EB <- lm(Mean_FA~CB68EPTOT + age_scan + GENDER, data = right_cingulum_final, na.action = na.omit)
model.boot5 <- Boot(LinModel_rCB_FA_EB, R=1000)
Confint(model.boot5, level=.95, type="norm") ##this one uses normal theory with the bootstrap standard errors 
hist(model.boot5, legend="separate")


###right cingulum MD and EB
set.seed(6)
LinModel_rCB_MD_EB <- lm(Mean_MD~CB68EPTOT + age_scan + GENDER, data = right_cingulum_final, na.action = na.omit)
model.boot6 <- Boot(LinModel_rCB_MD_EB, R=1000)
Confint(model.boot6, level=.95, type="norm") ##this one uses normal theory with the bootstrap standard errors 
hist(model.boot6, legend="separate")


###right cingulum FA and IB
set.seed(7)
LinModel_rCB_FA_IB <- lm(Mean_FA~CB68IPTOT + age_scan + GENDER, data = right_cingulum_final, na.action = na.omit)
model.boot7 <- Boot(LinModel_rCB_FA_IB, R=1000)
Confint(model.boot7, level=.95, type="norm") ##this one uses normal theory with the bootstrap standard errors 
hist(model.boot7, legend="separate")

###right cingulum MD and IB
set.seed(8)
LinModel_rCB_MD_IB <- lm(Mean_MD~CB68IPTOT + age_scan + GENDER, data = right_cingulum_final, na.action = na.omit)
model.boot8 <- Boot(LinModel_rCB_MD_IB, R=1000)
Confint(model.boot8, level=.95, type="norm") ##this one uses normal theory with the bootstrap standard errors 
hist(model.boot8, legend="separate")



###left UF FA and EB
set.seed(9)
LinModel_lUF_FA_EB <- lm(Mean_FA~CB68EPTOT + age_scan + GENDER, data = left_UF_final, na.action = na.omit)
model.boot9 <- Boot(LinModel_lUF_FA_EB, R=1000)
Confint(model.boot9, level=.95, type="norm") ##this one uses normal theory with the bootstrap standard errors 
hist(model.boot9, legend="separate")

###left UF MD and EB
set.seed(10)
LinModel_lUF_MD_EB <- lm(Mean_MD~CB68EPTOT + age_scan + GENDER, data = left_UF_final, na.action = na.omit)
model.boot10 <- Boot(LinModel_lUF_MD_EB, R=1000)
Confint(model.boot10, level=.95, type="norm") ##this one uses normal theory with the bootstrap standard errors 
hist(model.boot10, legend="separate")


###left UF FA and IB
set.seed(11)
LinModel_lUF_FA_IB <- lm(Mean_FA~CB68IPTOT + age_scan + GENDER, data = left_UF_final, na.action = na.omit)
model.boot11 <- Boot(LinModel_lUF_FA_IB, R=1000)
Confint(model.boot11, level=.95, type="norm") ##this one uses normal theory with the bootstrap standard errors 
hist(model.boot11, legend="separate")

###left UF MD and IB
set.seed(12)
LinModel_lUF_MD_IB <- lm(Mean_MD~CB68IPTOT + age_scan + GENDER, data = left_UF_final, na.action = na.omit)
model.boot12 <- Boot(LinModel_lUF_MD_IB, R=1000)
Confint(model.boot12, level=.95, type="norm") ##this one uses normal theory with the bootstrap standard errors 
hist(model.boot12, legend="separate")


###right UF FA and EB
set.seed(13)
LinModel_rUF_FA_EB <- lm(Mean_FA~CB68EPTOT + age_scan + GENDER, data = right_UF_final, na.action = na.omit)
model.boot13 <- Boot(LinModel_rUF_FA_EB, R=1000)
Confint(model.boot13, level=.95, type="norm") ##this one uses normal theory with the bootstrap standard errors 
hist(model.boot13, legend="separate")

###right UF MD and EB
set.seed(14)
LinModel_rUF_MD_EB <- lm(Mean_MD~CB68EPTOT + age_scan + GENDER, data = right_UF_final, na.action = na.omit)
model.boot14 <- Boot(LinModel_rUF_MD_EB, R=1000)
Confint(model.boot14, level=.95, type="norm") ##this one uses normal theory with the bootstrap standard errors 
hist(model.boot14, legend="separate")


###right UF FA and IB
set.seed(15)
LinModel_rUF_FA_IB <- lm(Mean_FA~CB68IPTOT + age_scan + GENDER, data = right_UF_final, na.action = na.omit)
model.boot15 <- Boot(LinModel_rUF_FA_IB, R=1000)
Confint(model.boot15, level=.95, type="norm") ##this one uses normal theory with the bootstrap standard errors 
hist(model.boot15, legend="separate")

###right UF MD and IB
set.seed(16)
LinModel_rUF_MD_IB <- lm(Mean_MD~CB68IPTOT + age_scan + GENDER, data = right_UF_final, na.action = na.omit)
model.boot16 <- Boot(LinModel_rUF_MD_IB, R=1000)
Confint(model.boot16, level=.95, type="norm") ##this one uses normal theory with the bootstrap standard errors 
hist(model.boot16, legend="separate")
