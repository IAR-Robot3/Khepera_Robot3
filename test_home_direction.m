%test for x<0 y>0

position = [2,3,0.4; 2,3,pi/2; 2,2,3.93; 0.001,2,0.9; -0.0001,2,2.0; -2,2,pi; -2,2,pi/2; -2,2,5.5; -2,0.001,0.2; -2,0.001,5; -2,-2,pi; -2,-2,5; -2,-2,0.79; -0.0001,-2,2; -0.001,-2,0.9; -0.001,-2,pi/2; 2,-2,4.7; 2,-2,pi/2; 2,-2,2.3];
directions = cellstr(['Right Turn'; 'Left Turn '; 'Straight  '; 'Right Turn'; 'Left Turn '; 'Left Turn '; 'Right Turn'; 'Straight  '; 'Right Turn'; 'Left Turn '; 'Right Turn'; 'Left Turn '; 'Straight  '; 'Right Turn'; 'Left Turn '; 'Straight  '; 'Right Turn'; 'Left Turn '; 'Straight  ']);

l = size(position);
l = l(1);

I = 1:l;

for i = I
  x = position(i,1);
  y = position(i,2);
  theta = position(i,3);
  expected_direction = directions(i);

  direction = home_direction(x,y,theta);
  if strcmp(direction,expected_direction)
    disp(strcat('Test for (', num2str(x), ',',  num2str(y),') angle:', num2str(theta), ': PASSED'))
  else
    disp(strcat('Test for (', num2str(x), ',',  num2str(y),') angle:', num2str(theta), ': FAILED. Returned:', direction, '. Expected:', expected_direction))
  end
end
