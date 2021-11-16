clear all;close all;clc;
load('RDC_103')
% %%
% keepData = [keepData; 
%  simIdx            1
%  circuitSize       2
%  fitness           3  
%  faultTolerance    4
%  degeneracy        5
%  degeneracyUB      6
%  redundancy        7
%  complexity        8
%  ];

afterFT = keepData(keepData(:,4)>0,:);
%%
close all;
scatter(afterFT(:,8),afterFT(:,4),'k','filled')
xlabel('Complexity')
ylabel('Fault Tolerance')
grid on;

%%
close all;
scatter(keepData(:,7),keepData(:,5),'k','filled')
% hold on;
% scatter(keepData(:,7),keepData(:,6),'r','filled')
xlabel('Redundancy')
ylabel('Degeneracy')
grid on;

%%
close all;
scatter(keepData(:,2),keepData(:,5),'k','filled')
% hold on;
% scatter(keepData(:,2),keepData(:,6),'r','filled')
xlabel('Circuit Size')
ylabel('Degeneracy')
grid on;

%%
close all;
scatter(keepData(:,5),keepData(:,8),'k','filled')
% hold on;
% scatter(keepData(:,2),keepData(:,6),'r','filled')
xlabel('Degeneracy')
ylabel('Complexity')
grid on;