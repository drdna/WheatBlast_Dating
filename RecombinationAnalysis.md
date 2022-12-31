# (In)Validation of the Latorre dataset used for Linkage Disequilibrium analysis

## Background
Linkage disequilibrium studies involve analyses of the association between pairs of nucleotide variants as a function of their separation along the chromosome. For such analyses to provide an accurate picture of the recombination landscape, certain criteria absolutely must be met:
1) The single nucleotide polymorphisms being studied must be true SNPs, otherwise there is a danger that false recombination signals will be detected.
2) The chromosomal position of each SNP must be accurately assigned, otherwise assessment of linkage disequilibrium (LD) decay rates will be inaccurate/invalid.
3) One should not use SNPs that occur inside repeated sequences, otherwise there is a danger that the called SNP *AND* its chromosomal location is invalid. This is especially so when using SNPs called against a reference genome with a substantially different genetic background to the population(s) under study, because there is even the possibility that a SNP will be called when the test strain is null for the repeat copy in question.

1. The number one cause of invalid SNP calls is the failure to recognize false variants that occur in repeated regions of the reference genome. Therefore, I compared the chromosomal positions of SNP calls in the dataset that Latorre et al. used for their LD studies against sets of "alignment strings" that recorded the copy number of each nucleotide in the 70-15 reference genome (1 for one time; 2 for two or more times):
```bash
perl 
``` 
This revealed that among 21,535 SNP pairs used in the LD analysis, there were 6,333 (29.4%) where at least one of the SNPs was in a repeated sequence.
5. Next, I sought to determine how many of these suspect SNPs came from sequences that are repeated in the reference genome but for which there is no evidence that a repeat exists at that position in the query genomes. To do this, I first built an alignment string that records the copy number of each nucleotide in the 70-15 reference genome *in the B71 reference genome*:
```bash
blastn -query 70-15.fasta -subject B71v2sh.fasta -evalue 1e-20 -max_target_seqs 20000 -outfmt \
'6 qseqid sseqid qstart qend sstart send btop' > 70-15.B71v2.BLAST
perl Create_alignment_stringsv2.pl 70-15.fasta 70-15.B71v2.BLAST 70-15.B71v2.ALIGN
```
Then I used a script to parse the BLAST report, line by line, and asked if each alignment contained any repeats that were flanked on either side by at least 50 nucleotides that were single copy in both genomes. Repeats that satisfied this criterion were considered to be present at the same chromosomal location in both genomes and were allowed to pass the filter:
```bash
perl OrthologousRepeats.pl 70-15.B71v2.ALIGN/70-15.B71v2_alignments 70-15.B71v2.BLAST
```
