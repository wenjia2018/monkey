
# new human batch control variables
###################################

dat = sapiens_wave1[noah_tableS6$gene, ]
phen   = pData(dat)

# (time of blood measurement)
phen = phen %>%  
  mutate(time_biow5 = case_when( (hour_biow5==6 | hour_biow5==7) ~ "6_7",
                                 (hour_biow5==8 | hour_biow5==9) ~ "8_9",
                                 (hour_biow5==10 | hour_biow5==11) ~ "10_11",
                                 (hour_biow5==12 | hour_biow5==13) ~ "12_13",
                                 (hour_biow5==14 | hour_biow5==15) ~ "14_15",
                                 (hour_biow5==16 | hour_biow5==17) ~ "16_17",
                                 (hour_biow5==18 | hour_biow5==19 | hour_biow5==20) ~ "18_19_20"))

# (cell type composition: cibersort results)
cibersort <-read.csv("data/cell_type_cybersort/CIBERSORT.Output_Job5.csv", header=TRUE, sep=",")
cibersort_crosswalk <-read.csv("data/cell_type_cybersort/CIBERSORT.Output_Job5_crosswalk.csv", header=TRUE, sep="\t")
cibersort_crosswalk$aid <- as.character(cibersort_crosswalk$aid)
cibersort_crosswalk <- cibersort_crosswalk %>% dplyr::rename(AID=aid)
cibersort_final <- cibersort %>%  dplyr::rename(sample=Input.Sample) %>% left_join(cibersort_crosswalk, by="sample")
phen <- phen %>% left_join(cibersort_final, by = "AID")
 