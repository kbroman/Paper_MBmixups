## Microbiome read counts

- for each sample on each chromosome, reduce the pileup files
  to a data frame with one SNP per row, containing
   - bp position
   - major and minor alleles (allele1 and allele2)
   - counts of those two alleles (count1 and count2)

- Also, drop SNPs that are not simple biallelic
  (e.g., drop a SNP that is like "A|G/T" meaning three alleles are
  represented among the 8 founder strains)


Results files `sample*_chr_readcounts.rds`

Each is a data frame with five columns,
  pos (in bp), allele1, allele2, count1, count2
with the rows being SNPs

The data looks like this:

```
      pos allele1 allele2 count1 count2
  3093573       G       T      5      0
  3111423       C       A      2      0
  3129561       G       A      3      0
```
