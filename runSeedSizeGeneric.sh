#!/usr/bin/env bash
#SBATCH --job-name=matlab      
#SBATCH --time=48:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=1G
#SBATCH --output=OUT_DR_SIZE_G_%A_%a_%a.out
#SBATCH --array=0-9

module load anaconda3 
eval "$(conda shell.bash hook)"
conda activate DR_01
module load matlab


seedMin=0
seedMax=9
stepSeed=1

seedArr=()

for seedTemp in $(seq ${seedMin} ${stepSeed} ${seedMax}); do
	seedArr+=($seedTemp)
done

seed=${seedArr[$SLURM_ARRAY_TASK_ID]}

pathOut=result_DR_SIZE_G_${seed}.out

mut=0.7
srun matlab -singleCompThread -nodisplay -nosplash -r "runSeedSize(${seed},${mut})"