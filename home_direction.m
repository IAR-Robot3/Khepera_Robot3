%Using inverse tangent we
%find angle to home direction and use this to decide which direction to turn at any
%given point. Need specific instructions for cases where y = 0.
function direction = home_direction(x,y,bot_angle)
  if (abs(x) <= 0.01 && abs(y) <= 0.01)
    direction = 'Stop';
    disp('I made it home!')
    return
  end

  %error in radius, if robot is within this error, it drives straight
  error = 0.5;
  home_angle = wrapTo2Pi(atan2(x,y));
  thresh_angle = wrapTo2Pi(home_angle + bot_angle + pi/2);

  diff = wrapTo2Pi(2*pi - thresh_angle);
  if diff <= error || diff >= (2*pi - error)
    direction = 'Straight';
  elseif thresh_angle > pi
    direction = 'Left Turn';
  elseif thresh_angle <= pi
    direction = 'Right Turn';
  else
    direction = 'Stop';
    disp(['Unexpected error occured with values: bot_angle='  num2str(bot_angle) ', x=' num2str(x) ', y=' num2str(y) ', home_angle=' num2str(home_angle) ', diff=' num2str(diff)])
  end
