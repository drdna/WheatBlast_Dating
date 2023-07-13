#!/usr/bin/bash
#SBATCH --time 24:00:00
#SBATCH --job-name=bwa-mem2
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --partition=normal
#SBATCH --mem=100GB
#SBATCH --mail-type ALL
#SBATCH	-A coa_farman_uksr
#SBATCH --mail-type ALL
#SBATCH --mail-user farman@uky.edu

echo "SLURM_NODELIST: "$SLURM_NODELIST
echo "PWD :" $PWD
echo "readsprefix: $1"

#  reads prefix

readprefix=$1

# run bwa-mem2 alignment

bwa=/share/singularity/images/ccs/conda/amd-conda12-rocky8.sinf
samtools=/share/singularity/images/ccs/ngstools/samtools-1.13+matplotlib-bcftoools-1.13.sinf
sambamba=/share/singularity/images/ccs/conda/amd-conda5-rocky8.sinf

singularity run --app bwamem2221 $bwa bwa-mem2 mem -t 16 -R "@RG\tID:$readprefix\tSM:$readprefix" 70-15.fa ${readprefix}_1.f*q* ${readprefix}_2.f*q* > ${readprefix}.sam
singularity run --app samtools113 $samtools samtools view -SbhF 4 ${readprefix}.sam > ${readprefix}_mapped.bam
rm ${readprefix}.sam

singularity run --app sambamba082 $sambamba sambamba sort -o ${readprefix}_mapped_sorted.bam ${readprefix}_mapped.bam
singularity run --app sambamba082 $sambamba sambamba markdup ${readprefix}_mapped_sorted.bam ${readprefix}_mapped_sorted.dd.bam
