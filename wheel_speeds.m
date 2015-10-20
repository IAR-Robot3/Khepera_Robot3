function [left_v, right_v, new_count_left, new_count_right] = wheel_speeds(s, old_count_left, old_count_right, time_step)
%calculates the left speed and right speed

counts = readCounts(s);

new_count_left = counts(1);
new_count_right = counts(2);

left_v = (counts(1)-old_count_left)*0.15;
right_v = (counts(2)-old_count_right)*0.15;
