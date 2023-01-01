# (In)Validation of the Latorre dataset used for Linkage Disequilibrium analysis

## Background
Linkage disequilibrium studies involve analyses of the association between pairs of nucleotide variants as a function of their separation along the chromosome. For such analyses to provide an accurate picture of the recombination landscape, certain criteria absolutely must be met:
a) The single nucleotide polymorphisms being studied must be true SNPs, otherwise, unless the same invalid SNPs are called in every sample, false recombination signals will be detected.
b) The chromosomal position of each SNP must be accurately assigned, otherwise assessment of linkage disequilibrium (LD) decay rates will be inaccurate/invalid.
c) One should not use SNPs that occur inside repeated sequences, otherwise there is a danger that both the called SNP *AND* its chromosomal location will be invalid. This is especially so when using SNPs called against a reference genome with a substantially different genetic background to the population(s) under study, because there is even the possibility that a SNP will be called when the test strain is null for the repeat copy in question.

1. The number one cause of invalid SNP calls is the failure to recognize false variants that occur in repeated regions of the reference genome. Therefore, I sought to determine how many SNPs used in the [Latorre LD dataset](https://github.com/Burbano-Lab/wheat-clonal-linage/blob/main/data/04_Recombination/B71_cluster.LD.gz) came from sequences that are repeated in the reference genome but for which there is no evidence that a repeat exists at that position in the query genomes. To accomplish this, I first BLASTED the 70-15 reference genome aginst the latest, chromosome-level assembly for B71:
```bash
blastn -query 70-15.fasta -subject B71v2sh.fasta -evalue 1e-20 -max_target_seqs 20000 -outfmt \
'6 qseqid sseqid qstart qend sstart send btop' > 70-15.B71v2.BLAST
```
Then, I built an alignment string that records for each nucleotide in the 70-15 reference genome its copy number *in the B71 reference genome*:
```bash
perl Create_alignment_stringsv2.pl 70-15.fasta 70-15.B71v2.BLAST 70-15.B71v2.ALIGN
```
2. Next, I used a script to parse the BLAST report, line by line, and asked if each alignment contained any repeats that were flanked on either side by at least 50 nucleotides that were single copy in both genomes. Repeats that satisfied this criterion were considered to be present at the same chromosomal location in both genomes and were allowed to pass the filter:
```bash
perl OrthologousRepeats.pl 70-15.B71v2.ALIGN/70-15.B71v2_alignments 70-15.B71v2.BLAST
```
3. Using the ortholog-correct alignment string, I then used the [NonOrthologousLDcomparisons.pl](/scripts/NonOrthologousLDcomparisons.pl) to re-interrogate the [B71clust_LD.gz](https://github.com/Burbano-Lab/wheat-clonal-linage/blob/main/data/04_Recombination/B71_cluster.LD.gz) data file used in the published LD analysis to determine how many of the pairwise comparisons involved at least one SNP that occurred in a repeated segment of the 70-15 genome for which there was no evidence that a repeat was present at the dsame location in the B71 assembly.
```bash
perl NonOrthologousLDcomparisons.pl 70-15.B71v2.orthologous B71_clust.LD.gz
```
This revealed that among the 21,535 pairwise SNP comparisons used in the publsihed LD study, 12,434 (57.7%) included at least one SNP that resides within a repeat in the 70-15 genome, and for which there was no evidence that the same repeat exists at an equivalent location in the B71 genome.

4. Finally, to validate the above analysis, I examined some of the suspicious SNPs in detail buy using [FACET]() to realign the 70-15 x B71v2 genomes and produce outputs in GFF format. At the same time the 70-15 genome was aligned with a comprehensive set of genomic repeat sequences. The two sets of alignments were then visualized in the IGV browser. For Chr1 SNP positions 110,315 vs 2,865,521, the second SNP is in a MGL retrotransposon with >30 copies in the B71 genome and over 50 copies in the 70-15 reference. More importantly, there is no MGL copy at the corresponding genomic position because B71 has a 110 kb sequence at that location that is missing in 70-15. Likewise, the next 52 comparisons between SNPs at Chr1 positions 335,274 and 337,273 and others at various positions along the chromosome, are also invalid because these two sites are in repeats that are not present in the B71 genome which happens to have a 200 kb deletion spanning the entire locus.
