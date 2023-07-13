#!/bin/bash

#SBATCH --time 12:00:00
#SBATCH --job-name=LatorreGATK
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --partition=normal
#SBATCH --mem=120GB
#SBATCH --mail-type ALL
#SBATCH	-A coa_farman_uksr
#SBATCH --mail-type ALL
#SBATCH --mail-user farman@uky.edu

echo "SLURM_NODELIST: "$SLURM_NODELIST
echo "PWD :" $PWD

#### specify input file prefixes
bamfile1=ERR2061616rnd1
bamfile2=ERR2061616rnd2
bamfile3=ERR2061616rnd3
bamfile4=ERR2061616rnd4
bamfile5=ERR2061616rnd5
bamfile6=ERR2061616rnd6
bamfile7=ERR2061616rnd7
bamfile8=ERR2061616rnd8
bamfile9=ERR2061616rnd9
bamfile10=ERR2061616rnd10

#### RUN GATK
gatkcontainer=/share/singularity/images/ccs/conda/amd-conda2-centos8.sinf

# merge haplotype calls
singularity run --app gatk44220 $gatkcontainer gatk --java-options "-Xmx96g" CombineGVCFs -R 70-15.fa -V ${bamfile1}.g.vcf.gz -V ${bamfile2}.g.vcf.gz -V ${bamfile3}.g.vcf.gz -V ${bamfile4}.g.vcf.gz \
 -V ${bamfile5}.g.vcf.gz -V ${bamfile6}.g.vcf.gz -V ${bamfile7}.g.vcf.gz -V ${bamfile8}.g.vcf.gz -V ${bamfile9}.g.vcf.gz -V ${bamfile10}.g.vcf.gz -O wheat-blast.g.vcf.gz

# call genotypes
singularity run --app gatk44220 $gatkcontainer gatk --java-options "-Xmx96g" GenotypeGVCFs -R 70-15.fa -ploidy 1 -V wheat-blast.g.vcf.gz -O wheat-blast.raw.vcf.gz

# filter snps
singularity run --app gatk44220 $gatkcontainer gatk --java-options "-Xmx96g" SelectVariants -select-type SNP -V wheat-blast.raw.vcf.gz -O wheat-blast.raw.snps.vcf.gz
