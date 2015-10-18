function new_position = odometery(X,Y,theta,left,right)
% Calculates the new position of the robot

new_theta = wrapTo2Pi(theta - 0.5*((left-right)/0.052));
new_X = X + (0.5*(left+right)*cos(theta));
new_Y = Y + (0.5*(left+right)*sin(theta));

new_position = [new_X,new_Y,new_theta];

end