clear all;close all;clc;
fileinfoRDC    = dir(['./cluster/AFTER_TOL_ALL_SEED_*.mat']);
allNames       = {fileinfoRDC.name};
seedsConverged = str2double(extractBefore(extractAfter(allNames,'./cluster/AFTER_TOL_ALL_SEED_'),'.mat'));um
for s=seedsConverged
    generateKeepDataLocal(s)
end
