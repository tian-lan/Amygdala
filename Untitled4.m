load('Good.mat');
load('Bad.mat');
load('Black.mat');
load('White.mat');

Order1 = randperm(6,5); % Black
Order2 = randperm(6,5); % White
Order3 = randperm(16,5); % Good
Order4 = randperm(16,5); % Bad

for i = 1:5
    Item_P3(4*(i-1)+1,:) = Black(Order1(i),:);
    Item_P3(4*(i-1)+2,:) = Good(Order3(i),:);
    Item_P3(4*(i-1)+3,:) = White(Order2(i),:);
    Item_P3(4*(i-1)+4,:) = Bad(Order4(i),:);
end

for i = 1:5    % 5 groups, 4 each
    Order_Odd = [4*(i-1)+1 4*(i-1)+3];
    Order_Odd = Order_Odd(randperm(size(Order_Odd,2)));
    Order_Even = [4*(i-1)+2 4*(i-1)+4];
    Order_Even = Order_Even(randperm(size(Order_Even,2)));
    Item_P3_Shuffle(4*(i-1)+1,:) = Item_P3(Order_Odd(1),:);
    Item_P3_Shuffle(4*(i-1)+2,:) = Item_P3(Order_Even(1),:);
    Item_P3_Shuffle(4*(i-1)+3,:) = Item_P3(Order_Odd(2),:);
    Item_P3_Shuffle(4*(i-1)+4,:) = Item_P3(Order_Even(2),:);
end
