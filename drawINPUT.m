function [outletPoints] = drawINPUT(x,y)
% viscircles([x,y],1)
p = nsidedpoly(1000, 'Center', [x y], 'Radius', 0.25);
% plot(p,'FaceColor',[0.2422    0.1504    0.6603])
% plot(p,'FaceColor',[0.0704    0.7457    0.7258])
plot(p,'FaceColor',[255, 114, 111]./255)

outletPoints = [x+0.25 y];
end

