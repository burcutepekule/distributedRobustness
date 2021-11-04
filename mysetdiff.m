function [d] = mysetdiff(x,y)
x=sort(x);
y=sort(y);
x=x';y=y';

[counts_x,vals_x] = groupcounts(x);
[counts_y,vals_y] = groupcounts(y);
counts_x_new = []; 
d            = [];
for k=1:length(vals_x)
    inds = find(vals_y==vals_x(k));
    if(~isempty(inds))
        counts_x_new(k) = counts_x(k)-counts_y(inds);
        d = [d repmat(vals_x(k),1,counts_x_new(k))];
    else
        d = [d repmat(vals_x(k),1,counts_x(k))];
    end
end
end

