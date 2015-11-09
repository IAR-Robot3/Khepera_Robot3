function grid = findGrid(x,y)
%Finds which grid you are in

grid_x = floor(x/140);
grid_y = floor(y/70);

grid = [grid_x, grid_y];

end