clear all;close all;clc;
fileinfoRDC    = dir(['./cluster/BEFORE_TOL_ALL_SEED_*.mat']);
allNames       = {fileinfoRDC.name};
seedsConverged = sort(str2double(extractBefore(extractAfter(allNames,'BEFORE_TOL_ALL_SEED_'),'.mat')));
%%
for s=seedsConverged
    [s max(seedsConverged)]
    generateKeepDataLocalBeforeTOL(s)
end
