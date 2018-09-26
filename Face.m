close all
clear all
clc

commandwindow

load('Good.mat');
load('Bad.mat');
load('Black.mat');
load('White.mat');


% Screen setup
black = [0 0 0];
grey = [128 128 128];
white = [255 255 255];


 Screen('Preference', 'SkipSyncTests', 0);
 Screen('Preference', 'VBLTimestampingMode', 4);
 Screen('Preference', 'ConserveVRAM', 64);
 Screen('Preference', 'VisualDebugLevel', 4);


[w,winRect]=Screen('OpenWindow',0, grey);
Screen('TextSize', w, 25);
Screen('TextFont',w,1);
Screen('TextStyle',w,1);

Time_OpenWindow = GetSecs;
% Send_TRIGGER(daqInd, 64);  %%%%%%%%%
% Send_TRIGGER(daqInd, 128);

% HideCursor;



cross = imread('cross.png');
cross(cross==0)=128;
input = {};

% % %% Load images
% % 
% % for i = 1:6
% %     Black{i,1} = imread(strcat('B', num2str(i), '.jpg'));
% %     Black{i,2} = i;
% %     Black{i,3} = 'B';
% %     
% %     White{i,1} = imread(strcat('W', num2str(i), '.jpg'));
% %     White{i,2} = i;
% %     White{i,3} = 'W';
% % end


% BW list
Black_P1 = Black([randperm(6) randperm(6,4)],:);

White_P1 = White([randperm(6) randperm(6,4)],:);

BW_P1 = [Black_P1;White_P1];

Not_in_row = true;
BW_P1 = BW_P1(randperm(size(BW_P1,1)),:);   % Shuffle


% Make sure no 3 same in a row
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




message_black1=[ '\n'...
    'Press "E" for \n '...
    '\n'...
    'Black People\n'...
    '\n'];

message_white1=[ '\n'...
    'Press "I" for \n '...
    '\n'...
    'White People\n'...
    '\n'];

message_ins1=[ '\n'...
            'Part 1 of 7 \n'...
            '\n'...
            '\n'...
            'Put a left finger on the E key for items that belong to category Black People.\n'...
            '\n'...
            'Put a right finger on the I key for items that belong to category White People.\n'...
            '\n'...
            'Items will appear one at a time.\n'...
            '\n'...
            '\n'...
            'If you make a mistake, a red cross mark will appear. Press the correct key to continue.\n'...
            '\n'...
            'Go as fast as you can while being accurate.\n'...
            '\n'...
            '\n'...
            '\n'...
            'Press the space bar when you are ready to start.\n'];
        
        DrawFormattedText(w, message_black1, 0.05*winRect(3), 0.05*winRect(4), white) ;
        DrawFormattedText(w, message_white1, 0.8* winRect(3), 0.05*winRect(4), white) ;
        DrawFormattedText(w, message_ins1, 'center', 'center' , white) ;
        Screen('Flip', w) ;
        
        WaitSecs(0.1);
        % KbWait;
        
        
        press = true;
        
        while press
            [~, keyCode, ~] = KbWait;
            pressedKey = KbName(keyCode) ;
            if  strcmpi(pressedKey, 'space') == 1
                press = false;
            end
            
        end
        
        
%% P1
input = {};

for i = 1:20
    
    Num_Press_P1 = 1;
    
    DrawFormattedText(w, message_black1, 0.05*winRect(3), 0.05*winRect(4), white) ;
    DrawFormattedText(w, message_white1, 0.8* winRect(3), 0.05*winRect(4), white) ;
    Screen('PutImage',w , BW_P1{i,1}, [0.45* winRect(3) 0.45* winRect(4) 0.45* winRect(3)+1.5*size(BW_P1{1,1},1) 0.9* 0.45*winRect(4)+1.5*size(BW_P1{1,1},2)]);
    Screen('Flip', w) ;
    
    Dis_Time(i) = GetSecs;
    
    press1 = true;
    
    while press1
        [~, keyCode, ~] = KbPressWait;
        
        %                 Send_TRIGGER(daqInd, 8)   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                 Send_TRIGGER(daqInd, 128)
        %                 Eyelink('Message', 'Button Pressed');
        
        pressedKey = KbName(keyCode) ;
        
        Press_Time(i) = GetSecs;
        RT(i) = Press_Time(i) - Dis_Time(i);
        
        EI = true;
        while EI
            
            if strcmpi(pressedKey, 'i') == 1
                input = 'W';
                EI = false;
                
            elseif strcmpi(pressedKey, 'e') == 1
                input = 'B';
                EI = false;
            else
                EI = false;
                input = [];
            end
            
        end
        
        TF = true;
        
        while TF
            
            if isempty(input)
                break
            end
            
            if strcmpi(BW_P1{i,3},input) == 1
                TF = false;
                press1 = false;
                Results.P1{4,i} = Num_Press_P1;
                
            else
                DrawFormattedText(w, message_black1, 0.05*winRect(3), 0.05*winRect(4), white) ;
                DrawFormattedText(w, message_white1, 0.8* winRect(3), 0.05*winRect(4), white) ;
                Screen('PutImage',w , BW_P1{i,1}, [0.45* winRect(3) 0.45* winRect(4) 0.45* winRect(3)+1.5*size(BW_P1{1,1},1) 0.9* 0.45*winRect(4)+1.5*size(BW_P1{1,1},2)]);
                Screen('PutImage', w, cross, [0.5* winRect(3) 0.9* winRect(4) 0.5* winRect(3)+50 0.9* winRect(4)+50]);
                Screen('Flip', w) ;
                Num_Press_P1 = Num_Press_P1 + 1;
                Results.P1{4,i} = Num_Press_P1;
                
                TF = false;
                
            end   % if correct
            
        end   % while TF
        
    end       % while press
                                                             Results.P1{1,i} = [BW_P1{i,3},num2str(BW_P1{i,2})];
                                                             Results.P1{2,i} = Dis_Time(i);
                                                             Results.P1{3,i} = RT(i);
                                                             

    
    WaitSecs(0.2);
end


%% P2
input = {};

Good_P2 = Good(randperm(size(Good,1),10),:);
Bad_P2 = Bad(randperm(size(Bad,1),10),:);
GB_P2 = [Good_P2;Bad_P2];
GB_P2 = GB_P2(randperm(size(GB_P2,1)),:);

% % %  for i = 1:size(Good,1)
% % %         GB_P2_Shuffle{2*i-1,1} = Good_P2{i,1};
% % %         GB_P2_Shuffle{2*i-1,2} = Good_P2{i,2};
% % %         GB_P2_Shuffle{2*i-1,3} = Good_P2{i,3};
% % %         GB_P2_Shuffle{2*i,1} = Bad_P2{i,1};
% % %         GB_P2_Shuffle{2*i,2} = Bad_P2{i,2};
% % %         GB_P2_Shuffle{2*i,3} = Bad_P2{i,3};
% % %  end
    
 message_good2=[ '\n'...
    'Press "E" for \n '...
    '\n'...
    '     Good\n'...
    '\n'];

message_bad2=[ '\n'...
    'Press "I" for \n '...
    '\n'...
    '      Bad\n'...
    '\n'];

message_ins2=[ '\n'...
            'Part 2 of 7 \n'...
            '\n'...
            '\n'...
            'Put a left finger on the E key for items that belong to category Good.\n'...
            '\n'...
            'Put a right finger on the I key for items that belong to category Bad.\n'...
            '\n'...
            'Items will appear one at a time.\n'...
            '\n'...
            '\n'...
            'If you make a mistake, a red cross mark will appear. Press the correct key to continue.\n'...
            '\n'...
            'Go as fast as you can while being accurate.\n'...
            '\n'...
            '\n'...
            '\n'...
            'Press the space bar when you are ready to start.\n'];
        

        
        DrawFormattedText(w, message_good2, 0.05*winRect(3), 0.05*winRect(4), white) ;
        DrawFormattedText(w, message_bad2, 0.8* winRect(3), 0.05*winRect(4), white) ;
        DrawFormattedText(w, message_ins2, 'center', 'center' , white) ;
        Screen('Flip', w) ;
        
        WaitSecs(0.1);
        % KbWait;
        
        
        press = true;
        
        while press
            [~, keyCode, ~] = KbWait;
            pressedKey = KbName(keyCode) ;
            if  strcmpi(pressedKey, 'space') == 1
                press = false;
            end
            
        end
        
        
%%%%%% Make sure no 3 same in a row
Not_in_row = true;

while Not_in_row
for i = 1:size(GB_P2,1) - 2
    
        if ~(strcmp(GB_P2{i,3},GB_P2{i+1,3})&&strcmp(GB_P2{i+1,3},GB_P2{i+2,3}))    % If not 3 in a row
            aa(i) = 0;
        else
            aa(i) = 1;
        end
     
end
    if sum(aa) == 0
        Not_in_row = false;
        
    else
        GB_P2 = GB_P2(randperm(size(GB_P2,1)),:);
       
    end
end

for i = 1:20
    
    Num_Press_P2 = 1;
    
    DrawFormattedText(w, message_good2, 0.05*winRect(3), 0.05*winRect(4), white) ;
    DrawFormattedText(w, message_bad2, 0.8* winRect(3), 0.05*winRect(4), white) ;
    DrawFormattedText(w, GB_P2{i,1}, 'center', 'center', white) ;    
    Screen('Flip', w) ;
    
    Dis_Time(i) = GetSecs;
    
    press2 = true;
    
    while press2
        [~, keyCode, ~] = KbPressWait;
        
        Press_Time(i) = GetSecs;
        RT(i) = Press_Time(i) - Dis_Time(i);
        
% %                         Send_TRIGGER(daqInd, 8)   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                         Send_TRIGGER(daqInd, 128)
% %                         Eyelink('Message', 'Button Pressed');
        
        pressedKey = KbName(keyCode) ; 
        
        EI = true;
        while EI
            
            if strcmpi(pressedKey, 'i') == 1
                input = 'Bad';
                EI = false;
                
            elseif strcmpi(pressedKey, 'e') == 1
                input = 'Good';
                EI = false;
            else
                EI = false;
                input = [];
            end
            
        end
        
        TF = true;
        
        while TF
            
            if isempty(input)
                break
            end
            
            if  strcmpi(GB_P2{i,3},input) == 1
                TF = false;
                press2 = false;
                Results.P2{4,i} = Num_Press_P2;
                
            else
                DrawFormattedText(w, message_good2, 0.05*winRect(3), 0.05*winRect(4), white) ;
                DrawFormattedText(w, message_bad2, 0.8* winRect(3), 0.05*winRect(4), white) ;
                DrawFormattedText(w, GB_P2{i,1}, 'center', 'center', white) ;    
                Screen('PutImage', w, cross, [0.5* winRect(3) 0.9* winRect(4) 0.5* winRect(3)+50 0.9* winRect(4)+50]);
                Screen('Flip', w) ;
                Num_Press_P2 = Num_Press_P2 + 1;
                Results.P2{4,i} = Num_Press_P2;
                
                TF = false;
                
            end   % if correct
            
        end   % while TF
        
    end       % while press
                                                             Results.P2{1,i} = GB_P2{i,1};
                                                             Results.P2{2,i} = Dis_Time(i);
                                                             Results.P2{3,i} = RT(i);
                                                             Results.P2{5,i} = GB_P2{i,2};
                                                             Results.P2{6,i} = GB_P2{i,3};
    WaitSecs(0.2);
end


%% P3
input = {};
% Shuffle list
Order1 = randperm(size(Black,1),5); % Black
Order2 = randperm(size(White,1),5); % White
Order3 = randperm(size(Good,1),5); % Good
Order4 = randperm(size(Bad,1),5); % Bad

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 message_P3L=[ '\n'...
    'Press "E" for \n '...
    '\n'...
    '      Bad\n'...
    '\n'...
    '       or\n'...
    '\n'...
    'Black People\n'...
    '\n'];

message_P3R=[ '\n'...
    'Press "I" for \n '...
    '\n'...
    '     Good\n'...
    '\n'...
    '       or\n'...
    '\n'...
    'White People\n'...
    '\n'];

message_ins3=[ '\n'...
            'Part 3 of 7 \n'...
            '\n'...
            '\n'...
            'Put a left finger on the E key for items that belong to category Bad or Black People.\n'...
            '\n'...
            'Put a right finger on the I key for items that belong to category Good or White People.\n'...
            '\n'...
            'Items will appear one at a time.\n'...
            '\n'...
            '\n'...
            'If you make a mistake, a red cross mark will appear. Press the correct key to continue.\n'...
            '\n'...
            'Go as fast as you can while being accurate.\n'...
            '\n'...
            '\n'...
            '\n'...
            'Press the space bar when you are ready to start.\n'];
        
        DrawFormattedText(w, message_P3L, 0.05*winRect(3), 0.05*winRect(4), white) ;
        DrawFormattedText(w, message_P3R, 0.8* winRect(3), 0.05*winRect(4), white) ;
        DrawFormattedText(w, message_ins3, 'center', 'center' , white) ;
        Screen('Flip', w) ;
        
        
        WaitSecs(0.1);
        % KbWait;
        
        
        press = true;
        
        while press
            [~, keyCode, ~] = KbPressWait;
                      
            pressedKey = KbName(keyCode) ;
            if  strcmpi(pressedKey, 'space') == 1
                press = false;
            end
            
        end
        
        
for i = 1:20
    
    Num_Press_P3 = 1;
    
    if  mod(i,2) == 1    % Odd numbers are images
    DrawFormattedText(w, message_P3L, 0.05*winRect(3), 0.05*winRect(4), white) ;
    DrawFormattedText(w, message_P3R, 0.8* winRect(3), 0.05*winRect(4), white) ;
    Screen('PutImage',w , Item_P3_Shuffle{i,1}, [0.45* winRect(3) 0.45* winRect(4) 0.45* winRect(3)+1.5*size(Item_P3_Shuffle{i,1},1) 0.9* 0.45*winRect(4)+1.5*size(Item_P3_Shuffle{i,1},2)]);    
    else
    DrawFormattedText(w, message_P3L, 0.05*winRect(3), 0.05*winRect(4), white) ;
    DrawFormattedText(w, message_P3R, 0.8* winRect(3), 0.05*winRect(4), white) ;
    DrawFormattedText(w, Item_P3_Shuffle{i,1}, 'center', 'center', white) ; 
    end
    
    Screen('Flip', w) ;
    
    Dis_Time(i) = GetSecs;
    
    press3 = true;
    
    while press3
        [~, keyCode, ~] = KbPressWait;
        
            Press_Time(i) = GetSecs;
            RT(i) = Press_Time(i) - Dis_Time(i); 
        
        %                 Send_TRIGGER(daqInd, 8)   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                 Send_TRIGGER(daqInd, 128)
        %                 Eyelink('Message', 'Button Pressed');
        
        pressedKey = KbName(keyCode) ;

        
        EI = true;
        while EI
            
            if strcmpi(pressedKey, 'i') == 1
                input{1,1} = 'Good';
                input{1,2} = 'W';
                EI = false;
                
            elseif strcmpi(pressedKey, 'e') == 1
                input{1,1} = 'Bad';
                input{1,2} = 'B';
                EI = false;
            else
                EI = false;
                input = [];
            end
            
        end
        
        TF = true;
        
        while TF
            
            if isempty(input)
                break
            end
            
            if  (strcmpi(Item_P3_Shuffle{i,3},input{1,1}) == 1)||(strcmpi(Item_P3_Shuffle{i,3},input{1,2}))
                TF = false;
                press3 = false;
                Results.P3{4,i} = Num_Press_P3;
                
            else
                if mod(i,2) == 1    % Odd numbers are images
                DrawFormattedText(w, message_P3L, 0.05*winRect(3), 0.05*winRect(4), white) ;
                DrawFormattedText(w, message_P3R, 0.8* winRect(3), 0.05*winRect(4), white) ;
                Screen('PutImage',w , Item_P3_Shuffle{i,1}, [0.45* winRect(3) 0.45* winRect(4) 0.45* winRect(3)+1.5*size(Item_P3_Shuffle{i,1},1) 0.9* 0.45*winRect(4)+1.5*size(Item_P3_Shuffle{i,1},2)]);  
                Screen('PutImage', w, cross, [0.5* winRect(3) 0.9* winRect(4) 0.5* winRect(3)+50 0.9* winRect(4)+50]);
                else      % Even numbers are words
                DrawFormattedText(w, message_P3L, 0.05*winRect(3), 0.05*winRect(4), white) ;
                DrawFormattedText(w, message_P3R, 0.8* winRect(3), 0.05*winRect(4), white) ;
                DrawFormattedText(w, Item_P3_Shuffle{i,1}, 'center', 'center', white) ; 
                Screen('PutImage', w, cross, [0.5* winRect(3) 0.9* winRect(4) 0.5* winRect(3)+50 0.9* winRect(4)+50]);
                end
                Screen('Flip', w) ;
                Num_Press_P3 = Num_Press_P3 + 1;
                Results.P3{4,i} = Num_Press_P3;
                
                TF = false;
                
            end   % if correct
            
        end   % while TF
        
    end       % while press
                                                                    
    WaitSecs(0.2);
end
                                                                    for i = 1:2:19
                                                                        Results.P3{1,i} = [Item_P3_Shuffle{i,3},num2str(Item_P3_Shuffle{i,2})];
                                                                        Results.P3{2,i} = Dis_Time(1,i);
                                                                        Results.P3{3,i} = RT(1,i);
                                                                    end
                                                                    for i = 2:2:20
                                                                        Results.P3{1,i} = Item_P3_Shuffle{i,1};
                                                                        Results.P3{2,i} = Dis_Time(1,i);
                                                                        Results.P3{3,i} = RT(1,i);
                                                                        Results.P3{5,i} = Item_P3_Shuffle{i,2};
                                                                        Results.P3{6,i} = Item_P3_Shuffle{i,3};
                                                                    end

%% P4
input = {};
% Shuffle list

Order1 = [randperm(size(Black,1)) randperm(size(Black,1),4)]; % Black
Order2 = [randperm(size(White,1)) randperm(size(White,1),4)]; % White
Order3 = randperm(size(Good,1),10); % Good
Order4 = randperm(size(Bad,1),10); % Bad

for i = 1:10
    Item_P4(4*(i-1)+1,:) = Black(Order1(i),:);
    Item_P4(4*(i-1)+2,:) = Good(Order3(i),:);
    Item_P4(4*(i-1)+3,:) = White(Order2(i),:);
    Item_P4(4*(i-1)+4,:) = Bad(Order4(i),:);
end

for i = 1:10    % 5 groups, 4 each
    Order_Odd = [4*(i-1)+1 4*(i-1)+3];
    Order_Odd = Order_Odd(randperm(size(Order_Odd,2)));
    Order_Even = [4*(i-1)+2 4*(i-1)+4];
    Order_Even = Order_Even(randperm(size(Order_Even,2)));
    Item_P4_Shuffle(4*(i-1)+1,:) = Item_P4(Order_Odd(1),:);
    Item_P4_Shuffle(4*(i-1)+2,:) = Item_P4(Order_Even(1),:);
    Item_P4_Shuffle(4*(i-1)+3,:) = Item_P4(Order_Odd(2),:);
    Item_P4_Shuffle(4*(i-1)+4,:) = Item_P4(Order_Even(2),:);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 message_P4L=[ '\n'...
    'Press "E" for \n '...
    '\n'...
    '      Bad\n'...
    '\n'...
    '       or\n'...
    '\n'...
    'Black People\n'...
    '\n'];

message_P4R=[ '\n'...
    'Press "I" for \n '...
    '\n'...
    '     Good\n'...
    '\n'...
    '       or\n'...
    '\n'...
    'White People\n'...
    '\n'];

message_ins4=[ '\n'...
            'Part 4 of 7 \n'...
            '\n'...
            '\n'...
            'Put a left finger on the E key for items that belong to category Bad or Black People.\n'...
            '\n'...
            'Put a right finger on the I key for items that belong to category Good or White People.\n'...
            '\n'...
            'Items will appear one at a time.\n'...
            '\n'...
            '\n'...
            'If you make a mistake, a red cross mark will appear. Press the correct key to continue.\n'...
            '\n'...
            'Go as fast as you can while being accurate.\n'...
            '\n'...
            '\n'...
            '\n'...
            'Press the space bar when you are ready to start.\n'];
        
        DrawFormattedText(w, message_P4L, 0.05*winRect(3), 0.05*winRect(4), white) ;
        DrawFormattedText(w, message_P4R, 0.8* winRect(3), 0.05*winRect(4), white) ;
        DrawFormattedText(w, message_ins4, 'center', 'center' , white) ;
        Screen('Flip', w) ;
        
        WaitSecs(0.1);
        % KbWait;
        
        
        press = true;
        
        while press
            [~, keyCode, ~] = KbWait;
            pressedKey = KbName(keyCode) ;
            if  strcmpi(pressedKey, 'space') == 1
                press = false;
            end
            
        end
        
for i = 1:40
    
    Num_Press_P4 = 1;
    
    if  mod(i,2) == 1    % Odd numbers are images
    DrawFormattedText(w, message_P4L, 0.05*winRect(3), 0.05*winRect(4), white) ;
    DrawFormattedText(w, message_P4R, 0.8* winRect(3), 0.05*winRect(4), white) ;
    Screen('PutImage',w , Item_P4_Shuffle{i,1}, [0.45* winRect(3) 0.45* winRect(4) 0.45* winRect(3)+1.5*size(Item_P4_Shuffle{i,1},1) 0.9* 0.45*winRect(4)+1.5*size(Item_P4_Shuffle{i,1},2)]);    
    else
    DrawFormattedText(w, message_P4L, 0.05*winRect(3), 0.05*winRect(4), white) ;
    DrawFormattedText(w, message_P4R, 0.8* winRect(3), 0.05*winRect(4), white) ;
    DrawFormattedText(w, Item_P4_Shuffle{i,1}, 'center', 'center', white) ; 
    end
    
    Screen('Flip', w) ;
    
    Dis_Time(i) = GetSecs;
    
    press4 = true;
    
    while press4
        [~, keyCode, ~] = KbPressWait;
        
        Press_Time(i) = GetSecs;
        RT(i) = Press_Time(i) - Dis_Time(i);
        %                 Send_TRIGGER(daqInd, 8)   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                 Send_TRIGGER(daqInd, 128)
        %                 Eyelink('Message', 'Button Pressed');
        
        pressedKey = KbName(keyCode) ;
  
        EI = true;
        while EI
            
            if strcmpi(pressedKey, 'i') == 1
                input{1,1} = 'Good';
                input{1,2} = 'W';
                EI = false;
                
            elseif strcmpi(pressedKey, 'e') == 1
                input{1,1} = 'Bad';
                input{1,2} = 'B';
                EI = false;
            else
                EI = false;
                input = [];
            end
            
        end
        
        TF = true;
        
        while TF
            
            if isempty(input)
                break
            end
            
            if  (strcmpi(Item_P4_Shuffle{i,3},input{1,1}) == 1)||(strcmpi(Item_P4_Shuffle{i,3},input{1,2}))
                TF = false;
                press4 = false;
                Results.P4{4,i} = Num_Press_P4;
                
            else
                if mod(i,2) == 1    % Odd numbers are images
                DrawFormattedText(w, message_P4L, 0.05*winRect(3), 0.05*winRect(4), white) ;
                DrawFormattedText(w, message_P4R, 0.8* winRect(3), 0.05*winRect(4), white) ;
                Screen('PutImage',w , Item_P4_Shuffle{i,1}, [0.45* winRect(3) 0.45* winRect(4) 0.45* winRect(3)+1.5*size(Item_P4_Shuffle{i,1},1) 0.9* 0.45*winRect(4)+1.5*size(Item_P4_Shuffle{i,1},2)]);  
                Screen('PutImage', w, cross, [0.5* winRect(3) 0.9* winRect(4) 0.5* winRect(3)+50 0.9* winRect(4)+50]);
                else      % Even numbers are words
                DrawFormattedText(w, message_P4L, 0.05*winRect(3), 0.05*winRect(4), white) ;
                DrawFormattedText(w, message_P4R, 0.8* winRect(3), 0.05*winRect(4), white) ;
                DrawFormattedText(w, Item_P4_Shuffle{i,1}, 'center', 'center', white) ; 
                Screen('PutImage', w, cross, [0.5* winRect(3) 0.9* winRect(4) 0.5* winRect(3)+50 0.9* winRect(4)+50]);
                end
                Screen('Flip', w) ;
                Num_Press_P4 = Num_Press_P4 + 1;
                Results.P4{4,i} = Num_Press_P4;
                
                TF = false;
                
            end   % if correct
            
        end   % while TF
        
    end       % while press
                                                                    
    WaitSecs(0.2);
                                                                  
end
                                                                    for i = 1:2:39
                                                                        Results.P4{1,i} = [Item_P4_Shuffle{i,3},num2str(Item_P4_Shuffle{i,2})];
                                                                        Results.P4{2,i} = Dis_Time(1,i);
                                                                        Results.P4{3,i} = RT(1,i);
                                                                    end
                                                                    for i = 2:2:40
                                                                        Results.P4{1,i} = Item_P4_Shuffle{i,1};
                                                                        Results.P4{2,i} = Dis_Time(1,i);
                                                                        Results.P4{3,i} = RT(1,i);
                                                                        Results.P4{5,i} = Item_P4_Shuffle{i,2};
                                                                        Results.P4{6,i} = Item_P4_Shuffle{i,3};
                                                                    end

%% P5
input = {};
% BW list
Black_P5 = Black([randperm(6) randperm(6) randperm(6,2)],:);

White_P5 = White([randperm(6) randperm(6) randperm(6,2)],:);

BW_P5 = [Black_P5;White_P5];

Not_in_row = true;
BW_P5 = BW_P5(randperm(size(BW_P5,1)),:);   % Shuffle


% Make sure no 3 same in a row
while Not_in_row
for i = 1:size(BW_P5,1) - 2
    
        if ~(BW_P5{i,3} == BW_P5{i+1,3}&&BW_P5{i+1,3} == BW_P5{i+2,3})    % If not 3 in a row
            aa(i) = 0;
        else
            aa(i) = 1;
        end
     
end
    if sum(aa) == 0
        Not_in_row = false;
        
    else
        BW_P5 = BW_P5(randperm(size(BW_P5,1)),:);
       
    end
end

message_white5=[ '\n'...
    'Press "E" for \n '...
    '\n'...
    'White People\n'...
    '\n'];

message_black5=[ '\n'...
    'Press "I" for \n '...
    '\n'...
    'Black People\n'...
    '\n'];


message_ins5=[ '\n'...
            'Part 5 of 7 \n'...
            '\n'...
            '\n'...
            'Put a left finger on the E key for items that belong to category White People.\n'...
            '\n'...
            'Put a right finger on the I key for items that belong to category Black People.\n'...
            '\n'...
            'Items will appear one at a time.\n'...
            '\n'...
            '\n'...
            'If you make a mistake, a red cross mark will appear. Press the correct key to continue.\n'...
            '\n'...
            'Go as fast as you can while being accurate.\n'...
            '\n'...
            '\n'...
            '\n'...
            'Press the space bar when you are ready to start.\n'];
        
        DrawFormattedText(w, message_white5, 0.05*winRect(3), 0.05*winRect(4), white) ;
        DrawFormattedText(w, message_black5, 0.8* winRect(3), 0.05*winRect(4), white) ;
        DrawFormattedText(w, message_ins5, 'center', 'center' , white) ;
        Screen('Flip', w) ;
        
        WaitSecs(0.1);
        % KbWait;
        
        
        press = true;
        
        while press
            [~, keyCode, ~] = KbWait;
            pressedKey = KbName(keyCode) ;
            if  strcmpi(pressedKey, 'space') == 1
                press = false;
            end
            
        end

for i = 1:28
    
    Num_Press_P5 = 1;
    
    DrawFormattedText(w, message_white5, 0.05*winRect(3), 0.05*winRect(4), white) ;
    DrawFormattedText(w, message_black5, 0.8* winRect(3), 0.05*winRect(4), white) ;
    Screen('PutImage',w , BW_P5{i,1}, [0.45* winRect(3) 0.45* winRect(4) 0.45* winRect(3)+1.5*size(BW_P5{1,1},1) 0.9* 0.45*winRect(4)+1.5*size(BW_P5{1,1},2)]);
    Screen('Flip', w) ;
    
    Dis_Time(i) = GetSecs;
    
    press5 = true;
    
    while press5
        [~, keyCode, ~] = KbPressWait;
        
        Press_Time(i) = GetSecs;
        RT(i) = Press_Time(i) - Dis_Time(i);
        
        %                 Send_TRIGGER(daqInd, 8)   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                 Send_TRIGGER(daqInd, 128)
        %                 Eyelink('Message', 'Button Pressed');
        
        pressedKey = KbName(keyCode) ;

        
        EI = true;
        while EI
            
            if strcmpi(pressedKey, 'i') == 1
                input = 'B';
                EI = false;
                
            elseif strcmpi(pressedKey, 'e') == 1
                input = 'W';
                EI = false;
            else
                EI = false;
                input = [];
            end
            
        end
        
        TF = true;
        
        while TF
            
            if isempty(input)
                break
            end
            
            if strcmpi(BW_P5{i,3},input) == 1
                TF = false;
                press5 = false;
                Results.P5{4,i} = Num_Press_P5;
                
            else
                DrawFormattedText(w, message_white5, 0.05*winRect(3), 0.05*winRect(4), white) ;
                DrawFormattedText(w, message_black5, 0.8* winRect(3), 0.05*winRect(4), white) ;
                Screen('PutImage',w , BW_P5{i,1}, [0.45* winRect(3) 0.45* winRect(4) 0.45* winRect(3)+1.5*size(BW_P5{1,1},1) 0.9* 0.45*winRect(4)+1.5*size(BW_P5{1,1},2)]);
                Screen('PutImage', w, cross, [0.5* winRect(3) 0.9* winRect(4) 0.5* winRect(3)+50 0.9* winRect(4)+50]);
                Screen('Flip', w) ;
                Num_Press_P5 = Num_Press_P5 + 1;
                Results.P5{4,i} = Num_Press_P5;
                
                TF = false;
                
            end   % if correct
            
        end   % while TF
        
    end       % while press
                                                             Results.P5{1,i} = [BW_P5{i,3},num2str(BW_P5{i,2})];
                                                             Results.P5{2,i} = Dis_Time(1,i);
                                                             Results.P5{3,i} = RT(1,i);
    WaitSecs(0.2);
end


%% P6
input = {};
% Shuffle list
Order1 = randperm(size(Black,1),5); % Black
Order2 = randperm(size(White,1),5); % White
Order3 = randperm(size(Good,1),5); % Good
Order4 = randperm(size(Bad,1),5); % Bad

for i = 1:5
    Item_P6(4*(i-1)+1,:) = Black(Order1(i),:);
    Item_P6(4*(i-1)+2,:) = Good(Order3(i),:);
    Item_P6(4*(i-1)+3,:) = White(Order2(i),:);
    Item_P6(4*(i-1)+4,:) = Bad(Order4(i),:);
end

for i = 1:5    % 5 groups, 4 each
    Order_Odd = [4*(i-1)+1 4*(i-1)+3];
    Order_Odd = Order_Odd(randperm(size(Order_Odd,2)));
    Order_Even = [4*(i-1)+2 4*(i-1)+4];
    Order_Even = Order_Even(randperm(size(Order_Even,2)));
    Item_P6_Shuffle(4*(i-1)+1,:) = Item_P6(Order_Odd(1),:);
    Item_P6_Shuffle(4*(i-1)+2,:) = Item_P6(Order_Even(1),:);
    Item_P6_Shuffle(4*(i-1)+3,:) = Item_P6(Order_Odd(2),:);
    Item_P6_Shuffle(4*(i-1)+4,:) = Item_P6(Order_Even(2),:);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 message_P6L=[ '\n'...
    'Press "E" for \n '...
    '\n'...
    '      Bad\n'...
    '\n'...
    '       or\n'...
    '\n'...
    'White People\n'...
    '\n'];

message_P6R=[ '\n'...
    'Press "I" for \n '...
    '\n'...
    '     Good\n'...
    '\n'...
    '       or\n'...
    '\n'...
    'Black People\n'...
    '\n'];

message_ins6=[ '\n'...
            'Part 6 of 7 \n'...
            '\n'...
            '\n'...
            'Put a left finger on the E key for items that belong to category Bad or White People.\n'...
            '\n'...
            'Put a right finger on the I key for items that belong to category Good or Black People.\n'...
            '\n'...
            'Items will appear one at a time.\n'...
            '\n'...
            '\n'...
            'If you make a mistake, a red cross mark will appear. Press the correct key to continue.\n'...
            '\n'...
            'Go as fast as you can while being accurate.\n'...
            '\n'...
            '\n'...
            '\n'...
            'Press the space bar when you are ready to start.\n'];
        
        DrawFormattedText(w, message_P6L, 0.05*winRect(3), 0.05*winRect(4), white) ;
        DrawFormattedText(w, message_P6R, 0.8* winRect(3), 0.05*winRect(4), white) ;
        DrawFormattedText(w, message_ins6, 'center', 'center' , white) ;
        Screen('Flip', w) ;
        
        WaitSecs(0.1);
        % KbWait;
        
        
        press = true;
        
        while press
            [~, keyCode, ~] = KbWait;
            pressedKey = KbName(keyCode) ;
            if  strcmpi(pressedKey, 'space') == 1
                press = false;
            end
            
        end
        
for i = 1:20
    
    Num_Press_P6 = 1;
    
    if  mod(i,2) == 1    % Odd numbers are images
    DrawFormattedText(w, message_P6L, 0.05*winRect(3), 0.05*winRect(4), white) ;
    DrawFormattedText(w, message_P6R, 0.8* winRect(3), 0.05*winRect(4), white) ;
    Screen('PutImage',w , Item_P6_Shuffle{i,1}, [0.45* winRect(3) 0.45* winRect(4) 0.45* winRect(3)+1.5*size(Item_P6_Shuffle{i,1},1) 0.9* 0.45*winRect(4)+1.5*size(Item_P6_Shuffle{i,1},2)]);    
    else
    DrawFormattedText(w, message_P6L, 0.05*winRect(3), 0.05*winRect(4), white) ;
    DrawFormattedText(w, message_P6R, 0.8* winRect(3), 0.05*winRect(4), white) ;
    DrawFormattedText(w, Item_P6_Shuffle{i,1}, 'center', 'center', white) ; 
    end
    
    Screen('Flip', w) ;
    
    Dis_Time(i) = GetSecs;
    
    press6 = true;
    
    while press6
        [~, keyCode, ~] = KbPressWait;
        
        Press_Time(i) = GetSecs;
        RT(i) = Press_Time(i) - Dis_Time(i);
        
        %                 Send_TRIGGER(daqInd, 8)   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                 Send_TRIGGER(daqInd, 128)
        %                 Eyelink('Message', 'Button Pressed');
        
        pressedKey = KbName(keyCode) ;
        
        EI = true;
        while EI
            
            if strcmpi(pressedKey, 'i') == 1
                input{1,1} = 'Good';
                input{1,2} = 'B';
                EI = false;
                
            elseif strcmpi(pressedKey, 'e') == 1
                input{1,1} = 'Bad';
                input{1,2} = 'W';
                EI = false;
            else
                EI = false;
                input = [];
            end
            
        end
        
        TF = true;
        
        while TF
            
            if isempty(input)
                break
            end
            
            if  (strcmpi(Item_P6_Shuffle{i,3},input{1,1}) == 1)||(strcmpi(Item_P6_Shuffle{i,3},input{1,2}))
                TF = false;
                press6 = false;
                Results.P6{4,i} = Num_Press_P6;
                
            else
                if mod(i,2) == 1    % Odd numbers are images
                DrawFormattedText(w, message_P6L, 0.05*winRect(3), 0.05*winRect(4), white) ;
                DrawFormattedText(w, message_P6R, 0.8* winRect(3), 0.05*winRect(4), white) ;
                Screen('PutImage',w , Item_P6_Shuffle{i,1}, [0.45* winRect(3) 0.45* winRect(4) 0.45* winRect(3)+1.5*size(Item_P6_Shuffle{i,1},1) 0.9* 0.45*winRect(4)+1.5*size(Item_P6_Shuffle{i,1},2)]);  
                Screen('PutImage', w, cross, [0.5* winRect(3) 0.9* winRect(4) 0.5* winRect(3)+50 0.9* winRect(4)+50]);
                else      % Even numbers are words
                DrawFormattedText(w, message_P6L, 0.05*winRect(3), 0.05*winRect(4), white) ;
                DrawFormattedText(w, message_P6R, 0.8* winRect(3), 0.05*winRect(4), white) ;
                DrawFormattedText(w, Item_P6_Shuffle{i,1}, 'center', 'center', white) ; 
                Screen('PutImage', w, cross, [0.5* winRect(3) 0.9* winRect(4) 0.5* winRect(3)+50 0.9* winRect(4)+50]);
                end
                Screen('Flip', w) ;
                Num_Press_P6 = Num_Press_P6 + 1;
                Results.P6{4,i} = Num_Press_P6;
                
                TF = false;
                
            end   % if correct
            
        end   % while TF
        
    end       % while press
                                                                    
    WaitSecs(0.2);
end
                                                                    for i = 1:2:19
                                                                        Results.P6{1,i} = [Item_P6_Shuffle{i,3},num2str(Item_P6_Shuffle{i,2})];
                                                                        Results.P6{2,i} = Dis_Time(1,i);
                                                                        Results.P6{3,i} = RT(1,i);
                                                                    end
                                                                    for i = 2:2:20
                                                                        Results.P6{1,i} = Item_P6_Shuffle{i,1};
                                                                        Results.P6{2,i} = Dis_Time(1,i);
                                                                        Results.P6{3,i} = RT(1,i);
                                                                        Results.P6{5,i} = Item_P6_Shuffle{i,2};
                                                                        Results.P6{6,i} = Item_P6_Shuffle{i,3};
                                                                    end

%% P7
input = {};
% Shuffle list

Order1 = [randperm(size(Black,1)) randperm(size(Black,1),4)]; % Black
Order2 = [randperm(size(White,1)) randperm(size(White,1),4)]; % White
Order3 = randperm(size(Good,1),10); % Good
Order4 = randperm(size(Bad,1),10); % Bad

for i = 1:10
    Item_P7(4*(i-1)+1,:) = Black(Order1(i),:);
    Item_P7(4*(i-1)+2,:) = Good(Order3(i),:);
    Item_P7(4*(i-1)+3,:) = White(Order2(i),:);
    Item_P7(4*(i-1)+4,:) = Bad(Order4(i),:);
end

for i = 1:10    % 5 groups, 4 each
    Order_Odd = [4*(i-1)+1 4*(i-1)+3];
    Order_Odd = Order_Odd(randperm(size(Order_Odd,2)));
    Order_Even = [4*(i-1)+2 4*(i-1)+4];
    Order_Even = Order_Even(randperm(size(Order_Even,2)));
    Item_P7_Shuffle(4*(i-1)+1,:) = Item_P7(Order_Odd(1),:);
    Item_P7_Shuffle(4*(i-1)+2,:) = Item_P7(Order_Even(1),:);
    Item_P7_Shuffle(4*(i-1)+3,:) = Item_P7(Order_Odd(2),:);
    Item_P7_Shuffle(4*(i-1)+4,:) = Item_P7(Order_Even(2),:);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 message_P7L=[ '\n'...
    'Press "E" for \n '...
    '\n'...
    '      Bad\n'...
    '\n'...
    '       or\n'...
    '\n'...
    'White People\n'...
    '\n'];

message_P7R=[ '\n'...
    'Press "I" for \n '...
    '\n'...
    '     Good\n'...
    '\n'...
    '       or\n'...
    '\n'...
    'Black People\n'...
    '\n'];

message_ins7=[ '\n'...
            'Part 7 of 7 \n'...
            '\n'...
            '\n'...
            'Put a left finger on the E key for items that belong to category Bad or White People.\n'...
            '\n'...
            'Put a right finger on the I key for items that belong to category Good or Black People.\n'...
            '\n'...
            'Items will appear one at a time.\n'...
            '\n'...
            '\n'...
            'If you make a mistake, a red cross mark will appear. Press the correct key to continue.\n'...
            '\n'...
            'Go as fast as you can while being accurate.\n'...
            '\n'...
            '\n'...
            '\n'...
            'Press the space bar when you are ready to start.\n'];
        
        DrawFormattedText(w, message_P7L, 0.05*winRect(3), 0.05*winRect(4), white) ;
        DrawFormattedText(w, message_P7R, 0.8* winRect(3), 0.05*winRect(4), white) ;
        DrawFormattedText(w, message_ins7, 'center', 'center' , white) ;
        Screen('Flip', w) ;
        
        WaitSecs(0.1);
        % KbWait;
        
        
        press = true;
        
        while press
            [~, keyCode, ~] = KbWait;
            pressedKey = KbName(keyCode) ;
            if  strcmpi(pressedKey, 'space') == 1
                press = false;
            end
            
        end
        
for i = 1:40
    
    Num_Press_P7 = 1;
    
    if  mod(i,2) == 1    % Odd numbers are images
    DrawFormattedText(w, message_P7L, 0.05*winRect(3), 0.05*winRect(4), white) ;
    DrawFormattedText(w, message_P7R, 0.8* winRect(3), 0.05*winRect(4), white) ;
    Screen('PutImage',w , Item_P7_Shuffle{i,1}, [0.45* winRect(3) 0.45* winRect(4) 0.45* winRect(3)+1.5*size(Item_P7_Shuffle{i,1},1) 0.9* 0.45*winRect(4)+1.5*size(Item_P7_Shuffle{i,1},2)]);    
    else
    DrawFormattedText(w, message_P7L, 0.05*winRect(3), 0.05*winRect(4), white) ;
    DrawFormattedText(w, message_P7R, 0.8* winRect(3), 0.05*winRect(4), white) ;
    DrawFormattedText(w, Item_P7_Shuffle{i,1}, 'center', 'center', white) ; 
    end
    
    Screen('Flip', w) ;
    
    Dis_Time(i) = GetSecs;
    
    press7 = true;
    
    while press7
        [~, keyCode, ~] = KbPressWait;
        
        Press_Time(i) = GetSecs;
        RT(i) = Press_Time(i) - Dis_Time(i);
        
        %                 Send_TRIGGER(daqInd, 8)   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                 Send_TRIGGER(daqInd, 128)
        %                 Eyelink('Message', 'Button Pressed');
        
        pressedKey = KbName(keyCode) ;
        
        EI = true;
        while EI
            
            if strcmpi(pressedKey, 'i') == 1
                input{1,1} = 'Good';
                input{1,2} = 'B';
                EI = false;
                
            elseif strcmpi(pressedKey, 'e') == 1
                input{1,1} = 'Bad';
                input{1,2} = 'W';
                EI = false;
            else
                EI = false;
                input = [];
            end
            
        end
        
        TF = true;
        
        while TF
            
            if isempty(input)
                break
            end
            
            if  (strcmpi(Item_P7_Shuffle{i,3},input{1,1}) == 1)||(strcmpi(Item_P7_Shuffle{i,3},input{1,2}))
                TF = false;
                press7 = false;
                Results.P7{4,i} = Num_Press_P7;
                
            else
                if mod(i,2) == 1    % Odd numbers are images
                DrawFormattedText(w, message_P7L, 0.05*winRect(3), 0.05*winRect(4), white) ;
                DrawFormattedText(w, message_P7R, 0.8* winRect(3), 0.05*winRect(4), white) ;
                Screen('PutImage',w , Item_P7_Shuffle{i,1}, [0.45* winRect(3) 0.45* winRect(4) 0.45* winRect(3)+1.5*size(Item_P7_Shuffle{i,1},1) 0.9* 0.45*winRect(4)+1.5*size(Item_P7_Shuffle{i,1},2)]);  
                Screen('PutImage', w, cross, [0.5* winRect(3) 0.9* winRect(4) 0.5* winRect(3)+50 0.9* winRect(4)+50]);
                else      % Even numbers are words
                DrawFormattedText(w, message_P7L, 0.05*winRect(3), 0.05*winRect(4), white) ;
                DrawFormattedText(w, message_P7R, 0.8* winRect(3), 0.05*winRect(4), white) ;
                DrawFormattedText(w, Item_P7_Shuffle{i,1}, 'center', 'center', white) ; 
                Screen('PutImage', w, cross, [0.5* winRect(3) 0.9* winRect(4) 0.5* winRect(3)+50 0.9* winRect(4)+50]);
                end
                Screen('Flip', w) ;
                Num_Press_P7 = Num_Press_P7 + 1;
                Results.P7{4,i} = Num_Press_P7;
                
                TF = false;
                
            end   % if correct
            
        end   % while TF
        
    end       % while press
                                                                    
    WaitSecs(0.2);
end
                                                                    for i = 1:2:39
                                                                        Results.P7{1,i} = [Item_P7_Shuffle{i,3},num2str(Item_P7_Shuffle{i,2})];
                                                                        Results.P7{2,i} = Dis_Time(1,i);
                                                                        Results.P7{3,i} = RT(1,i);
                                                                    end
                                                                    for i = 2:2:40
                                                                        Results.P7{1,i} = Item_P7_Shuffle{i,1};
                                                                        Results.P7{2,i} = Dis_Time(1,i);
                                                                        Results.P7{3,i} = RT(1,i);
                                                                        Results.P7{5,i} = Item_P7_Shuffle{i,2};
                                                                        Results.P7{6,i} = Item_P7_Shuffle{i,3};
                                                                    end

                                                                    
%% Ending

message_end=[ '\n'...
    'Complete!\n'...
    '\n'...
    '\n'...
    'Thank you for your participation.\n'...
    '\n'...
    '\n'...
    'Press the space bar to exit.\n'];

DrawFormattedText(w, message_end, 'center', 'center' , white) ;
Screen('Flip', w) ;
WaitSecs(0.1);


press_end = true;

while press_end
    [~, keyCode, ~] = KbWait;
    
%     Send_TRIGGER(daqInd, 32)
%     Send_TRIGGER(daqInd, 128)
    
    pressedKey = KbName(keyCode) ;
    if  strcmpi(pressedKey, 'space') == 1
        press_end = false;
    end
    
end



Screen('CloseAll');

save Results

% %% Finalize
% if eyetrackYN
%     Eyelink('CloseFile');
%     
%     %get edf file from eyelink computer
%     status=Eyelink('ReceiveFile', EyelinkFilename, fullfile(dataFiledir, [EyelinkFilename '_' num2str(fileNum) '.edf']));
%     disp(status)
%     
%     Eyelink('Shutdown')
% end