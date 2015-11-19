function new_food_poses = food_memory_correction(food_poses, new_food)
% Removes two closeset food positions in the list

new_food_poses = [];

for n = 1:size(food_poses,1)
    temp = [food_poses(n,:); new_food];
    distance = pdist(temp,'euclidean');
    if distance > 25
        new_food_poses = [new_food_poses; food_poses(n,:)];
    end
    
end

new_food_poses = [new_food_poses; new_food];

end