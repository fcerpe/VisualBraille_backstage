%% scramble images on the spot for the retreat presentation

clear
load('localizer_sota1008.mat');

% 550x300 -> squares of 10, or 25, or 50 px
%
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
            % Y
            y = startY(mod(newOrder(k),12)); % every 22 start again in a new row
            if mod(newOrder(k),12) == 0
                y = startY(end);
            end
            % X
            x = startX(floor(newOrder(k)/22)+1);
            if mod(newOrder(k),22) == 0 % multiple of 12, end of the coloumn
                x = startX(end);
            end
            
            % block in this position = block from the corresponding random
            % position
            newMat(i:i+24, j:j+24, :) = this(y:y+24, x:x+24, :);
            k = k+1;
        end
    end
    
    % save mat as image format and put it with the other stimuli
    newMat = uint8(newMat);
    eval(['images.sfw.' variableNames(loop) ' = newMat;']);

end

% second loop for SLD (same)
for loop = 1:length(stimuli.variableNames)
    
    % get current stimulus 
    eval(['this = images.ld.' char(stimuli.variableNames(loop)) ';']);
    
    % size of the square
    sizePx = 25;
    startY = 1:25:300;
    startX = 1:25:550;
    
    % new arrangement and new temp matrix
    newOrder = randperm(264);
    newMat = zeros(300,550,3);
    k = 1;
    
    for i = 1:25:300
        for j = 1:25:550
            % get starting position for copy-paste
            % X
            x = startX(mod(newOrder(k),22)); % every 22 start again in a new row
            if mod(newOrder(k),22) == 0
                x = startX(end);
            end
            % Y
            y = startY(floor(newOrder(k)/12)+1);
            if mod(newOrder(k),12) == 0 % multiple of 12, end of the coloumn
                y = startY(end);
            end
            
            newMat(i:i+24, j:j+24, :) = this(y:y+24, x:x+24, :);
            k = k+1;
        end
    end
    
    % save mat as image format and put it with the other stimuli
    newMat = uint8(newMat);
    eval(['images.sld.' variableNames(loop) ' = newMat;']);

end

%% Save 

save('localizer_sota1008.mat','localizer_words','stimuli','images');