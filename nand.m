function [out] = nand(i1,i2)
if(isnan(i1) || isnan(i2))
    out = NaN;
else
    out=~(i1&i2);
%     if(i1==1 || i2==1)
%         out = 0;
%     else
%         out = 1;
%     end
end
end

