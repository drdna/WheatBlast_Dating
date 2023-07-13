# Stochasticity in variant calling
Patil AB, Vijay N. Repetitive genomic regions and the inference of demographic history. Heredity (Edinb). 2021 Aug;127(2):151-166. doi: 10.1038/s41437-021-00443-8. Epub 2021 May 17. PMID: 34002046; PMCID: PMC8322061.
We demonstrate that repeats affect demographic inferences using diverse methods like PSMC, MSMC, SMC++, and the Stairway plot. 

Chin, CS., Wagner, J., Zeng, Q. et al. A diploid assembly-based benchmark for variants in the major histocompatibility complex. Nat Commun 11, 4794 (2020). https://doi.org/10.1038/s41467-020-18564-9
"short reads used to develop the small variant benchmarks cannot be uniquely mapped to many repetitive regions of the genome, such as segmental duplications, tandem repeats, and mobile elements"

Can Firtina , Can Alkan, On genomic repeats and reproducibility, Bioinformatics, Volume 32, Issue 15, August 2016, Pages 2243–2247, https://doi.org/10.1093/bioinformatics/btw139
Reshuffling caused the reads from repetitive regions being mapped to different locations in the second alignment, and we observed similar results when we only applied a scatter/gather approach for read mapping—without prior shuffling. Our results show that, some of the most common variation discovery algorithms do not handle the ambiguous read mappings accurately when random locations are selected.

## Examine effect of read order on SNP calls:
1. Use [Run_shuffle.sh](/scripts/Run_shuffle.sh) to run shuffle.sh script from [BBmap](https://github.com/BioInfoTools/BBMap) package to randomize read order while maintaining paired-end relationships:
```bash
for f in {1..10}; do sbatch $scripts/Run_shuffle.sh $1; done
```
2. Use [Run_bwa-mem2.sh](/scripts/Run_bwa-mem2.sh) to perform alignments using parameters from Latorre et al. 2023:
```bash
for f in {1..10}; do sbatch $scripts/Run-bwa-mem2.sh ERR2061616rnd${f}; done
```
3. Use [Run_combineGVCFs.sh](/scripts/Run_combineGVCFs.sh) to generate a joint haplotype call file:
```bash
sbatch $scripts/Run_combineGVCFs.sh
```
4. Use [Run_GATK.sh](/scripts/Run_GATK.sh) to perform joint genotype calling and selection of SNPs:
```bash
sbatch $scripts/Run_GATK.sh
```
5. Count sites showing variants calls among the 10 shuffled datasets and which meet the QD thresholds used to produce the final Latorre et al. variant calls:
```bash
zgrep '' wheat-blast.raw.snps.vcf.gz | grep '      0:' | awk -F 'QD=' '{print $2}' | \
awk -F ';' '$1 > 24 && $1 < 34 {print $1}' | wc -l
```
## Final tally of FALSE variants identified by using "gold standard" SNP calling pipeline on 10 shuffled versions of a single fastq  dataset = 381
