clear all
lam = 1.4; mu = 0.9; v = 0.3;
cap = 5;%capacity
coordinate = xlsread('data15points.xls');%coordinate of cities, n by 2 matrix
cust = coordinate(4:18,6:8);
n_cust = length(cust(:,1));
dpt_ind = length(cust(:,1))+1;%depot index
% coordinate = xlsread('data150cities.xls');%coordinate of cities, n by 2 matrix
% cust = [coordinate(1:150,2:3) ones(150,1)];


%step 1.1
p0k = weber(cust);%solve weber problem

%plot the solution of weber problem
figure(1)
plot(p0k(1,1),p0k(1,2),'or')
hold on
for i =1:length(cust(:,1))
    linex = cust(i,1);
    liney = cust(i,2);
    plot(linex,liney,'xb');
    hold on
    if i==1
        legend('depot','customer')
    end
end
title('Solution of Weber Problem')
xlabel('xcoordinate')
ylabel('ycoordinate')


%Spawning phase (ellipsoid generation)

rx = std(cust(1,:));
ry = std(cust(2,:));
xcp = p0k(1,1);
ycp = p0k(1,2);
k = 1;
N = 1000;
figure(2)
while k<=N
    alpha = rand(1);
    theta = 2*pi/N*(k-1)+2*pi/N*alpha;
    xk = xcp + rx*alpha*sin(theta);
    yk = ycp + ry*alpha*cos(theta);
    k = k+1;
    plot(xk,yk,'o')
    hold on
end
title('Spawning Phase')
xlabel('xcoordinate')
ylabel('ycoordinate')
hold off


%Routing phase 
[route,cost_route,M]= simanl(p0k,cust,cap,dpt_ind);%solved by simulated annealing

%%show animation
% figure(3)
% xlim([0 1])
% ylim([0 1])
% movie(M,5)

%plot solution
custpt1 = [cust;p0k(1,:) 0];
figure(4)
%colorstr = ['b' 'y' 'm' 'r' 'g'  'c' 'w' 'k'];
colorstr = jet(10);
p1 = plot(p0k(1,1),p0k(1,2),'^b','linewidth',8);
hold on
k = 1;
    for i = 1:length(route)-1
        linex = [custpt1(route(i),1) custpt1(route(i+1),1)];
        liney = [custpt1(route(i),2) custpt1(route(i+1),2)];
        p2 = plot(linex,liney,'--*','Color',colorstr(k,:));%%number of vehicle is
%    large
        %plot(linex,liney,'-*','Color',colorstr(k));
        hold on
        if route(i+1)==dpt_ind
        k = k+1;
        end
        pause(0.01)
    end
title('Purification Phase')
%hold off;

%purification phase
dpt_loc = find(route(:)==dpt_ind);
stem = [route(2) route(dpt_loc(end)-1)];
for i =2:(length(dpt_loc)-1)
    stem = [stem(1:end-1) route(dpt_loc(i)-1) route(dpt_loc(i)+1) stem(end)];
end

stem_loc = cust(stem,:);
p1k = weber(stem_loc);
[route2,cost_route2]= simanl(p1k,cust,cap,dpt_ind);

custpt2 = [cust;p1k(1,:) 0];
p3 = plot(p1k(1,1),p1k(1,2),'or','linewidth',8);
hold on
colorstr = autumn(10);
k = 7;
    for i = 1:length(route2)-1
        linex = [custpt2(route2(i),1) custpt2(route2(i+1),1)];
        liney = [custpt2(route2(i),2) custpt2(route2(i+1),2)];
        p4 = plot(linex,liney,'-*','Color',colorstr(k,:));%%number of vehicle is
%    large
        %plot(linex,liney,'-*','Color',colorstr(k));
        hold on
        if route2(i+1)==dpt_ind
        k = k+1;
        end
        pause(0.01)
    end
legend([p1 p2 p3 p4],'original depot','original route','relocated depot','revised route')
hold off;
