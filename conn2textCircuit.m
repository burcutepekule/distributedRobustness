function [fittestTextCircuitPickNew] = conn2textCircuit(conn)
conn = conn(~isnan(conn(:,2)),:);
fittestTextCircuitPickNew = [];
unqOutput = unique(conn(:,1));
for r=1:length(unqOutput)
    fittestTextCircuitPickNew{r,1}=1;
    fittestTextCircuitPickNew{r,2}=unqOutput(r);
    fittestTextCircuitPickNew{r,3}=[conn(conn(:,1)==unqOutput(r),2)]';
end

end

