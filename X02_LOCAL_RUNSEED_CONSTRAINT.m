clear all;close all;clc;
% for local parallelization
parpool('local')
for seed = 0:99
    runSeedConstraint(seed)
end