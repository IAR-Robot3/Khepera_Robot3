% testing for atan2(x,y):

c1 = sqrt(3)/2;
c2 = 1/2;
c3 = 1/sqrt(2);

p = radtodeg(atan2(0,0)) % should retutn 0;
p = radtodeg(atan2(c2,c1)) % should return 30;
p = radtodeg(atan2(c3,c3)) % shoudl return 45;
p = radtodeg(atan2(c1,c2)) % should return 60;

p = radtodeg(atan2(1,0)) % should return 90;
p = radtodeg(atan2(c1,-c2)) % should return 120;
p = radtodeg(atan2(c3,-c3)) % should return 135;
p = radtodeg(atan2(c2,-c1)) % should return 150;

p = radtodeg(atan2(0,-1)) % should return 180;
p = radtodeg(atan2(-c2,-c2)) % should return 225;
p = radtodeg(atan2(-1,0)) % should return 270;
p = radtodeg(atan2(-c2,c2)) % should return 315;
p = radtodeg(atan2(0,1)) % should return 360,0;

% all answers are correct if you do warp to 2pi

%%%%%%%%%%%%%%%%
% testing for home_angle, and %threshold angle tester (for when bot_angle is 0):
bot_angle = 270

home_angle = radtodeg(pi/2 - (atan2(0,1))); % 90
thresh_hold_angle = wrapTo360(home_angle + bot_angle + 90)

home_angle = radtodeg(pi/2 - (atan2(c2,c1))); % 60
thresh_hold_angle = wrapTo360(home_angle + bot_angle + 90)

home_angle = radtodeg(pi/2 - (atan2(c1,c2))); % 30
thresh_hold_angle = wrapTo360(home_angle + bot_angle + 90)

home_angle = radtodeg(pi/2 - (atan2(1,0))); % 0
thresh_hold_angle = wrapTo360(home_angle + bot_angle + 90)

home_angle = radtodeg(pi/2 - (atan2(c1,-c2))); % -30
thresh_hold_angle = wrapTo360(home_angle + bot_angle + 90)

home_angle = radtodeg(pi/2 - (atan2(c2,-c1))); % -60
thresh_hold_angle = wrapTo360(home_angle + bot_angle + 90)

home_angle = radtodeg(pi/2 - (atan2(0,-1))); % -90
thresh_hold_angle = wrapTo360(home_angle + bot_angle + 90)

home_angle = radtodeg(pi/2 - (atan2(-c2,-c1))); % -60
thresh_hold_angle = wrapTo360(home_angle + bot_angle + 90)

home_angle = radtodeg(pi/2 - (atan2(-c1,-c2))); % -30
thresh_hold_angle = wrapTo360(home_angle + bot_angle + 90)

home_angle = radtodeg(pi/2 - (atan2(-1,0))); % 0
thresh_hold_angle = wrapTo360(home_angle + bot_angle + 90)

home_angle = radtodeg(pi/2 - (atan2(-c1,c2))); % 30
thresh_hold_angle = wrapTo360(home_angle + bot_angle + 90)

home_angle = radtodeg(pi/2 - (atan2(-c2,c1))); % 60
thresh_hold_angle = wrapTo360(home_angle + bot_angle + 90)

% all correct answers. This works and it returns how much the robot needs to turn to right to point to home

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Turn left or Turn right

%Angle_to_turn_right = thresh_hold_angle
%Angle_to_turn_left = 2pi - thresh_hold_angle
