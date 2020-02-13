library(tidyverse)

# BIOCONDUCTOR 
##############

if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
BiocManager::install(c("Biobase", 
                       "limma",
                       "edgeR"), 
                     version = "3.10") 



# CRAN
######

library(devtools)

pkgs = 
  tribble(
    ~ package, ~ version,  
    # "lme4", "1.1-21",
    # "brms", "2.10.0"
    "ggformula", "0.9.3"
  ) 

pmap(pkgs, install_version, repos = "http://cran.us.r-project.org")
