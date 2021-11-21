#!/bin/bash

seedMin=0
seedMax=199
stepSeed=1

for seed in $(seq ${seedMin} ${stepSeed} ${seedMax}); do
                    echo "at seed ${seed}"

if ssh btepek@cluster.s3it.uzh.ch "test -e /net/cephfs/home/btepek/DISTRIBUTEDROBUSTNESS/RDC_ALL_SEED_${seed}.mat"; then

                    echo "File exists"
rsync -av btepek@cluster.s3it.uzh.ch:/net/cephfs/home/btepek/DISTRIBUTEDROBUSTNESS/AFTER_TOL_FITTEST_CIRCUIT_SEED_${seed}_*.mat /Users/burcu/Dropbox/blogs/smallscaled/distributedRobustness/cluster/
rsync -av btepek@cluster.s3it.uzh.ch:/net/cephfs/home/btepek/DISTRIBUTEDROBUSTNESS/AFTER_TOL_ALL_SEED_${seed}.mat /Users/burcu/Dropbox/blogs/smallscaled/distributedRobustness/cluster/
rsync -av btepek@cluster.s3it.uzh.ch:/net/cephfs/home/btepek/DISTRIBUTEDROBUSTNESS/BEFORE_TOL_FITTEST_CIRCUIT_SEED_${seed}_*.mat /Users/burcu/Dropbox/blogs/smallscaled/distributedRobustness/cluster/
rsync -av btepek@cluster.s3it.uzh.ch:/net/cephfs/home/btepek/DISTRIBUTEDROBUSTNESS/BEFORE_TOL_ALL_SEED_${seed}.mat /Users/burcu/Dropbox/blogs/smallscaled/distributedRobustness/cluster/
rsync -av btepek@cluster.s3it.uzh.ch:/net/cephfs/home/btepek/DISTRIBUTEDROBUSTNESS/RDC_*_SEED_${seed}.mat /Users/burcu/Dropbox/blogs/smallscaled/distributedRobustness/cluster/
rsync -av btepek@cluster.s3it.uzh.ch:/net/cephfs/home/btepek/DISTRIBUTEDROBUSTNESS/RDC_ALL_SEED_${seed}.mat /Users/burcu/Dropbox/blogs/smallscaled/distributedRobustness/cluster/
            else
                    echo "File does not exist"

fi
done
