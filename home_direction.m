%Idea behind this it to split the world into four quadrants around the home point (0,0)
%these quadrants are (x>=0,y>0),(x<0,y>0),(x>=0,y<0),(x<0,y<0), using inverse tangent we
%find angle to home direction and use this to decide which direction to turn at any
%given point. Need specific instructions for cases where y = 0.
function direction = home_direction(x,y,bot_angle)
  if (x <= 0.5 && y <= 0.5)
    direction = 'Stop';
    disp('I did it Mom, I made it all the way home!')
    return
  end

  %error in radius, if robot is within this error, it drives straight
  error = 1;
  if x >= 0
    if y == 0
      %instructions for line(x>=0,y==0)
      home_angle = 0;

      diff = abs(((3*pi)/2) - bot_angle);
      if diff <= error
        direction = 'Straight';
      elseif (bot_angle > (pi/2)) && (bot_angle <= ((3*pi)/2))
        direction = 'Right Curve';
      elseif ((bot_angle > (3*pi)/2) && (bot_angle <= 2*pi)) || (bot_angle <= (pi/2))
        direction = 'Left Curve';
      else
        direction = 'Stop';
        disp(['Unexpected error occured with values: quadrant (x>=0,y==0), bot_angle='  num2str(bot_angle) ', x=' num2str(x) ', y=' num2str(y) ', home_angle=' num2str(home_angle) ', diff=' num2str(diff)])
      end
    elseif y > 0
      %instructions for quadrant(x>=0,y>0)
      home_angle = atan(x/y);

      diff = abs((home_angle + pi) - bot_angle);
      if diff <= error
        direction = 'Straight';
      elseif (bot_angle > home_angle) && (bot_angle <= home_angle + pi)
        direction = 'Right Curve';
      elseif ((bot_angle > home_angle + pi) && (bot_angle <= 2*pi)) || (bot_angle <= home_angle)
        direction = 'Left Curve';
      else
        direction = 'Stop';
        disp(['Unexpected error occured with values: quadrant (x>=0,y>0), bot_angle='  num2str(bot_angle) ', x=' num2str(x) ', y=' num2str(y) ', home_angle=' num2str(home_angle) ', diff=' num2str(diff)])
      end
    elseif y < 0
      %instructions for quadrant(x>=0,y<0)
      home_angle = atan(x/abs(y));

      diff = abs((2*pi - home_angle) - bot_angle);

      if (diff <= error) || (bot_angle <= error)
        direction = 'Straight';
      elseif (bot_angle > (pi - home_angle)) && ((bot_angle <= 2*pi - home_angle))
        direction = 'Right Curve';
      elseif ((bot_angle > 2*pi - home_angle) && (bot_angle <= 2*pi)) || (bot_angle <= (pi - home_angle))
        direction = 'Left Curve';
      else
        direction = 'Stop';
        disp(['Unexpected error occured with values: quadrant (x>=0,y<0), bot_angle='  num2str(bot_angle) ', x=' num2str(x) ', y=' num2str(y) ', home_angle=' num2str(home_angle) ', diff=' num2str(diff)])
      end
    end
  else
    if y == 0
      %instructions for line(x<0,y==0)
      home_angle = 0;

      diff = abs((pi/2) - bot_angle);
      if diff <= error
        direction = 'Straight';
      elseif ((bot_angle > (3*pi/2)) && (bot_angle <= 2*pi)) || (bot_angle <= (pi/2))
        direction = 'Right Curve';
      elseif (bot_angle > pi/2) && (bot_angle <= (3*pi/2))
        direction = 'Left Curve';
      else
        direction = 'Stop';
        disp(['Unexpected error occured with values: quadrant (x<0,y==0), bot_angle='  num2str(bot_angle) ', x=' num2str(x) ', y=' num2str(y) ', home_angle=' num2str(home_angle) ', diff=' num2str(diff)])
      end
    elseif y < 0
      %instructions for quadrant(x<0,y<0)
      home_angle = atan(abs(x)/abs(y));

      diff = abs(home_angle - bot_angle);
      if diff <= error
        direction = 'Straight';
      elseif (bot_angle <= home_angle) || ((bot_angle > home_angle + pi) && (bot_angle <= 2*pi))
        direction = 'Right Curve';
      elseif (bot_angle > home_angle) && (bot_angle <= home_angle + pi)
        direction = 'Left Curve';
      else
        direction = 'Stop';
        disp(['Unexpected error occured with values: quadrant (x<0,y<0), bot_angle='  num2str(bot_angle) ', x=' num2str(x) ', y=' num2str(y) ', home_angle=' num2str(home_angle) ', diff=' num2str(diff)])
      end
    elseif y > 0
      %instructions for quadrant(x<0,y>0)
      home_angle = atan(abs(x)/y);

      diff = abs((pi - home_angle) - bot_angle);
      if diff <= error
        direction = 'Straight';
      elseif (bot_angle <= (pi - home_angle)) || ((bot_angle > (2*pi - home_angle)) && bot_angle < 2*pi)
        direction = 'Right Curve';
      elseif (bot_angle > (pi - home_angle)) && (bot_angle <= (2*pi - home_angle))
        direction = 'Left Curve';
      else
        direction = 'Stop';
        disp(['Unexpected error occured with values: quadrant (x<0,y<0), bot_angle='  num2str(bot_angle) ', x=' num2str(x) ', y=' num2str(y) ', home_angle=' num2str(home_angle) ', diff=' num2str(diff)])
      end
    end
  end
end
