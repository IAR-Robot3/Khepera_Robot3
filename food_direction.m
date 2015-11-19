%Split into quadrants. Using inverse tangent we
%find angle to food direction and use this to decide which direction to turn at any
%given point. Need specific instructions for cases where y = 0.
function direction = food_direction(x,y,bot_angle,x_food,y_food)

  delta_x = x_food - x;
  delta_y = y_food - y;
  
  if (abs(delta_x) <= 17 && abs(delta_y) <= 17)
    random_number = floor(rand(1)*2);
    if random_number
        direction = 'Right Curve';
    else
        direction = 'Left Curve';
    end
    disp('I made it! Food!')
    return
  end

  %error in radius, if robot is within this error, it drives straight
  error = 0.2;
  food_angle = abs(pi/2 - abs(atan2(delta_y,delta_x)));
  
  r = floor(9*rand);
  if r > 6
      random_direction = 'Right Turn';
  else
      random_direction = 'Right Curve';
  end

  if x > x_food
    if y > y_food
      T = wrapTo2Pi(bot_angle + food_angle + pi/2 );
      if T <= error || T >= (2*pi - error)
        direction = 'Straight';
      elseif T < pi
        direction = random_direction;
      elseif T >= pi
        direction = 'Left Turn';
      end
    else
      T = wrapTo2Pi(bot_angle - food_angle - pi/2 );
      if T <= error || T >= (2*pi - error)
        direction = 'Straight';
      elseif T <= pi
        direction = random_direction;
      elseif T > pi
        direction = 'Left Turn';
      end
    end
  else
    if y > y_food             
      T = wrapTo2Pi(bot_angle - food_angle + pi/2 );
      if T <= error || T >= (2*pi - error)
        direction = 'Straight';
      elseif T <= pi
        direction = random_direction;
      elseif T > pi
        direction = 'Left Turn';
      end
    else
      T = wrapTo2Pi(bot_angle + food_angle - pi/2 );
      if T <= error || T >= (2*pi - error)
        direction = 'Straight';
      elseif T <= pi
        direction = random_direction;
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