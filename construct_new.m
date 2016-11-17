function newroute = construct_new(route,dpt_ind,cust,cap)
choice =  randi([1,3],1);
while(1)
    switch choice
    case 1
        newroute = crossover(route,dpt_ind,cust,cap);
        break
    case 2
        newroute = relocation(route,dpt_ind,cust,cap);
        break
    case 3
        newroute = exchange(route,dpt_ind,cust,cap);
        break
    end
end

end


function newroute = crossover(route,dpt_ind,cust,cap)
    route(route==dpt_ind)=[];
    while 1
        cand = randsample(length(route),2);
        cand1 = cand(1,1);
        cand2 = cand(2,1);
        newroute = route;
        newroute([cand1 cand2]) = route([cand2 cand1]);
        %%%%capacity check
        weight = 0;
        n_veh = 0;
        i = 0;
        len = inf;
        while i < len
            i = i+1;
            weight = weight + cust(newroute(i),3);
            if weight>cap
                newroute = [newroute(1:(i-1)) dpt_ind newroute(i:end)];
                weight = 0;
                n_veh = n_veh + 1;
            end
            len = length(newroute);
        end
        newroute = [dpt_ind newroute dpt_ind];
        %%%%
        for j = 1:(length(newroute)-1)
                 if newroute(j) == newroute(j+1)
                     swp_ind = randi([2,10],1);
                     swp = newroute(swp_ind);
                     newroute(swp_ind) = newroute(j);
                     newroute(j) = swp;
                 end
        end
        %%adjacent node check
        if newroute(1)~=dpt_ind||newroute(length(newroute))~=dpt_ind
                index = find(newroute(:)==dpt_ind);
                ed = index(end);
                ft = index(1);
                newroute(ft) = newroute(1);
                newroute(ed) = newroute(end);
                newroute(1) = dpt_ind;
                newroute(end) = dpt_ind;
        end
        if(isfeasible(newroute,dpt_ind,cust,cap)) 
            break; 
        end
    end
end



function newroute = relocation(route,dpt_ind,cust,cap)
    route(route==dpt_ind)=[];
    while 1
        cand = randsample(length(route),2);
        cand1 = cand(1,1);
        cand2 = cand(2,1);
        cand1 = min([cand1, cand2]);
        cand2 = max([cand1, cand2]);
        if cand2~=cand1
            newroute = [route(1:cand1-1) route(cand1+1:cand2) route(cand1) route(cand2+1:length(route))];
            for j = 1:(length(newroute)-1)
                     if newroute(j) == newroute(j+1)
                         swp_ind = randi([2,10],1);
                         swp = newroute(swp_ind);
                         newroute(swp_ind) = newroute(j);
                         newroute(j) = swp;
                     end
            end
        %%%%%% capacity check   
            weight = 0;
            n_veh = 0;
            i = 0;
            len = inf;
            while i < len
                i = i+1;
                weight = weight + cust(newroute(i),3);
                if weight>cap
                    newroute = [newroute(1:(i-1)) dpt_ind newroute(i:end)];
                    weight = 0;
                    n_veh = n_veh + 1;
                end
                len = length(newroute);
            end
            newroute = [dpt_ind newroute dpt_ind];
        %%%%%%%    
            %%adjacent node check    
            if newroute(1)~=dpt_ind||newroute(length(newroute))~=dpt_ind
                    index = find(newroute(:)==dpt_ind);
                    ed = index(end);
                    ft = index(1);
                    newroute(ft) = newroute(1);
                    newroute(ed) = newroute(end);
                    newroute(1) = dpt_ind;
                    newroute(end) = dpt_ind;
            end
            if (isfeasible(newroute,dpt_ind,cust,cap))
                break; 
            end
        end
    end
end

function newroute = exchange(route,dpt_ind,cust,cap)
    newroute = route;
    route(route==dpt_ind)=[];
    while 1
        cand = randsample(length(route),2);
        cand1 = cand(1,1);
        cand2 = cand(2,1);
        cand1 = min([cand1, cand2]);
        cand2 = max([cand1, cand2]);
        if cand1~=cand2
            newroute = [route(1:cand1) route(cand2) fliplr(route(cand1+1:cand2-1)) route(cand2+1:length(route))];

            %%%%%%    capacity check
            weight = 0;
            n_veh = 0;
            i = 0;
            len = inf;
            while i < len
                i = i+1;
                weight = weight + cust(newroute(i),3);
                if weight>cap
                    newroute = [newroute(1:(i-1)) dpt_ind newroute(i:end)];
                    weight = 0;
                    n_veh = n_veh + 1;
                end
                len = length(newroute);
            end
            newroute = [dpt_ind newroute dpt_ind];

            if(isfeasible(newroute,dpt_ind,cust,cap)) 
                break; 
            end
        end
    end
end
