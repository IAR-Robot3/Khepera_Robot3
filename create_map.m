function  world_map = create_map(filename) 
  old_map = im2bw(rgb2gray(imread(filename)),0.25);
  dimensions = size(old_map);
  MAX_X= dimensions(1);
  MAX_Y=dimensions(2);
  world_map = zeros(MAX_X,MAX_Y);

  for i=1:MAX_X
    for j=1:MAX_Y
      world_map(abs(MAX_X-i)+1,j) = old_map(i,j);
    end
  end
