clear fittestTextCircuit fittestStructure

fittestTextCircuit{1,1}  = 1;
fittestTextCircuit{2,1}  = 1;
fittestTextCircuit{3,1}  = 1;
fittestTextCircuit{4,1}  = 1;
fittestTextCircuit{5,1}  = 1;
fittestTextCircuit{6,1}  = 1;
fittestTextCircuit{7,1}  = 1;
fittestTextCircuit{8,1}  = 1;
fittestTextCircuit{9,1}  = 1;
fittestTextCircuit{10,1} = 1;
fittestTextCircuit{11,1} = 1;
fittestTextCircuit{12,1} = 1;
fittestTextCircuit{13,1} = 1;
fittestTextCircuit{14,1} = 1;

fittestTextCircuit{1,2}  = 13;
fittestTextCircuit{2,2}  = 23;
fittestTextCircuit{3,2}  = 33;
fittestTextCircuit{4,2}  = 43;
fittestTextCircuit{5,2}  = 1013;
fittestTextCircuit{6,2}  = 1023;
fittestTextCircuit{7,2}  = 2013;
fittestTextCircuit{8,2}  = 2023;
fittestTextCircuit{9,2}  = 2033;
fittestTextCircuit{10,2} = 2043;
fittestTextCircuit{11,2} = 3013;
fittestTextCircuit{12,2} = 3023;
fittestTextCircuit{13,2} = 4013;
fittestTextCircuit{14,2} = 4023;


fittestTextCircuit{1,3}  = [1011,2011];
fittestTextCircuit{2,3}  = [1012,2022];
fittestTextCircuit{3,3}  = [1021,2031];
fittestTextCircuit{4,3}  = [1022,2042];
fittestTextCircuit{5,3}  = [2012,2021];
fittestTextCircuit{6,3}  = [2032,2041];
fittestTextCircuit{7,3}  = [3011];
fittestTextCircuit{8,3}  = [3012];
fittestTextCircuit{9,3}  = [3021];
fittestTextCircuit{10,3} = [3022];
if(switchMod==1)
    fittestTextCircuit{11,3} = [4011,4012];
    fittestTextCircuit{12,3} = [4022,4021];
else
    fittestTextCircuit{11,3} = [4011,4021];
    fittestTextCircuit{12,3} = [4022,4012];
end
fittestTextCircuit{13,3} = [5011];
fittestTextCircuit{14,3} = [5012];

fittestStructure = [0 4;1 2;2 4;3 2;4 2;5 1];