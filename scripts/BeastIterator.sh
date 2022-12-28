#SBATCH --time 4-00:00:00
#SBATCH --job-name=BEAST2_1
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --partition=normal
#SBATCH --mem=180GB
#SBATCH --mail-type ALL
#SBATCH	-A coa_farman_uksr
#SBATCH --mail-type ALL
#SBATCH --mail-user farman@uky.edu

echo "SLURM_NODELIST: "$SLURM_NODELIST
echo "PWD :" $PWD

# specifies the number of the iteration (independent BEAST run)
f=$1   

# clock type (STRICT, RELAXED, etc.)
clock=$2

# create directory for current run
mkdir ${clock}${f}

# prefix for output files
prefix=${clock}${f}

# explicit path to .xml file
xml=$3

# load container
container=/share/singularity/images/ccs/conda/amd-conda2-centos8.sinf

# run in singularity
singularity run --app beast2263 $container beast -threads 1 -overwrite -prefix $prefix $xml
