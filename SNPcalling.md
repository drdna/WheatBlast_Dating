# Stochasticity in variant calling

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
zgrep '' wheat-blast.raw.snps.vcf.gz | grep '      0:' | awk -F 'QD=' '{print $2}' | awk -F ';' '$1 > 24 && $1 < 34 {print $1}' | wc -l
```
