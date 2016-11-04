%solve weber problem
%clear all
%input:data col 1--x coordinate, col 2--y coordinate, col 3--weight
%output: p0k--list of locations while solving weber problem, the first one
%represent the final solution
function p0k=weber(data)
cust = data;
n_cust = length(cust(:,1));%total number of customer
p0k = [mean(cust(:,1)),mean(cust(:,2))];%initial location
eps = inf;
while eps>=1e-5%tolerance
    numerator_x = 0;
    denumerator_x = 0;
    numerator_y = 0;
    denumerator_y = 0;
    for j = 1:n_cust
    numerator_x = numerator_x + cust(j,1)*cust(j,3)/euc_dist(p0k(1,:),[cust(j,1),cust(j,2)]);
    denumerator_x = denumerator_x + cust(j,3)/euc_dist(p0k(1,:),[cust(j,1),cust(j,2)]);
    numerator_y = numerator_y + cust(j,2)*cust(j,3)/euc_dist(p0k(1,:),[cust(j,1),cust(j,2)]);
    denumerator_y = denumerator_y + cust(j,3)/euc_dist(p0k(1,:),[cust(j,1),cust(j,2)]);
    end
    x0k = numerator_x/denumerator_x;
    y0k = numerator_y/denumerator_y;
    eps = euc_dist(p0k(1,:),[x0k,y0k]);
    p0k = [x0k, y0k;p0k];
end
end

