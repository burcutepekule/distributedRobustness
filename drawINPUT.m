function [outletPoints] = drawINPUT(x,y,plotOn)
p = nsidedpoly(1000, 'Center', [x y], 'Radius', 0.25);
% plot(p,'FaceColor',[255, 114, 111]./255)
if(plotOn==1)
%     plot(p,'FaceColor',[255, 42, 38]./255)
    plot(p,'FaceColor',[255, 0, 142]./255,'FaceAlpha',1)
end
outletPoints = [x+0.25 y];
end

