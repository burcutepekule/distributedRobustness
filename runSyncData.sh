#!/usr/bin/env bash

ssh btepek@cluster.s3it.uzh.ch

seedMin=0
seedMax=199
stepSeed=1

seedArr=()

for seed in $(seq ${seedMin} ${stepSeed} ${seedMax}); do
	FILE=/net/cephfs/home/btepek/DISTRIBUTEDROBUSTNESS/RDC_ALL_SEED_${seed}.mat
	if [ -f "$FILE" ]; then

    echo "$FILE exists, transferring."
rsync -av /net/cephfs/home/btepek/DISTRIBUTEDROBUSTNESS/AFTER_TOL_FITTEST_CIRCUIT_SEED_${seed}_*.mat burcuMac@192.168.1.4:/Users/burcu/Dropbox/blogs/smallscaled/distributedRobustness/cluster/
rsync -av btepek@cluster.s3it.uzh.ch:/net/cephfs/home/btepek/DISTRIBUTEDROBUSTNESS/AFTER_TOL_ALL_SEED_${seed}.mat /Users/burcu/Dropbox/blogs/smallscaled/distributedRobustness/cluster/
rsync -av btepek@cluster.s3it.uzh.ch:/net/cephfs/home/btepek/DISTRIBUTEDROBUSTNESS/BEFORE_TOL_FITTEST_CIRCUIT_SEED_${seed}_*.mat /Users/burcu/Dropbox/blogs/smallscaled/distributedRobustness/cluster/
rsync -av btepek@cluster.s3it.uzh.ch:/net/cephfs/home/btepek/DISTRIBUTEDROBUSTNESS/BEFORE_TOL_ALL_SEED_${seed}.mat /Users/burcu/Dropbox/blogs/smallscaled/distributedRobustness/cluster/
rsync -av btepek@cluster.s3it.uzh.ch:/net/cephfs/home/btepek/DISTRIBUTEDROBUSTNESS/RDC_*_SEED_${seed}.mat /Users/burcu/Dropbox/blogs/smallscaled/distributedRobustness/cluster/
rsync -av btepek@cluster.s3it.uzh.ch:/net/cephfs/home/btepek/DISTRIBUTEDROBUSTNESS/RDC_ALL_SEED_${seed}.mat /Users/burcu/Dropbox/blogs/smallscaled/distributedRobustness/cluster/
else 
    echo "$FILE does not exist."
fi
done
