# summarized data for microbiome mix-ups

- [`sample_results_allchr.rds`](sample_results_allchr.rds) - list of
  length 297 (corresponding to the microbiome samples), each being 500
  x 3 x 2 array (mouse DNA samples x 3 SNP genotypes x 2 alleles).
  For each (microbiome, mouse DNA) pair, we have counts of sequencing
  reads split by SNP allele at read and mouse DNA's genotype at SNP

- [`pair_results_allchr.rds`](pair_results_allchr.rds) - list of
  length 297 (the microbiomes sample), each being 500 x 3 x 3 x 2
  array. This is like `sample_results_allchr.rds`, but looking at
  paired genotypes for two mouse DNA samples: the one with the
  microbiome sample label and another one. This is for detecting mixtures.

- [`total_read.rds`](total_reads.rds) - data frame of size 297 x 19
  with total reads for each microbiome sample on each chromosome.
