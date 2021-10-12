%% scramble images on the spot for the retreat presentation

clear
load('localizer_sota1008.mat');

% 550x300
%
%       X X X X X X X X X X X X X X X X X X X X X X 
%       X X X X X X X X X X X X X X X X X X X X X X 
%       X X X X X X X X X X X X X X X X X X X X X X 
%       X X X X X X X X X X X X X X X X X X X X X X 
%       X X X X O Q X X X X X X X X X X X X X X X X 
%       X X X X X X X X X X X X X X X X X X X X X X 
%       X X X X X X X X X X X X X X X X X X X X X X 
%       X X X X X X X X X X X X X X X X X X X X X X 
%       X X X X X X X X X X X X X X X X X X X X X X 
%       X X X X X X X X X X X X X X X X X X X X X X 
%       X X X X X X X X X X X X X X X X X X X X X X (X=25px)
%       X X X X X X X X X X X X X X X X X X X X X X total = 264 squares

% random
rng('default');

% first loop for SFW
for loop = 1:length(stimuli.variableNames)
    
    % get current stimulus 
    eval(['this = images.fw.' char(stimuli.variableNames(loop)) ';']);
    
    % size of the square
    sizePx = 25;
    startY = 1:25:300;
    startX = 1:25:550;
    
    % new arrangement. Permutation tells us which block will be put into
    % the position.
    % e.g. newMat position 1 = old mat position 56
    newOrder = randperm(264);
    
    % and new temp matrix
    newMat = zeros(300,550,3);
    
    % to loop through the new order
    k = 1;
    for i = 1:25:300
        for j = 1:25:550
            % get starting position for copy-paste
            % X
            y = (mod(newOrder(k),12)*25)-24; % every 22 start again in a new row
            if mod(newOrder(k),12) == 0
                y = 276;
            end
            
            % Y
            x = (floor(newOrder(k)/12))*25 + 1;
            if newOrder(k) == 264
                x = 526;
            end
            
            newMat(i:i+24, j:j+24, :) = this(y:y+24, x:x+24, :);
            k = k+1;
        end
    end
    
    % save mat as image format and put it with the other stimuli
    newMat = uint8(newMat);
    eval(['images.sfw.' char(stimuli.variableNames(loop)) ' = newMat;']);

end

% second loop for SLD (same)
for loop = 1:length(stimuli.variableNames)
    
    % get current stimulus 
    eval(['this = images.ld.' char(stimuli.variableNames(loop)) ';']);
    
    % size of the square
    sizePx = 25;
    startY = 1:25:300;
    startX = 1:25:550;
    
    % new arrangement. Permutation tells us which block will be put into
    % the position.
    % e.g. newMat position 1 = old mat position 56
    newOrder = randperm(264);
    
    % and new temp matrix
    newMat = zeros(300,550,3);
    coords = zeros(264,2);
    
    % to loop through the new order
    k = 1;
    for i = 1:25:300
        for j = 1:25:550
            % get starting position for copy-paste
            % X
            y = (mod(newOrder(k),12)*25)-24; % every 22 start again in a new row
            if mod(newOrder(k),12) == 0
                y = 276;
            end
                       
            % Y
            x = (floor(newOrder(k)/12))*25 + 1;
            if newOrder(k) == 264
                x = 526;
            end
            
            coords(k,1) = x;
            coords(k,2) = y;
            
            newMat(i:i+24, j:j+24, :) = this(y:y+24, x:x+24, :);
            k = k+1;
        end
    end
    
    % save mat as image format and put it with the other stimuli
    newMat = uint8(newMat);
    eval(['images.sld.' char(stimuli.variableNames(loop)) ' = newMat;']);

end

%% Save 

save('localizer_sota1008.mat','localizer_words','stimuli','images');