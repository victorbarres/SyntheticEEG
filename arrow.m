% 06-2012
% Victor Barres
% USC Brain Project
% Script to display an 'Arrow'
% tipProp = proportion of the length of the arrow given to the tip
% tipWidth = width of the basis of the arrow as a proportion of the tip length

function arrow(Start,End,tipProp,tipWidth,color)

x1 = Start;
x2 = End;
x3 = x2+(x1-x2)*tipProp;
x4 = x1+1/2*(x3-x1);
piece1 = [x1;x4;x3]; % Body of the arrow

v = (x2-x3)/norm((x2-x3));
n = [(v(2)+v(3))/v(1),1,1];
n = n/norm(n)*norm((x2-x3))*tipWidth*1/2;
x5 = x3+n;
x6 = x3-n;

piece2 = [x2;x5;x6]; % Tip of the arrow

vertices = [piece1;piece2];
faces= [1,2,3;4,5,6];

bnd.pnt = vertices;
bnd.tri = faces;
ft_plot_mesh(bnd,'facealpha',1,'facecolor',color);
end