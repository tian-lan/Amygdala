clear i aa
Not_in_row = true;
BW_P1 = BW_P1(randperm(size(BW_P1,1)),:);


while Not_in_row
for i = 1:size(BW_P1,1) - 2
    
        if ~(BW_P1{i,3} == BW_P1{i+1,3}&&BW_P1{i+1,3} == BW_P1{i+2,3})    % If not 3 in a row
            aa(i) = 0;
        else
            aa(i) = 1;
        end
     
end
    if sum(aa) == 0
        Not_in_row = false;
        
    else
        BW_P1 = BW_P1(randperm(size(BW_P1,1)),:);
       
    end
end
