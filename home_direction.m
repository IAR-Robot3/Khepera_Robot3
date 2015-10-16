%Idea behind this it to split the world into four quadrants around the home point (0,0)
%these quadrants are (x>0,y>0),(x<0,y>0),(x>0,y<0),(x<0,y<0), using inverse tangent we
%find angle to home direction and use this to decide which direction to turn at any
%given point. Need specific instructions for cases where y = 0.
function home_direction(x,y,bot_angle)
  error = 0.2;
  if x >= 0
    if y > 0
      %instructions for quadrant(x>0,y>0)
      home_angle = atan(x/y);
      diff = abs((home_angle + pi) - bot_angle);
      if diff <= error
        direction = 'Straight'
      elseif (bot_angle > home_angle) && (bot_angle <= home_angle + pi)
        direction = 'Right Curve'
      elseif ((bot_angle > home_angle + pi) && (bot_angle <= 2*pi) || (bot_angle <= home_angle))
        direction = 'Left Curve'
      end
    end
  end
end
