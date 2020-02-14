setwd("/home/rstudio/workspace/")

# packages
library(tidyverse)
library(Biobase)
library(edgeR)
library(limma)
source("R/utility.R")

# human addhealth data
sapiens_wave1 <- readRDS("data/preprocessed/dat.rds")

# merge Brandts socio-economic score
br = read.csv("data/brandt2020/w1w5ses.021220",header = T, sep = "\t") %>% 
  rename(AID = aid) %>% 
  mutate(AID = as.character(AID)) %>% 
  mutate(ses_change = w5ses - w1ses)
pData(sapiens_wave1) <- pData(sapiens_wave1) %>% 
  left_join(br, by = "AID") 

# macaque status effects
noah_tableS6 <- readxl::read_excel("data/noah2016/noah_tableS6.xlsx")
macaque      <- noah_tableS6 %>% select(gene, monkey_rank_b = `rank β in LPS-`)
# keep only genes common across species
noah_tableS6 <- noah_tableS6 %>% filter(gene %in% featureNames(sapiens_wave1))
 

source("R/construct_control_variables.R")

# DESIGN
######## 

controls =
  c("sex_interv", "re", "Plate", "AvgCorrelogram100",
    "age_w1orw2",#"w5bmi",#adding age as covariates
    "BirthY", "bingedrink", "currentsmoke", "W5REGION","cpreterm",
    "pregnant_biow5", "illness_4wks_biow5", "illness_2wks_biow5",
    "smoking_biow5", "kit_biow5", "tube_biow5",  "FastHrs",
    "travel_biow5",  "months_biow5", "time_biow5",
    "B.cells.naive", "B.cells.memory", "Plasma.cells",
    "T.cells.CD8", "T.cells.CD4.naive", "T.cells.CD4.memory.resting",
    "T.cells.CD4.memory.activated", "T.cells.follicular.helper", "T.cells.regulatory..Tregs.", "T.cells.gamma.delta",
    "NK.cells.resting", "NK.cells.activated", "Monocytes", "Macrophages.M0", "Macrophages.M1", "Macrophages.M2", "Dendritic.cells.resting",
    "Dendritic.cells.activated", "Mast.cells.resting", "Mast.cells.activated", "Eosinophils", "Neutrophils" 
  )

X = phen %>% select(ses_change, controls)
non_missing = complete.cases(X)
rhs = str_c(c("ses_change",controls), collapse = " + ")
model_formula=str_c(" ~ ",rhs) %>% as.formula()
design = model.matrix(model_formula, data = X[non_missing, ])
counts = exprs(dat[, non_missing])

# HUMAN INFERENCE
#################
(ses_genes = my_p_val_head(counts, design, coef = "ses_change")) 

# Merge monkey and human estimates
status_genes = 
  ses_genes %>% 
  mutate(human_rank_b = logFC) %>% 
  left_join(macaque, by = "gene")   

# plot
library(ggformula)
status_genes %>% gf_point(human_rank_b ~ monkey_rank_b)

# STATISTICS
############

# stats proposed by Noah
status_genes %>% 
  cor.test( ~ human_rank_b + monkey_rank_b,
            data= . ,
            method = "spearman",
            continuity = FALSE,
            conf.level = 0.95)

# Fishers exact on sign
status_genes %>%
  transmute(human_sign = sign(human_rank_b), 
            monkey_sign = sign(monkey_rank_b)) %>% 
  table %>% 
  fisher.test

