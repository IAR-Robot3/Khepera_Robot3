function robot3_controller(s)
    % Code for webots that instructs the bot to move forward to a surface
    % then follow the edge of that surface avoid objects
    
    food_poses = [];   % This is going to store the list of positions of food places 
    number_of_foods = 0;
    food_number = 1;
    plot(0,0,'--gs',...   % Draw home
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','g')


    positions = [];  %Stores all positions
    route_home_to_1 = [];
    route_1_to_2 = [];
    time_step = 0.1;
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
    world_map = create_map('arena_scaled_down3.jpg');
    full_world_map = create_map('arena_scaled.jpg');
    scale = 103.6000;
    map_starting_place = [1200,200];
    route_waypoints = [];

    % Variables for Odometry
    go_food = 0;           %This is set to 1 when it is time to go home
    go_home = 0;		   %This is set to 1 when it is time to go home
    x = 0;                     %x relative to original position
    y = 0;                     %y relative to original position
    angle = 0;                 %angle relative to original position
    vleft = 0;                 %Speed of left wheel
    vright = 0;                %Speed of right wheel
    returned = 0;              %Returned to original position 
    old_count_left = 0;
    old_count_right = 0;

    setCounts(s,0,0);

    % Calling MATLAB desktop versionwb_differential_wheels_set_speed(1, -1);
    desktop;

    % Main loop:
    % Perform simulation steps of TIME_STEP milliseconds
    tic;
    
    % Setup input window and flag
    % figure('Position',[50,800,250,250],'MenuBar','none','Name','Food found input','NumberTitle','off');
    set(gcf,'WindowButtonDownFcn',@setFoodFlag); % Mouse click
    set(gcf,'KeyPressFcn',@setFoodFlag); % Key press
    foodFlag = 0;
    
    while 1 
      sensor_values = readIR(s);

      [left_v, right_v, old_count_left, old_count_right] = wheel_speeds(s, old_count_left, old_count_right, time_step);

      new_position = odometery(x,y,angle,left_v,right_v);

      x = new_position(1);
      y = new_position(2);
      angle = new_position(3);
      
%       positions = [positions; [x,y]];

      [x, y]
      angle;

      %figure(1);
      %hold on
      %plot(x,y, 'ro')
      %grid on;
      %hold off


      %figure(2);
      %imagesc(world_map);
      %colormap(flipud(gray));

      %[x, y, angle] = [new_position(1), new_position(2), new_position(3)];

      % Get distance to wall on the right
      dist = sensor_values(6);

      %Check how much time has past and if it is time to go home
      if toc >= 1120
        %disp('Food!')
        if ~go_home
           go_food = 1;
        end
        %go_home = 1;
      end
      
      if foodFlag == 1
        number_of_foods = number_of_foods + 1;
        
        if number_of_foods >= 2 && food_number >= 2
            go(s,0);
            food_number = 0;
            go_food = 0
            go_home = 1
            route_waypoints = astar_search([x,y],map_starting_place,world_map);
        end
        
        if food_number < 2
            food_number = food_number + 1;
        end
        

        disp('Food found!');
        disp(toc)
        foodFlag = 0; % Reset flag
        food_pos = [x,y];
%         size(positions)
%         size(positions,1)
%         route = routes(positions);
%         if food_number == 1
%            route_home_to_1 = route;
%         else
%            route_1_to_2 = route;
%         end
%         positions = []
        food_poses =  food_memory_correction(food_poses,food_pos)
        hold on
        plot(food_pos(1),food_pos(2),'--gs',...
        'LineWidth',2,...
        'MarkerSize',10,...
        'MarkerEdgeColor','b')
        hold off
      end
    
      drawnow; % Need this to register button presses

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
        
      elseif (max(sensor_values(3),sensor_values(4))>default_dist ...
      || sensor_values(2) > 150)
        direction = 'Right Turn';
        found = 1;

      % To avoid obstacles on the left
      elseif (max(sensor_values(5),sensor_values(6))>150)
        direction = 'Left Curve';
        found = 1;

      % If there are no obstacles and we are not going home - go to PID control
      % elseif found && ~go_home && ~go_food
      %   direction = 'PID Control';

      elseif go_home
        % disp('Going Home!')
        % If you reached home, then go to food
        
        next_waypoint - route_waypoints(1,:)
        if (abs(x-next_waypoint(1)) <= 10 && abs(y-next_waypoint(2)) <= 10)
          route_waypoints = route_waypoints(2:size(route_waypoints,1),:);
          next_waypoint - route_waypoints(1,:)
        end
        
        direction = home_direction(x,y,angle,s,next_waypoint);
        if strcmp(direction, 'Stop')
            food_number = 1;
            go_home = 0
            go_food = 1
        end
        
       
      elseif go_food
        % disp('Going towards Food!')
        
        index = knnsearch(food_poses,[0,0],'k',2);
        closest_point = food_poses(index(food_number),:);
        direction = food_direction(x,y,angle,closest_point(1),closest_point(2));
        
%         if strcmp(direction, 'Stop')
%             go_food = 0
%             go_home = 1
%             direction = 'Straight';
%         end
        
      else
          direction = 'Straight';
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
        direction;
        if ~(current_motion(1) == -speed && current_motion(2) == speed)
          %setSpeeds(s, -speed, speed)
          vleft = -speed;
          vright = speed;
          disp('Left Turn!')
          current_motion = [-speed, speed];
        end
        %[left,right];
        %[vleft,vright];
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
          %disp('PID Control!')
      else
          disp(['Something wrong! Recieved command: ' direction])
      end

      setSpeeds(s, vleft, vright);

      %setCounts(s,0,0);
      %old_count = readCounts(s);
      %old_count_left = old_count(1);
      %old_count_right = old_count(2);

      n = n + 1;


      pause(time_step);



    end

    disp('Finished!')
    
    % This function gets called on click / button press
    % Note this is inside main function!
    function setFoodFlag(~,~)
        foodFlag = 1;
    end

end
