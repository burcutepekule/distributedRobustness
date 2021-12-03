clear all;close all;clc;
% for local
% parpool('local')

for seed = 0:99
    runSeed(seed)
end