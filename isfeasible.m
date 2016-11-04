%%check whether the route is feasible
function flag = isfeasible(route,dpt_ind,cust,cap)
%dpt_ind -- depot index
%cap -- vehicle capacity
%cust -- [1-coord, 2-coord, 3-density]

 %flag=1: feasible, 0 otherwise      
        flag = 1;
        %%adajcent node check
        for j = 1:(length(route)-1)
             if route(j) == route(j+1)
                 flag = 0;
            end
        end
        weight = 0;
        %%capacity check
        for i = 1:length(route)
            weight = weight + cust(route(i),3);
            if route(i) == dpt_ind
                 weight = 0;
            elseif weight>cap+0.001
                  flag = 0;
            end
        end
end