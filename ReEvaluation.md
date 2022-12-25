# Re-Analysis of the Latorre et al. dataset used for molecular dating

1. The tree shown in Figure X of the Latorre paper estimated the split date for the "B71 lineage" between X and Y years ago. However, for some reason, the split date for the "PY0925 lineage" was not provided and the branch lengths were shown as discontinuous. Therefore, to determine the date of that node, I downloaded the treefile used for generation of Figure X from the referenced githib repository () and used ggtree (link) to render a new tree:

![B71_PY0925_fullTree](data/B71_PY0925_fullTree.tiff)

This revealed that the estimated split date for the PY0925 was XXX years ago. This date is not easily reconcilable with the date of wheat emergence (1985), especially when one considers that the authors estimated that the existing lineages of rice blast - a disease with a 1,500 year history (ref)- evolved only 200-300 years ago.

2. Another puzzling detail in the molecular dating studies is that although the authors gathered sequence data for a larger number of wheat blast isolates, they only included isolates form the B71 and PY0925 lineages in their molecular dating studies. Knowing that their dataset was "poisoned" by variants acquired by admixture, and that the PY0925 lineage is the one that is most closely related to the B71 lineage, one can predict that molecular dating using the "whole dataset" will produce estimates for wheat blast evolution many thousands of years ago. Therefore, to test this prediction, I processed their data precisely according to their pipeline but omitted the step to filter out isolates that did not belong to the B71/PY0925 lineages:
```bash
bcftools view -m2 -M2 -g ^miss wheat-blast.snps.filtered.vcf.gz | bgzip > AllClust.snps.filtered.fullinfo.vcf.gz
```
2. The code provided in the github repository was used to convert the VCF records into a .fasta format file to generate input for the phylogenetic analyses:
```bash
plink --allow-extra-chr --vcf AllClust.snps.filtered.fullinfo.vcf.gz \
--recode transpose --out AllClust.snps.filtered.fullinfo

tped2fasta AllClust.snps.filtered.fullinfo > AllClust.snps.filtered.fullinfo.fasta
```
3. A phylogenetic tree was generated using RAxML:
```bash
raxml-ng --all --msa AllClust.snps.filtered.fullinfo.fasta --msa-format FASTA \
--data-type DNA --model GTR+G --bs-trees 1000
```
4. The data were then analyzed using ClonalFrame to detect sites predicted to have been aquired by reocmbination:
```bash
ClonalFrameML AllClust.snps.filtered.fullinfo.fasta.raxml.bestTree AllClust.snps.filtered.fullinfo.fasta
```
5. Putative recombinant sites flagged by ClonalFrame were masked:
```bash
python clean_homoplasy_from_fasta.py AllClust.snps.filtered.fullinfo.importation_status.txt \
AllClust.snps.filtered.fullinfo.fasta > AllClust.snps.filtered.fullinfo.clean.fasta \
2> AllClust.snps.filtered.fullinfo.recomb-masked.fasta
```
6. A new phylogenetic tree was generated for the recombination masked data using RAxML:
```bash
raxml-ng --all --msa AllClust.snps.filtered.fullinfo.recomb-masked.fasta --msa-format FASTA \
--data-type DNA --model GTR+G --bs-trees 1000
```
7. Generate a sampling dates list:
```bash
grep \> AllClust.snps.filtered.fullinfo.recomb-masked.fasta | sed 's/>//' | awk -F '_' '{print $1 "\t" $2}' > FullDataset.dates
```
8. Analyze phylogenetic signal based on patristic distance - this time to the oldest isolate T25:

