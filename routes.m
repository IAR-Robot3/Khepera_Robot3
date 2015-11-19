function new_route = routes(positions)
% It receives a list of positions (the way from one point to another), and
% it will give a node map of that route

new_route = [];

for n = 1:size(positions, 1);
   
    if mod(n,7) == 0
       new_route = [new_route; positions(n,:)];
       hold on
       plot(positions(n,1),positions(n,2),'--gs',...   % Draw path
        'LineWidth',3,...
        'MarkerSize',10,...
        'MarkerEdgeColor','y')
    end
    
end    

end