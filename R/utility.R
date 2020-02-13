 
# P-value distribution
my_p_val_head  = function(counts, design, n = Inf, coef = NULL){
  keep <- filterByExpr(counts, design) # For good results, the counts matrix should be filtered to remove remove rows with very low counts before running voom(). The filterByExpr function in the edgeR package can be used for that purpose.
  voom(counts = counts[keep, ],
       design = design) %>%
    # arrayWeights %>%
    lmFit %>%
    eBayes %>%
    topTable(number = n, coef = coef) %>% 
    rownames_to_column(var = "gene") %>% 
    as_tibble
}# P-value distribution

my_p_val_plot = function(counts, design){
  keep <- filterByExpr(counts, design) # For good results, the counts matrix should be filtered to remove remove rows with very low counts before running voom(). The filterByExpr function in the edgeR package can be used for that purpose.
  voom(counts = counts[keep, ],
       design = design) %>%
    # arrayWeights %>%
    lmFit %>%
    eBayes %>%
    topTable(number = Inf) %>%
    gather(k,v, c("P.Value", "adj.P.Val")) %>%
    gf_histogram(~v) %>%
    gf_facet_wrap(~k)
}
 