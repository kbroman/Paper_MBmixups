## Identification of sample mix-ups and mixtures in microbiome data in Diversity Outbred mice

Files for a paper (in preparation) on detecting sample mix-ups and
mixtures in microbiome data in Diversity Outbred mice.

- [`mb_mixups.Rnw`](mb_mixups.Rnw) - Make text for the manuscript
- [`mb_mixups.bib`](mb_mixups.bib) - BibTeX file with bibliography
- [`Analysis/`](Analysis/) - directory contain basic analyses and
  summarized results; the raw data and pipeline to get data summaries
  are elsewhere
- [`Data/`](Data/) - summarized data sets for the analysis
- [`R/`](R/) - Code for making the figures (plus the basic analyses)

The initial work involved:

- mapping sequence reads to the mouse genome using bowtie

- generating pileup files using tools + Rsamtools
  (code `BamFile()`, `ScanBamParam()`, `pileup()`)

- ...look for reads that overlap each possible SNP among the 8
  founder lines and get counts of reads for each of the two alleles

- separately, use calculated genotype probabilities + SNP database
  on founders to get inferred genotypes at all SNPs for all DO
  offspring

R packages needed to compile the paper:

- [R/qtl2](https://kbroman.org/qtl2)
- [R/qtl2fst](https://github.com/rqtl/qtl2fst)
- [fst](http://www.fstpackage.org)
- [R/broman](https://github.com/kbroman/broman)
- [R/lineup2](https://github.com/kbroman/lineup2)
- [R/mbmixture](https://github.com/kbroman/mbmixture)

Current PDF of the paper at <https://www.biostat.wisc.edu/~kbroman/publications/mb_mixups.pdf>

---

### License

This manuscript is licensed under [CC BY](https://creativecommons.org/licenses/by/3.0/).

[![CC BY](https://i.creativecommons.org/l/by/3.0/88x31.png)](https://creativecommons.org/licenses/by/3.0/)
