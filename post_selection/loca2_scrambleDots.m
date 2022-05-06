%% DOT SCRAMBLING FUNCTION
%
% Author: Filippo Cerpelloni
%
% Part 2 of X 
% After createSet, start with scrambling the dot condition
% 
% Aim: scramble braille words into random dot patterns.
% Functioning DOES NOT actually scramble dots.
% Starting from a number of dots (extracted from the braille translation of
% a french word), prints the same number of dots in pre-selected spots,
% mimicking a random spread.

clear

% Load the list of words to be scrambled
load('localizer_stimuli.mat');

% Scramble is part of stimuli process, temporary saved as sc to avoid
% writing too many words
sc = struct;

% Temporary words list, to ease writing stuff
temp_w = string(localizer_words{:,1});

%% Get general infos: length in pixels and size of a dot
Screen('Preference', 'SkipSyncTests', 1);
sc.bg_color = stimuli.box.bg_color;

try
    % Routine stuff: PTB opens a windows on the screen with the max index
    screens = Screen('Screens');
    whichscreen = max(screens);
    [sc.win, sc.rect] = Screen('OpenWindow', whichscreen, sc.bg_color); 
    
    % Important: box size changes based on font style and size, worth
    % saving them
    % Check if other fonts allow braille 
    sc.font = stimuli.box.font; 
    sc.size = stimuli.box.size;
    Screen('TextFont', sc.win, sc.font);
    Screen('TextSize', sc.win, sc.size); 
    
    % gets coordinates and diameter of a single dot (letter 'a')
    temp_bounds = TextBounds(sc.win, double(10241), 0);
    sc.dot = table;
    sc.dot.letter = char(10241);
    sc.dot.diameter = temp_bounds(3) - temp_bounds(1);
    Screen('Flip', sc.win);
    
    % Closing up
    Screen('CloseAll');
    ShowCursor
    
catch
    % Closes the onscreen window if it is open.
    Priority(0);
    if exist('origLUT', 'var')
        Screen('LoadNormalizedGammaTable', screenNumber, origLUT);
    end
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end

%% Get specific info: number of letters, dots for each word in the list

sc.words = table;

for i = 1:size(temp_w,1)
    % Which word
    sc.words.string(i) = temp_w(i);
    sc.words.braille(i) = stimuli.braille.words(i);
    % How many letters
    sc.words.nLetters(i) = length(char(sc.words.string(i)));
    % Corresponding to how many pixels: [length height]
    sc.words.length(i) = stimuli.box.references{stimuli.box.references.nbChar == sc.words.nLetters(i), 4};
    sc.words.height(i) = stimuli.box.references{stimuli.box.references.nbChar == sc.words.nLetters(i), 5};
    % How many dots to represent
    sc.words.nDots(i) = getWordDots(temp_w(i), stimuli);
end

%% Get and save coordinates of where to draw dots 
% for each word, in an area that corresponds to its own in braille
% (sc.words.pxSize), place nDots dots, according to simple rules:
%
% - no dot must be cut out: no overlaps and no out of boundaries 

% PTB coordinates from previous windows
[sc.xCenter, sc.yCenter] = RectCenter(sc.rect);

% General information about the dot:
sc.d = sc.dot.diameter;
sc.r = round(sc.d/2);

% Minimum distance = usual distance from the center = reference of ⠿ on
% the x axis. SUBJECT TO FONT SIZE
% Distance from the centers of the dots = reference of 1 - diameter
% (the two radiuses of the dots)
sc.minDist = stimuli.box.references.length(1) - sc.d;

% Only getting coordinates, doesn't draw anything
for k = 1:size(sc.words,1) % for each word to sc
    this_w = sc.words(k,:);
     
    % reduce drawing area
    drawableX = this_w.length - sc.r;
    drawableY = this_w.height - sc.r;
    
    % Rectangle code showing the limits
    baseRect = [0 0 drawableX drawableY];
    centeredRect = CenterRectOnPointd(baseRect, sc.xCenter, sc.yCenter);

    % Set up dots loop
    % Array for previously drawn dots, to calculate distances
    allDots = [];

    % Dots loop - generate the coordinates for all of them
    for l = 1:this_w.nDots
    
        % Get coordinates and check for overlapping
        % First iteration
        this_x = randi(drawableX);
        this_y = randi(drawableY);
        
        while ~checkProximity([this_x,this_y], allDots, sc.minDist)
            this_x = randi(drawableX);
            this_y = randi(drawableY);
        end
        
        % Save this dot coordinates
        allDots = vertcat(allDots,[this_x this_y]);               
    end
    
    % After getting all the coords
    % Convert coordinates in the version they want
    dotPositionMatrix = [reshape(allDots(:,1), 1, this_w.nDots); reshape(allDots(:,2), 1, this_w.nDots)];
    dotCenter = [centeredRect(1) centeredRect(2)];
    
    % Change of plans, dots are drawn poorly. Better to use 'a'. This means
    % having already centered coordinates
    %  New coord =              original coord      +  center of the screen  +  letter shift
    dotPositionMatrix(1,:) = dotPositionMatrix(1,:) + (1920/2 - drawableX/2) - sc.d -sc.r;
    dotPositionMatrix(2,:) = dotPositionMatrix(2,:) + (1080/2 - drawableY/2) + (this_w.height - sc.r) - sc.r/2;
    
    % Save in struct 
    eval(['sc.result.' char(stimuli.variableNames(k)) '.coords = dotPositionMatrix;']);
    eval(['sc.result.' char(stimuli.variableNames(k)) '.center = dotCenter;']);
    
    % Get dot infos
%     Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
%     dotColor = [1 1 1];   
   
%     % Draw them all
%     Screen('DrawDots', window, dotPositionMatrix, d, dotColor, dotCenter, 2);
%     Screen('Flip', window);
end

stimuli.dots = sc;
%% Save
clearvars allDots ans baseRect centeredRect dotCenter dotPositionMatrix drawableX drawableY i k l sc screens temp_bounds temp_w this_x this_y whichscreen
save('localizer_stimuli.mat','localizer_words','stimuli');

