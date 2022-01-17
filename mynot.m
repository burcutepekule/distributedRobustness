function [x] = mynot(x)
if(~isnan(x))
    x=~x;
end
end

