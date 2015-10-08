% Code for webots that instructs the bot to move forward to a surface
% then follow the edge of that surface avoid objects

TIME_STEP = 64;
direction = 'None';        % Direction for the current frame
speed = 4;                 % General speed of the robot.
default_dist = 120;        % Closer to wall <=> Bigger number
Kp = 9/default_dist;      % Parameter for P control
Ki = 2/default_dist;       % Parameter for PI control
Kd = -4/default_dist;      % Parameter for PD control
prev_errors = zeros(1,100); % Used for PI control
steps = 1:length(prev_errors);
found = 0;                 %If the robat has reached a surface or not 
n = 0;                     %Used to count instructions
current_motion = [0,0];    %Current motion of bot


delete(instrfindall)
s = openConnection         %Open connection to khepra bot

% Calling MATLAB desktop versionwb_differential_wheels_set_speed(1, -1);
desktop;

% Main loop:
% Perform simulation steps of TIME_STEP milliseconds
while 1
  sensor_values = readIR(s)

  % Get distance to wall on the right
  dist = sensor_values(6);

  %Before an object is found, move forwards
  if ~found
    direction = 'Straight';
  end

  % The next conditions handle these situations:
  % To avoid head-on collisions
  if (max(sensor_values(3),sensor_values(4))>default_dist ...
  || sensor_values(5) > 150)
    direction = 'Left Turn';
    found = 1;
  % To avoid obstacles on the left
  elseif (max(sensor_values(1),sensor_values(2))>150)
    direction = 'Right Curve';
    
    found = 1;
  % If there are no obstacles - go to PID control
  elseif found 
    direction = 'PID Control';
  end

  if strcmp(direction, 'Straight')
    if ~(current_motion(1) == speed && current_motion(2) == speed)
      go(s, speed);
      disp('Straight!')
      current_motion = [speed, speed];
    end
  elseif strcmp(direction, 'Left Turn')
    if ~(current_motion(1) == -speed && current_motion(2) == speed)
      setSpeeds(s, -speed, speed)
      disp('Left Turn!')
      current_motion = [-speed, speed];
    end
  elseif strcmp(direction, 'Right Turn')
    if ~(current_motion(1) == speed && current_motion(2) == -speed)
      setSpeeds(s, speed, -speed)
      disp('Right Turn!')
      current_motion = [speed, -speed];
    end
  elseif strcmp(direction, 'Left Curve')
    if ~(current_motion(1) == speed/2 && current_motion(2) == speed)
      setSpeeds(s, speed/2, speed)
      disp('Left Curve!')
      current_motion = [speed/2, speed];
    end
  elseif strcmp(direction, 'Right Curve')
    if ~(current_motion(1) == speed && current_motion(2) == speed/2)
      setSpeeds(s, speed, speed/2)
      disp('Right Curve!')
      current_motion = [speed, speed/2];
    end
  elseif strcmp(direction, 'Stop')
    if ~(current_motion(1) == 0 && current_motion(2) == 0)
      go(s,0)
      disp('Stop!')
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
      v = floor(Kp*err + Ki*0*int + Kd*dev);

      if v > 7
        v = 7;
      end
      if v < -7
        v = -7
      end

      if ~(current_motion(1) == speed+v && current_motion(2) == speed+v)
        setSpeeds(s, speed+v, speed-v);
        current_motion = [speed+v,speed-v];
      end
      disp('PID Control!')
  else
      disp(['Something wrong! Recieved command: ' direction])
  end

  n = n + 1;
  pause(0.1);
end
go(s, 0);
disp('Stop!')
