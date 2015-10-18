% Code for webots that instructs the bot to move forward to a surface
% then follow the edge of that surface avoid objects

time_step = 0.1;
direction = 'None';        % Direction for the current frame
speed = 4;                 % General speed of the robot.
default_dist = 120;        % Closer to wall <=> Bigger number
Kp = 9/default_dist;      % Parameter for P control
Ki = -2/default_dist;       % Parameter for PI control
Kd = 4/default_dist;      % Parameter for PD control
prev_errors = zeros(1,100); % Used for PI control
steps = 1:length(prev_errors);
found = 0;                 %If the robat has reached a surface or not 
n = 0;                     %Used to count instructions
current_motion = [0,0];    %Current motion of bot

% Variables for Odometry
go_home = 0;		   %This is set to 1 when it is time to go home
x = 0;                     %x relative to original position
y = 0;                     %y relative to original position
angle = 0;                 %angle relative to original position
vleft = 0;                 %Speed of left wheel
vright = 0;                %Speed of right wheel
contact_x = 0;             %x postion of first contact with surface 
contact_y = 0;             %y position of first contact with surface
contact_returned = 0;      %Returned to either start on first contact point
returned = 0;              %Returned to original position 
old_count_left = 0;
old_count_right = 0;


delete(instrfindall)
s = openConnection         %Open connection to khepra bot

setCounts(s,0,0);

% Calling MATLAB desktop versionwb_differential_wheels_set_speed(1, -1);
desktop;

% Main loop:
% Perform simulation steps of TIME_STEP milliseconds
tic;
while ~strcmp(direction, 'Stop') 
  sensor_values = readIR(s);
  counts = readCounts(s);
  left = (counts(1)-old_count_left)*0.0001/time_step;
  right = (counts(2)-old_count_right)*0.0001/time_step;

  new_position = odometery(x,y,angle,left,right);

  x = new_position(1);
  y = new_position(2);
  angle = new_position(3);
  [x,y]

  %[x, y, angle] = [new_position(1), new_position(2), new_position(3)];

  % Get distance to wall on the right
  dist = sensor_values(6);

  %Check how much time has past and if it is time to go home
  if toc >= 5 
    go_home = 1;
  end

  %Before an object is found, move forwards
  if ~found
    direction = 'Straight';
  end

  % The next conditions handle these situations:
  % To avoid head-on collisions
  if (max(sensor_values(3),sensor_values(4))>default_dist ...
  || sensor_values(5) > 150)
    direction = 'Left Turn';

    if ~found
      contact_x = x;
      contact_y = y;
    end

    found = 1;

  % To avoid obstacles on the left
  elseif (max(sensor_values(1),sensor_values(2))>150)
    direction = 'Right Curve';

    if ~found
      contact_x = x;
      contact_y = y;
    end
    
    found = 1;

  % If there are no obstacles and we are not going home - go to PID control
  elseif found && ~go_home
    direction = 'PID Control';

  elseif go_home
   disp('Going Home!')
   direction = home_direction(x,y,angle);
  end


  %Why arent we flooring speed/2 and speed/3?
  if strcmp(direction, 'Straight')
    if ~(current_motion(1) == speed && current_motion(2) == speed)
      %go(s, speed);
      disp('Straight!')
      vleft = speed;
      vright = speed;
      current_motion = [speed, speed];
    end
  elseif strcmp(direction, 'Left Turn')
    if ~(current_motion(1) == -speed && current_motion(2) == speed)
      %setSpeeds(s, -speed, speed)
      vleft = -speed;
      vright = speed;
      disp('Left Turn!')
      current_motion = [-speed, speed];
    end
  elseif strcmp(direction, 'Right Turn')
    if ~(current_motion(1) == speed && current_motion(2) == -speed)
      %setSpeeds(s, speed, -speed)
      vleft = speed;
      vright = -speed;
      disp('Right Turn!')
      current_motion = [speed, -speed];
    end
  elseif strcmp(direction, 'Left Curve')
    if ~(current_motion(1) == speed/2 && current_motion(2) == speed)
      %setSpeeds(s, speed/2, speed)
      vleft = speed/2;
      vright = speed;
      disp('Left Curve!')
      current_motion = [speed/2, speed];
    end
  elseif strcmp(direction, 'Right Curve')
    if ~(current_motion(1) == speed && current_motion(2) == speed/2)
      %setSpeeds(s, speed, speed/2)
      vleft = speed;
      vright = speed/2;
      disp('Right Curve!')
      current_motion = [speed, speed/2];
    end
  elseif strcmp(direction, 'Stop')
    if ~(current_motion(1) == 0 && current_motion(2) == 0)
      %go(s,0)
      disp('Stop!')
      vleft = 0;
      vright = 0;
      current_motion = [0,0];
    end
  elseif strcmp(direction, 'PID Control')
      % For P Control
      err = default_dist - dist;
      % For PI Control
      prev_errors = [err prev_errors(1:(length(prev_errors)-1))];
      int = trapz(steps,prev_errors)/length(steps);
      % For PD Control
      dev = diff(prev_errors);
      dev = mean(dev);
      % Do final calculations
      v = floor(Kp*err + Ki*int + Kd*dev);
      %disp(v)

      if v > 7
        v = 7;
      end
      if v < -7
        v = -7;
      end

      if ~(current_motion(1) == speed+v && current_motion(2) == speed+v)
        %setSpeeds(s, speed+v, speed-v);
        current_motion = [speed+v,speed-v];
        vleft = speed+v;
        vright = speed-v;
      end
      disp('PID Control!')
  else
      disp(['Something wrong! Recieved command: ' direction])
  end

  setSpeeds(s, vleft, vright);

  %setCounts(s,0,0);
  old_count = readCounts(s);
  old_count_left = old_count(1);
  old_count_right = old_count(2);

  n = n + 1;


  pause(time_step);



end

disp('Finished!')
