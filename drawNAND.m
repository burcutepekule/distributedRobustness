function [inletPoints,outletPoints] = drawNAND(x,y,plotOn)
P    = [x-0.5 y-0.5; x+0 y-0.5; x+0.5 y+0; x+0 y+0.5; x-0.5 y+0.5];
pgon = polyshape(P);
% plot(pgon, 'FaceColor',[0.1475    0.6043    0.9113])
if(plotOn==1)
%     plot(pgon, 'FaceColor',[0.2422    0.1504    0.6603])
%     plot(pgon, 'FaceColor',[12 30 127]./255,'FaceAlpha',1)
    plot(pgon, 'FaceColor',[0 0 0]./255,'FaceAlpha',0.8)

end
% c=bone(100);
% plot(pgon, 'FaceColor',c(10,:))

inletPoints_y  = linspace(y-0.5,y+0.5,4);
inletPoints_y  = inletPoints_y(2:end-1);
inletPoints_x  = [x-0.5 x-0.5];

outletPoints_x = P(3,1);
outletPoints_y = P(3,2);

inletPoints  = [inletPoints_x' inletPoints_y'];
outletPoints = [outletPoints_x outletPoints_y];

end

