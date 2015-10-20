%Split into quadrants. Using inverse tangent we
%find angle to home direction and use this to decide which direction to turn at any
%given point. Need specific instructions for cases where y = 0.
function direction = home_direction(x,y,bot_angle)
  if (abs(x) <= 5 && abs(y) <= 5)
    direction = 'Stop';
    disp('I made it home!')
    return
  end

  %error in radius, if robot is within this error, it drives straight
  error = 0.2;
  home_angle = abs(pi/2 - abs(atan2(y,x)));

  if x > 0
    if y > 0
      T = wrapTo2Pi(bot_angle + home_angle + pi/2 );
      if T <= error || T >= (2*pi - error)
        direction = 'Straight';
      elseif T < pi
        direction = 'Right Curve';
      elseif T >= pi
        direction = 'Left Turn';
      end
    else
      T = wrapTo2Pi(bot_angle - home_angle - pi/2 );
      if T <= error || T >= (2*pi - error)
        direction = 'Straight';
      elseif T <= pi
        direction = 'Right Curve';
      elseif T > pi
        direction = 'Left Turn';
      end
    end
  else
    if y > 0
      T = wrapTo2Pi(bot_angle - home_angle + pi/2 );
      if T <= error || T >= (2*pi - error)
        direction = 'Straight';
      elseif T <= pi
        direction = 'Right Curve';
      elseif T > pi
        direction = 'Left Turn';
      end
    else
      T = wrapTo2Pi(bot_angle + home_angle - pi/2 );
      if T <= error || T >= (2*pi - error)
        direction = 'Straight';
      elseif T <= pi
        direction = 'Right Curve';
      elseif T > pi
        direction = 'Left Turn';
      end
    end
  end
  %thresh_angle = wrapTo2Pi(bot_angle - (pi/2 - home_angle))

  %diff = wrapTo2Pi(pi - thresh_angle);
  %if diff <= error || diff >= (2*pi - error)
  %  direction = 'Straight';
  %elseif thresh_angle <= pi
  %  direction = 'Left Turn';
  %elseif thresh_angle > pi
  %  direction = 'Right Curve';
  %else
  %  direction = 'Stop';
  %  disp(['Unexpected error occured with values: bot_angle='  num2str(bot_angle) ', x=' num2str(x) ', y=' num2str(y) ', home_angle=' num2str(home_angle) ', diff=' num2str(diff)])
  %end
