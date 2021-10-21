function [outletPoints] = drawINPUT(x,y)
% viscircles([x,y],1)
p = nsidedpoly(1000, 'Center', [x y], 'Radius', 0.25);
plot(p,'FaceColor',[0.2422    0.1504    0.6603])
outletPoints = [x y];
end

