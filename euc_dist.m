function dis=euc_dist(pt,cst)%calculate euclidean distance
    dis = ((pt(1)-cst(1))^2+(pt(2)-cst(2))^2)^0.5;
    if dis == 0
        dis = 0.001;
    end
end