function [inletPoints] = drawOUTPUT(x,y)
P    = [x-0.25 y-0.25; x+0.25 y-0.25; x+0.25 y+0.25; x-0.25 y+0.25];
pgon = polyshape(P);
plot(pgon, 'FaceColor',[0.9769    0.9839    0.0805])
inletPoints = [x-0.25 y];

end

