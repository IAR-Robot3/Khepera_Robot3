function new_position = odometery(X,Y,theta,left,right)
% Calculates the new position of the robot

new_theta = wrapTo2Pi(theta - 0.495*((left-right)/0.052));

%if new_theta < pi && theta > pi
%  x = 2*pi - theta;
%elseif new_theta > pi && theta < pi
%  x = 2*pi + theta;
%else
%  x = theta;
%end

%new_theta = wrapTo2Pi((x + new_theta)/2);

new_X = X + (0.5*(left+right)*cos(new_theta));
new_Y = Y + (0.5*(left+right)*sin(new_theta));

new_position = [new_X,new_Y,new_theta];

end
