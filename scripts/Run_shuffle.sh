#!/bin/bash

#SBATCH --time 48:00:00
#SBATCH --job-name=shuffle
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --partition=CAL48M192_L 
#SBATCH --mem=180GB
#SBATCH --mail-type ALL
#SBATCH	-A col_farman_uksr
#SBATCH --mail-type ALL
#SBATCH --mail-user farman@uky.edu

echo "SLURM_NODELIST: "$SLURM_NODELIST
echo "PWD :" $PWD

iteration=$1

#### RUN shuffle2

source /project/farman_uksr/miniconda3/etc/profile.d/conda.sh

# index outdir

/project/farman_uksr/bbmap/shuffle.sh -Xmx160g in=GoogleDrive/ERR2061616/ERR2061616_1.fastq in2=GoogleDrive/ERR2061616/ERR2061616_2.fastq \
out=ERR2061616rnd${iteration}_1.fastq out2=ERR2061616rnd${iteration}_2.fastq overwrite=true interleaved=false

conda deactivate
