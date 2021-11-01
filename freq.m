function [x,f] = freq(xin)
x = unique(xin); 
for i=1:length(x)
    f(i) = length(find(xin==x(i)));
end
end