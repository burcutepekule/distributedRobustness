clear all;close all;clc;
% for local parallelization
parpool('local')
for seed = 7:57
    runSeedLocal(seed)
end