function [arr] = str2logicArray(y)
arr=zeros(1,length(y));
for i=1:length(y)
    if(str2double(y(i))==1)
        arr(i) = true;
    else
        arr(i) = false;
    end
end

end