function [h] = calcEnt(x)
h=-sum(x.*log(x));
end

