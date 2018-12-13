## Imputed SNP genotypes

Imputed SNP genotypes in
`z/Proj/attie/aklobo/snpCalls/imp_snp_[chr]_modified.RData`

Contains `imp_snps` (500 x no. index SNPs) with NA/1/2/3 genotypes
      and `snpinfo`  (no. snps x 11) with snp information,
             `pos_Mbp` = position in Mbp
             `gencol`  = corresponding column in `imp_snps`

Procedure:
   - find SNPs in snpinfo
   - grab corresponding columns in imp_snps
   - for each row in imp_snps, look at columns with 1 or 3 genotype and sum the read counts
