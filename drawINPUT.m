function [outletPoints] = drawINPUT(x,y)
p = nsidedpoly(1000, 'Center', [x y], 'Radius', 0.25);
% plot(p,'FaceColor',[255, 114, 111]./255)
plot(p,'FaceColor',[255, 42, 38]./255)
outletPoints = [x+0.25 y];
end

