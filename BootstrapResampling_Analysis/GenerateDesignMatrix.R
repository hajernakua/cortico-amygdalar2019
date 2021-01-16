####The function below will generate the different X number of iterations of the design matrices used in this study 
####This was used for both the structural covariance and functional connectivity models 

set.seed(2222) #reproducibility 

###this function takes the design matrix and resamples it X number of times which each final design matrix having the same number of rows as the starting matrix
###since my study has multiple combinations of brain-behaviour modelling, the starting design matrix featured all the combinations and then within the function, I created the
### the subsets of design matrices I wanted to use for each combination 

##important points:
## 1. All values are demeaned prior to submitting them to this function 
## 2. A column of ones was created prior to submitting them to this function (this is to set the linear regression in PALM)


bootstrap_resampling <- function(X, numboot) {
  
  X <- X ###dataframe we will be resampling
  numboot <- numboot ##number of bootstrap samples
  
  ##creating a data container to hold all the matrices
  matrix_EB_Lamyg <- vector("list", numboot)
  matrix_EB_Ramyg <- vector("list", numboot)
  matrix_IB_Lamyg <- vector("list", numboot)
  matrix_IB_Ramyg <- vector("list", numboot)
  Sub_IDs <- vector("list", numboot)
  
  row <- nrow(X)
  y <- 346
  
  for(i in 1:numboot) {
    print(i) ##iteration number
    resamples <- lapply(1:numboot, function(idx) X[sample(row,y, replace = T),]) ##creates the resampled matrices 
    print(resamples)
    
    ##now we have all the sampled matrices. The next step is to create specific matrices for each of the brain-behaviour combinations
    
    ###EXTERNALIZING BEHAVIOUR*LEFT AMYGDALA
    EB_Lamyg <- resamples[[i]][, c('col1', 'EB_Lamyg', 'age_scan', 'GENDER', 'CB68EPTOT', 'Lamyg', 'scanner', 'ICV.x')]
    print(EB_Lamyg)
    
    #getting a list of all the matrices
    matrix_EB_Lamyg[[i]] <- EB_Lamyg
    
    ###EXTERNALIZING BEHAVIOUR*RIGHT AMYGDALA
    EB_Ramyg <- resamples[[i]][, c('col1', 'EB_Ramyg', 'age_scan', 'GENDER', 'CB68EPTOT', 'Ramyg', 'scanner', 'ICV.x')]
    print(EB_Ramyg)
    
    matrix_EB_Ramyg[[i]] <- EB_Ramyg
    
    ###INTERNALIZING BEHAVIOUR*LEFT AMYGDALA
    IB_Lamyg <- resamples[[i]][, c('col1', 'IB_Lamyg', 'age_scan', 'GENDER', 'CB68IPTOT', 'Lamyg', 'scanner', 'ICV.x')]
    print(IB_Lamyg)
    
    matrix_IB_Lamyg[[i]] <- IB_Lamyg
    
    ###INTERNALIZING BEHAVIOUR*RIGHT AMYGDALA
    IB_Ramyg <- resamples[[i]][, c('col1', 'IB_Ramyg', 'age_scan', 'GENDER', 'CB68IPTOT', 'Ramyg', 'scanner', 'ICV.x')]
    print(IB_Ramyg)
    
    matrix_IB_Ramyg[[i]] <- IB_Ramyg
    
    ##SUBJECT IDS
    IDs <- as.data.frame(resamples[[i]][, c('ID')])
    print(IDs)
    
    Sub_IDs[[i]] <- IDs
  }
  
  ##this returns a data container with a series of variables which each have a list of matrices that can be extracted
  return(list("Sub_IDs" = Sub_IDs, "matrix_EB_Lamyg" = matrix_EB_Lamyg, "matrix_EB_Ramyg" = matrix_EB_Ramyg, "matrix_IB_Lamyg" = matrix_IB_Lamyg, "matrix_IB_Ramyg" = matrix_IB_Ramyg))
}


running_bootstrap_function <- bootstrap_resampling(X, numboot)
##once you run this command, you should get a large data container with a series of lists. The lists will be titled the names we provided them in the return command above.
##You can also see each iteration


###I next transfered these matrices to my local computer so I can push them onto my supercomputer cluster and run PALM on them. This bootstrap analysis requires a lot of memory so it will likely need to be done on a supercomputer.


library(purrr)

pmap(list(idx = seq_len(1000),
       subject_list = running_bootstrap_function$Sub_IDs,
       m1 = running_bootstrap_function$matrix_EB_Lamyg,
       m2 = running_bootstrap_function$matrix_EB_Ramyg,
       m3 = running_bootstrap_function$matrix_IB_Lamyg,
       m4 = running_bootstrap_function$matrix_IB_Ramyg),
  function(idx, subject_list, m1, m2, m3, m4) {
    # Write subject lists
    write.table(subject_list, paste(idx,'_subs.csv',sep=''), col.names=FALSE, row.names=FALSE)
    # Write matrix
    write.table(m1, paste(idx,'_EB_Lamyg_DesignMatrix.csv',sep=''), sep=',', col.names=FALSE, row.names=FALSE)
    write.table(m2, paste(idx,'_EB_Ramyg_DesignMatrix.csv',sep=''), sep=',', col.names=FALSE, row.names=FALSE)
    write.table(m3, paste(idx,'_IB_Lamyg_DesignMatrix.csv',sep=''), sep=',', col.names=FALSE, row.names=FALSE)
    write.table(m4, paste(idx,'_IB_Ramyg_DesignMatrix.csv',sep=''), sep=',', col.names=FALSE, row.names=FALSE)
})

