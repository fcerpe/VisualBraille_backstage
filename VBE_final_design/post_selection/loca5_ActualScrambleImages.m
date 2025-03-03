%% scramble images on the spot for the retreat presentation

clear
load('localizer_stimuli.mat');

% start saving data about pixels
stimuli.px_dimensions = table('Size',[20, 7], 'VariableTypes',{'string','double','double','cell','double','cell','double'},...
                                  'VariableNames',{'stimuli','fw_size','fw_pixels','bw_size','bw_pixels','ld_size','ld_pixels'});
stimuli.px_dimensions.stimuli = stimuli.variableNames;
stimuli.px_dimensions.fw_size = stimuli.box.words.coord;

%       X X X X X X X X X X X X X X X X X X X X 520x208
%       X X X X X X X X X X X X X X X X X X X X 
%       X X X X X X X X X X X X X X X X X X X X 
%       X X X X X X X X X X X X X X X X X X X X 
%       X X X X X X X X X X X X X X X X X X X X 
%       X X X X O Q X X X X X X X X X X X X X X 
%       X X X X X X X X X X X X X X X X X X X X (X=26px)
%       X X X X X X X X X X X X X X X X X X X X total = 160 squares

% first loop for SFW
for loop = 18:18 %:length(stimuli.variableNames)
    
    % get current stimulus 
    eval(['this = images.fw.' char(stimuli.variableNames(loop)) ';']);
    % paint it grayscale
    this = rgb2gray(this);
    
    % get image sizes 
    % first pixel on x axis
    sumX = sum(this(:,:,1),1);
    for iniX=1:length(sumX)
        if sumX(iniX) ~= 0
            break
        end
    end    
    % last pixel on x axis
    for endX = length(sumX):-1:1
        if sumX(endX) ~= 0
            break
        end
    end    
    % first pixel on y axis
    sumY = sum(this(:,:,1),2);
    for iniY=1:length(sumY)
        if sumY(iniY) ~= 0
            break
        end
    end    
    % last pixel on y axis
    for endY=length(sumY):-1:1
        if sumY(endY) ~= 0
            break
        end
    end
       
    % size of the square
    sizePx = 26;
    
    % round dimensions to a cell unit (25x25 pixels)
    fX = 26*floor(iniX/26)+1;
    lX = 26*(floor(endX/26)+1); if endX == 520, lX = 520; end
    fY = 26*floor(iniY/26)+1;
    lY = 26*(floor(endY/26)+1); if endY == 208, lY = 208; end 
    
    % new arrangement. Permutation tells us which block will be put into
    % the position.
    % e.g. newMat position 1 = old mat position 56
    numRows = round((lY-fY)/26); 
    numCols = round((lX-fX)/26);
    numSquares = numRows * numCols;
    newOrder = randperm(numSquares);
    
    % and new temp matrix
    newMat = zeros(208,520);
    
    % to loop through the new order
    k = 1;
    for i = fY:26:lY
        for j = fX:26:lX
            % get starting position for copy-paste
            % Y
            y = (mod(newOrder(k),numRows)*sizePx)-25 + fY-1; % every 22 start again in a new row
            if mod(newOrder(k),numRows) == 0
                y = lY-25;
            end
            % X 
            x = (floor(newOrder(k)/numRows))*sizePx + fX;
            if newOrder(k) == numSquares
                x = lX-25;
            end
            
            newMat(i:i+25, j:j+25) = this(y:y+25, x:x+25);
            k = k+1;
        end
    end
    
    % save mat as image format and put it with the other stimuli
    newMat = uint8(newMat);
    eval(['images.sfw.' char(stimuli.variableNames(loop)) ' = newMat;']);

end

%% second loop for SLD (same)

for loop = 1:length(stimuli.variableNames)
        
    % get current stimulus 
    eval(['this = images.ld.' char(stimuli.variableNames(loop)) ';']);
    
    this = rgb2gray(this);
    
    % get image sizes 
    % first pixel on x axis
    sumX = sum(this(:,:),1);
    for iniX=1:length(sumX)
        if sumX(iniX) > 100
            break
        end
    end    
    % last pixel on x axis
    for endX = length(sumX):-1:1
        if sumX(endX) > 100
            break
        end
    end    
    % first pixel on y axis
    sumY = sum(this(:,:),2);
    for iniY=1:length(sumY)
        if sumY(iniY) > 100 % imported images are not perfect (apparently)
            break
        end
    end    
    % last pixel on y axis
    for endY=length(sumY):-1:1
        if sumY(endY) > 100
            break
        end
    end
    
    stimuli.px_dimensions.ld_size(loop) = {[iniX iniY endX endY]};
    
    % size of the square
    sizePx = 26;
    
    % round dimensions to a cell unit (25x25 pixels)
    fX = 26*floor(iniX/26)+1;
    lX = 26*(floor(endX/26)+1);
    fY = 26*floor(iniY/26)+1;
    lY = 26*(floor(endY/26)+1);
    
    % new arrangement. Permutation tells us which block will be put into
    % the position.
    % e.g. newMat position 1 = old mat position 56
    numRows = round((lY-fY)/26); 
    numCols = round((lX-fX)/26);
    numSquares = numRows * numCols;
    newOrder = randperm(numSquares);
    
    % and new temp matrix
    newMat = zeros(208,520);
    
    % to loop through the new order
    k = 1;
    for i = fY:26:lY
        for j = fX:26:lX
            % get starting position for copy-paste
            % Y
            y = (mod(newOrder(k),numRows)*sizePx)-25 + fY-1; 
            if mod(newOrder(k),numRows) == 0
                y = lY-25;
            end
            % X 
            x = (floor(newOrder(k)/numRows))*sizePx + fX;
            if newOrder(k) == numSquares
                x = lX-25;
            end
            
            newMat(i:i+25, j:j+25) = this(y:y+25, x:x+25);
            k = k+1;
        end
    end
    
    % save mat as image format and put it with the other stimuli
    newMat = uint8(newMat);
    eval(['images.sld.' char(stimuli.variableNames(loop)) ' = newMat;']);

end

%% Save 

clearvars endX endY fX fY i iniX iniY j k loop lX lY newMat newOrder numCols numRows numSquares sizePx sumX sumY t this word x y 
save('localizer_stimuli.mat','localizer_words','stimuli','images');

