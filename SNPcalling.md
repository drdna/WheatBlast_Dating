# Stochasticity in variant calling

## Examine effect of read order on SNP calls:
1. Use [Run_shuffle.sh](/scripts/Run_shuffle.sh) to run shuffle.sh script from [BBmap](https://github.com/BioInfoTools/BBMap) package to randomize read order while maintaining paired-end relationships:
```bash
/bbmap/shuffle.sh -Xmx160g in=ERR2061616_1.fastq in2=ERR2061616_2.fastq out=ERR2061616rnd_1.fq out2=ERR2061616rnd_2.fq overwrite=true interleaved=false
```
2. Use bwa-mem2 to align reads:
3. 
