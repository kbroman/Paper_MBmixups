## Basic analyses

- The primary metagenomic sequence data is at
  [the Sequence Read Archive, accession PRJNA744213](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA744213)

- Much of the intermediate data is at [Figshare,
  doi:10.6084/m9.figshare.16413279](https://doi.org/10.6084/m9.figshare.16413279)


- BAM files
  - We mapped the paired reads to the mouse genome
  - We mapped the unpaired reads to the mouse genome
  - We sorted and indexed the BAM files

- `Pileups/`
  - run pileup() on each BAM file for each chromosome
  - keep just the positions that overlap one of the Collaborative Cross SNPs
    (SQLite database available at [figshare,
    doi:10.6084/m9.figshare.5280229.v3](https://doi.org/10.6084/m9.figshare.5280229.v3)
  - combine the paired and unpaired reads for a given sample on a
    given chromosome

- `Readcounts/`
  - for each sample on each chromosome, reduce the pileup files
    to a data frame with one SNP per row, containing
     - bp position
     - major and minor alleles (allele1 and allele2)
     - counts of those two alleles (count1 and count2)
  - Also, drop SNPs that are not simple biallelic
    (e.g., drop a SNP that is like "A|G/T" meaning three alleles are
    represented among the 8 founder strains)

- `CalcGenoProb/`
  - Calculated genotype probabilities, using GigaMUGA genotype data

- `SnpCalls/`
  - Use the genotype probabilities along with the SQLite database of
    Collaborative Cross founders' SNPs to get imputed SNP genotypes
    across the genome

- `Summaries/`
  - Compare the SnpCalls to the metagenomic sequence reads for each
    sample and sample pair
