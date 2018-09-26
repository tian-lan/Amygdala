BW_P1 = BW_P1(randperm(size(BW_P1,1)),:);
GB_P2 = GB_P2(randperm(size(GB_P2,1)),:);
Item_P3 = [BW_P1;GB_P2];
for i = 1:10
        Item_P3{2*i-1,1} = BW_P1{i,1};
        Item_P3{2*i-1,2} = BW_P1{i,2};
        Item_P3{2*i-1,3} = BW_P1{i,3};
        Item_P3{2*i,1} = GB_P2{i,1};      
        Item_P3{2*i,2} = GB_P2{i,2};
        Item_P3{2*i,3} = GB_P2{i,3};
        
end

Order1 = randperm(size(Black,1));
Order2 = randperm(size(White,1));
Order3 = randperm(size(Good,1));
Order4 = randperm(size(Bad,1));
for i = 1:4:17
    if Item_P3{1,3} == 'B'   % if 1st is B
        Item_P3_Shuffle{i,1} = Black(Order1((i+3)/4),1);
        Item_P3_Shuffle{i,2} = Black(Order1((i+3)/4),2);
        Item_P3_Shuffle{i,3} = Black(Order1((i+3)/4),3);
        
        Item_P3_Shuffle{i+2,1} = White(Order2((i+3)/4),1);
        Item_P3_Shuffle{i+2,2} = White(Order2((i+3)/4),2);
        Item_P3_Shuffle{i+2,3} = White(Order2((i+3)/4),3);
        
       if strcmp(Item_P3{2,3},'Good') % if 2nd is Good
        Item_P3_Shuffle{i+1,1} = Good(Order3((i+3)/4),1);
        Item_P3_Shuffle{i+1,2} = Good(Order3((i+3)/4),2);
        Item_P3_Shuffle{i+1,3} = Good(Order3((i+3)/4),3);
        
        Item_P3_Shuffle{i+3,1} = Bad(Order4((i+3)/4),1);
        Item_P3_Shuffle{i+3,2} = Bad(Order4((i+3)/4),2);
        Item_P3_Shuffle{i+3,3} = Bad(Order4((i+3)/4),3);
       
       elseif strcmp(Item_P3{2,3},'Bad') % if 2nd is Bad
        Item_P3_Shuffle{i+1,1} = Bad(Order4((i+3)/4),1);
        Item_P3_Shuffle{i+1,2} = Bad(Order4((i+3)/4),2);
        Item_P3_Shuffle{i+1,3} = Bad(Order4((i+3)/4),3);
        
        Item_P3_Shuffle{i+3,1} = Good(Order3((i+3)/4),1);
        Item_P3_Shuffle{i+3,2} = Good(Order3((i+3)/4),2);
        Item_P3_Shuffle{i+3,3} = Good(Order3((i+3)/4),3);
        
       end
  
            
        
    elseif Item_P3{1,3} == 'W'   % if 1st is W
        Item_P3_Shuffle{i,1} = White(Order1((i+3)/4),1);
        Item_P3_Shuffle{i,2} = White(Order1((i+3)/4),2);
        Item_P3_Shuffle{i,3} = White(Order1((i+3)/4),3);
        
        Item_P3_Shuffle{i+2,1} = Black(Order2((i+3)/4),1);
        Item_P3_Shuffle{i+2,2} = Black(Order2((i+3)/4),2);
        Item_P3_Shuffle{i+2,3} = Black(Order2((i+3)/4),3);
        
        if strcmp(Item_P3{2,3},'Good') % if 2nd is Good
        Item_P3_Shuffle{i+1,1} = Good(Order3((i+3)/4),1);
        Item_P3_Shuffle{i+1,2} = Good(Order3((i+3)/4),2);
        Item_P3_Shuffle{i+1,3} = Good(Order3((i+3)/4),3);
        
        Item_P3_Shuffle{i+3,1} = Bad(Order4((i+3)/4),1);
        Item_P3_Shuffle{i+3,2} = Bad(Order4((i+3)/4),2);
        Item_P3_Shuffle{i+3,3} = Bad(Order4((i+3)/4),3);
       
       elseif strcmp(Item_P3{2,3},'Bad') % if 2nd is Bad
        Item_P3_Shuffle{i+1,1} = Bad(Order4((i+3)/4),1);
        Item_P3_Shuffle{i+1,2} = Bad(Order4((i+3)/4),2);
        Item_P3_Shuffle{i+1,3} = Bad(Order4((i+3)/4),3);
        
        Item_P3_Shuffle{i+3,1} = Good(Order3((i+3)/4),1);
        Item_P3_Shuffle{i+3,2} = Good(Order3((i+3)/4),2);
        Item_P3_Shuffle{i+3,3} = Good(Order3((i+3)/4),3);
        
       end

        
    end
end

for i = 1:5    % 5 groups, 4 each
    Order_Odd = [4*(i-1)+1 4*(i-1)+3];
    Order_Odd = Order_Odd(randperm(size(Order_Odd,2)));
    Order_Even = [4*(i-1)+2 4*(i-1)+4];
    Order_Even = Order_Even(randperm(size(Order_Even,2)));
    Item_P3_Shuffle(4*(i-1)+1,:) = Item_P3_Shuffle(Order_Odd(1),:);
    Item_P3_Shuffle(4*(i-1)+2,:) = Item_P3_Shuffle(Order_Even(1),:);
    Item_P3_Shuffle(4*(i-1)+3,:) = Item_P3_Shuffle(Order_Odd(2),:);
    Item_P3_Shuffle(4*(i-1)+4,:) = Item_P3_Shuffle(Order_Even(2),:);
end