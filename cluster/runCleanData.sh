#!/bin/bash

seedMin=0
seedMax=99
stepSeed=1

for seed in $(seq ${seedMin} ${stepSeed} ${seedMax}); do
                    echo "at seed ${seed}"

	FILE=/net/cephfs/home/btepek/DISTRIBUTEDROBUSTNESS/AFTER_TOL_ALL_SEED_${seed}.mat
	if [ -f "$FILE" ]; then
                    echo "File exists, keeping it."
            else
                    echo "File does not exist, cleaning other stuff."
	rm BEFORE_TOL_FITTEST_CIRCUIT_SEED_${seed}_*.mat
	rm BEFORE_TOL_ALL_SEED_${seed}.mat
	rm AFTER_TOL_FITTEST_CIRCUIT_SEED_${seed}_*.mat
fi
done
