function [inletPoints,outletPoints] = drawNAND(x,y)
P    = [x-0.5 y-0.5; x+0 y-0.5; x+0.5 y+0; x+0 y+0.5; x-0.5 y+0.5];
pgon = polyshape(P);
% plot(pgon, 'FaceColor',[0.1475    0.6043    0.9113])
plot(pgon, 'FaceColor',[0.2422    0.1504    0.6603])

inletPoints_y  = linspace(y-0.5,y+0.5,4);
inletPoints_y  = inletPoints_y(2:end-1);
inletPoints_x  = [x-0.5 x-0.5];

outletPoints_x = P(3,1);
outletPoints_y = P(3,2);

inletPoints  = [inletPoints_x' inletPoints_y'];
outletPoints = [outletPoints_x outletPoints_y];

end

