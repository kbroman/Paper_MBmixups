# Get summary information

- `get_sample_summaries.R` - get summaries for each microbiome sample
  against all DNA samples, for one chromosome, as well as versus each
  pair of DNA samples. Creates `sample_results_chr_[chr].rds` and
  `pair_results_chr_[chr].rds`

- `combine_results.R` - combines the results from
  `get_sample_summaries.R` across chromosomes, creating
  `sample_results_allchr.rds` and `pair_results_allchr.rds`

- `analysis.R` - exploratory analysis of the results

- `count_reads.R` - counts the reads in the each microbiome sample on each
  chromosome. Results saved in `total_reads.rds`
