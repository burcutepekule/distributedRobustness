function [inletPoints] = drawOUTPUT(x,y,plotOn)
P    = [x-0.25 y-0.25; x+0.25 y-0.25; x+0.25 y+0.25; x-0.25 y+0.25];
pgon = polyshape(P);
% plot(pgon, 'FaceColor',[0.9769    0.9839    0.0805])
% plot(pgon, 'FaceColor',[0.6250    0.7500    0.7500])
if(plotOn==1)
    %     plot(pgon, 'FaceColor',[0.7431    0.8056    0.8056])
    plot(pgon, 'FaceColor',[17, 60, 252]./255,'FaceAlpha',1)
end

inletPoints = [x-0.25 y];

end

