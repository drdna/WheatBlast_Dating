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
