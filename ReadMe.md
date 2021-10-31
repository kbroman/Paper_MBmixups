## Identification of sample mix-ups and mixtures in microbiome data in Diversity Outbred mice

[![DOI](https://zenodo.org/badge/161683290.svg)](https://zenodo.org/badge/latestdoi/161683290)

This repository contains the source for the paper

> Lobo AK, Traeger LL, Keller MP, Attie AD, Rey FE, Broman KW (2021)
> Identification of sample mix-ups and mixtures in microbiome data in
> Diversity Outbred mice. [G3
> (Bethesda)](https://academic.oup.com/g3journal) 11:jkab308
> [![PubMed](https://kbroman.org/icons16/pubmed-icon.png)](https://pubmed.ncbi.nlm.nih.gov/34499168/)
> [![pdf](https://kbroman.org/icons16/pdf-icon.png)](https://academic.oup.com/g3journal/advance-article-pdf/doi/10.1093/g3journal/jkab308/40259169/jkab308.pdf)
> [![GitHub](https://kbroman.org/icons16/github-icon.png)](https://github.com/kbroman/Paper_MBmixups)
> [![R/mbmixture software](https://kbroman.org/icons16/R-icon.png)](https://github.com/kbroman/mbmixture)
> [![doi](https://kbroman.org/icons16/doi-icon.png)](https://doi.org/10.1093/g3journal/jkab308)


- [`mb_mixups.Rnw`](mb_mixups.Rnw) - Main text for the manuscript
  (LaTeX + R code, to be processed by [knitr](https://yihui.org/knitr/))
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
- [here](https://here.r-lib.org)
- [knitr](https://yihui.org/knitr/)
- [data.table](https://r-datatable.com/)
- [kableExtra](http://haozhu233.github.io/kableExtra/)
- [magrittr](https://magrittr.tidyverse.org/)


### Additional data

- Intermediate data files at [figshare
  doi:10.6084/m9.figshare.16413279](https://doi.org/10.6084/m9.figshare.16413279)

- Primary metagenomic sequence data at [Sequence Read Archive (SRA),
  accession
  PRJNA744213](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA744213)

- SQLite database of variants in the Collaborative Cross founders at
  [Figshare, doi:10.6084/m9.figshare.5280229.v3](https://doi.org/10.6084/m9.figshare.5280229.v3)


### License

This manuscript is licensed under [CC BY](https://creativecommons.org/licenses/by/3.0/).

[![CC BY](https://i.creativecommons.org/l/by/3.0/88x31.png)](https://creativecommons.org/licenses/by/3.0/)
