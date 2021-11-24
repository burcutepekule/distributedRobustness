#!/usr/bin/env bash
#SBATCH --job-name=matlab      
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=4G
#SBATCH --output=OUT_PICK_%A_%a_%a.out
#SBATCH --array=0-10

module load anaconda3 
eval "$(conda shell.bash hook)"
conda activate DR_01
module load matlab


optMin=5
optMax=15
stepopt=1

optArr=()

for optTemp in $(seq ${optMin} ${stepopt} ${optMax}); do
	optArr+=($optTemp)
done

opt=${optArr[$SLURM_ARRAY_TASK_ID]}

pathOut=result_PICK_${opt}.out

srun matlab -singleCompThread -nodisplay -nosplash -r "runSeedPick(${opt})"