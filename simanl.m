function [route,cost_orig]= simanl(pk,cust,cap,dpt_ind)
%dpt_ind -- depot index
%cap -- vehicle capacity
%cust -- [1-coord, 2-coord, 3-density]
%pk -- depot location (first row)

% clear all
% close all
% clc
T0 = 1;%initial temperature
alpha = 0.9;%rate of annealing
Tstop = 0.1;%stop temperature
iter = 300;%number of iterations
%colorstr = jet(10)
colorstr = ['y' 'm' 'b' 'g' 'r' 'c' 'w' 'k'];


%%%initial route generation%
%%capacity option
n_cust = length(cust(:,1));%number of customer
cust = [cust;pk(1,:) 1];
sol_in = randperm(n_cust);%initial solution
weight = 0;
n_veh = 0;
for i = 1:length(sol_in)
    weight = weight + cust(sol_in(i),3);
    if weight>cap%when weight of current veh is larger than capacity
        sol_in = [sol_in(1:i) dpt_ind sol_in(i+1:end)];
        weight = 0;
        n_veh = n_veh + 1;
    end
end
sol_in = [dpt_ind sol_in dpt_ind];%feasible initial solution


%%uncapacited option
% for i = 1:(n_veh-1)%insert n depots
%     insert = randi([2,n_cust-1]);
%     while sol_in(insert)==dpt_ind || sol_in(insert+1)==dpt_ind%(depots can't be adjacent to each other)
%     insert = randi([2,n_cust-1]);
%     end
%     sol_in = [sol_in(1:(insert)) dpt_ind sol_in((insert+1):length(sol_in))];
% end
%sol_in = [dpt_ind sol_in dpt_ind];%feasible initial solution

%%plot initial vrp solution
% figure(2)
% plot(p0k(1,1),p0k(1,2),'^r')
% hold on
% k = 1;
% for i = 1:length(sol_in)-1
%     pause(0.01)
%     linex = [cust(sol_in(i),1) cust(sol_in(i+1),1)];
%     liney = [cust(sol_in(i),2) cust(sol_in(i+1),2)];
% %    plot(linex,liney,'-*','Color',colorstr(k,:));
%     plot(linex,liney,'-*','Color',colorstr(k));
%     hold on
%     if sol_in(i+1)==dpt_ind
%     k = k+1;
%     end
% 
% end
% title('Initial VRP')




%simulated annealing
T = T0;%initial temperature
route = sol_in;
cost_orig = cost(route,cust);%cost
mv_cnt = 1;
while T>Tstop
    for i = 1:iter
        route_new = construct_new(route,dpt_ind,cust,cap);
        cost_new = cost(route_new,cust);
        delta = cost_new - cost_orig;
        if delta<0
            route = route_new;
            cost_orig = cost_new;
            plt = 0;%plot or not
        elseif exp(-delta/T)>rand
            route = route_new;
            cost_orig = cost_new;
            plt = 0;
        else
            plt = 0;
        end
    end

T = T*alpha;%annealing
if plt ==1
    figure(3)
    plot(pk(1,1),pk(1,2),'^r')
    hold on
    k = 1;
        for i = 1:length(route)-1
            linex = [cust(route(i),1) cust(route(i+1),1)];
            liney = [cust(route(i),2) cust(route(i+1),2)];
%    plot(linex,liney,'-*','Color',colorstr(k,:));%%number of vehicle is
%    large
            plot(linex,liney,'-*','Color',colorstr(k));
            M(mv_cnt) = getframe;
            mv_cnt = mv_cnt+1;
            hold on
            if route(i+1)==dpt_ind
            k = k+1;
            end
%             pause(0.01)
        end
    hold off;
end
end



         
