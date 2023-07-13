#!/bin/bash

#SBATCH --time 96:00:00
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


#### RUN GATK

bamfile=$1
gatkcontainer=/share/singularity/images/ccs/conda/amd-conda2-centos8.sinf

# call haplotypes
singularity run --app gatk44220 $gatkcontainer gatk --java-options "-Xmx96g" HaplotypeCaller -ERC GVCF -R 70-15.fa -ploidy 1 -I ${bamfile}_mapped_sorted.dd.bam -O ${bamfile}.g.vcf.gz 
