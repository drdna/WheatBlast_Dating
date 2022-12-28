# Re-Analysis of the Latorre et al. dataset used for molecular dating

1. The tree shown in Figure X of the Latorre paper estimated the split date for the "B71 lineage" between X and Y years ago. However, for some reason, the split date for the "PY0925 lineage" was not provided and the use of a discontinous axis prevented estimation. Therefore, to ascertiain the date of that node, I downloaded the treefile used for generation of Figure X from the referenced githib repository () and used ggtree (link) to render the complete tree:

![B71_PY0925_fullTree](data/B71_PY0925_fullTree.tiff)

This revealed that the estimated split date for the PY0925 was ~384 years ago. First, this date is not easily reconcilable with the date of wheat emergence (1985), especially when one considers that the authors estimated that the existing lineages of rice blast - a disease with a 1,500 year history (ref)- evolved only 200-300 years ago. More importantly, however, if one plots haplotype divergence (SNPs per variant site) between each wheat blast isolate and a common reference - in this case B71 - one can clearly see that ALL wheat blast isolates are equally diverged from B71 over a significant proportion of their genomes, and most of the haplotype (=sequence) divergence is restricted to specific chromosome regions. Even within these diverged regions, however, different subsets of isolates still show significant haplotype identity to the B71 reference. That ~15% of the genome exibits similar and low levels of sequence divergence across isolates is only explicable if all of them diverged from B71 at approximately the same time, and very recently. At the same time the blocks of extreme divergence are consistent with the differential inheritance of chromosome segments with different ancestries - as implied by Figure S5 in Gladieux et al. (2018).

2. PY0925 shows no more sequence divergence to B71 over is certainly inconsistent with the idea that PY0925 evolved more than 350 years before B71. Another puzzling detail in the molecular dating studies is that although the authors gathered sequence data for a larger number of wheat blast isolates, they only included isolates form the B71 and PY0925 lineages in their molecular dating studies. Knowing that their dataset was "poisoned" by variants acquired by admixture, and that the PY0925 lineage is the one that is most closely related to the B71 lineage, one can predict that molecular dating using the "whole dataset" will produce estimates for wheat blast evolution many thousands of years ago. Therefore, to test this prediction, I processed their data precisely according to their pipeline but omitted the step to filter out isolates that did not belong to the B71/PY0925 lineages:
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
4. The data were then analyzed using ClonalFrame to detect sites predicted to have been aquired by recombination:
```bash
ClonalFrameML AllClust.snps.filtered.fullinfo.fasta.raxml.bestTree AllClust.snps.filtered.fullinfo.fasta
```
5. Putative recombinant sites flagged by ClonalFrame were masked using [mask_positions.py](https://github.com/Burbano-Lab/wheat-clonal-linage/blob/main/scripts/05_Phylogeny/mask_positions.py):
```bash
python3 mask_positions.py AllClust.snps.filtered.fullinfo.fasta \
AllClust.snps.filtered.fullinfo.importation_status.txt > AllClust.snps.filtered.fullinfo.clean.fasta
```
6. Generate a sampling dates list:
```bash
grep \> AllClust.snps.filtered.fullinfo.recomb-masked.fasta | sed 's/>//' | awk -F '_' '{print $1 "\t" $2}' > FullDataset.dates
```
7. Use recombination-free tree output by ClonalFrameML ([AllClust.snps.filtered.fullinfo.fasta_out.labelled_tree.newick](/data/AllClust.snps.filtered.fullinfo.fasta_out.labelled_tree.newick)) to analyze phylogenetic signal based on patristic distance - this time to the oldest isolate T25:

![Signal70isolates.tiff](/data/Signal70isolates.tiff)

8. Add sampling date information to fasta headers:

9. Calculate constant sites by using the reported constant sites parameter (constantSiteWeights='9117544 9766162 9779548 9135832') and subtracting sites that exhibited variation when the dataset was expanded. Also subtracted were sites whose variant status was now uncertain due to masking.
```bash
perl AdjustConstantSites.pl AllClust.snps.filtered.fullinfo.clean.fasta 9117544 9766162 9779548 9135832
```

10: Use the full [masked fasta file](/data/05_Phylogeny/B71_and_PY0925_clust.snps.filtered.fullinfo.recomb_masked.fasta) as input to create the configuration file with *beauti (BEAST 2)* using the following parameters and options:

- Tips were calibrated using collection dates
- HKY substitution model
- Strict Clock rate
- Uniform prior for the clock rate: [1E-10 to 1E-3] with a starting value of 1E-5
- Tree prior: Coalescent Extended Bayesian Skyline
- Monophyletic prior for the different clusters: Zambian isolates; Bangaladeshi isolates ; B71 cluster ; PY0925 cluster
- Chain length: 20'000,000
- Log every: 1,000
- Accounting for invariant sites by manually including the tag `constantSiteWeights='A B C D'` after the `<data>` block

The resulting [XML configuration file](/data/05_Phylogeny/B71_and_PY0925_clust.recomb_masked.BEAST2.xml) was submitted to the [University of Kentucky High Performance Computing Cluster](https://docs.ccs.uky.edu/display/HPC/UK%27s+OpenHPC+Compute+Clusters+-+Help+and+Information) with the following command to compute a Bayesian tip-dated phylogenetic reconstruction:Calculate invariant sites:
