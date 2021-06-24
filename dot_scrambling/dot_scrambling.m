%% DOT SCRAMBLING FUNCTION
%
% Author: Filippo Cerpelloni
% 
% Aim: scramble braille words into random dot patterns.
% Functioning DOES NOT actually scramble dots.
% Starting from a number of dots (extracted from the braille translation of
% a french word), prints the same number of dots in pre-selected spots,
% mimicking a random spread.

clear;
scramble = struct;

% Load the list of words to be scrambled
addpath 'C:\Users\filip\Documents\GitHub\VB_backstage_code\post_selection'
load('stimuli_post_selection.mat','stimuli');

% Temporary words to test the script
scramble.temp_list = {'bague'; 'balai'; 'ballon'; 'biberon'; 'bougie'; 'boussole'; ... 
             'brosse'; 'cahier'; 'cartable'; 'casque'; 'chariot'; 'cintre'; ...
             'clavier'; 'clef'; 'couronne'; 'crayon'};

% 'Translate' french words into Braille ones
scramble.bWords = brailify(scramble.temp_list);

%% Get general infos: length in pixels and size of a dot
Screen('Preference', 'SkipSyncTests', 1);
scramble.box.bg_color = [127 127 127];

try
    % Routine stuff: PTB opens a windows on the screen with the max index
    screens = Screen('Screens');
    whichscreen = max(screens);
    [scramble.box.win, scramble.box.rect] = Screen('OpenWindow', whichscreen, scramble.box.bg_color, [0,0,1000,1000]); 
    
    % Important: box size changes based on font style and size, worth
    % saving them
    % Check if other fonts allow braille 
    scramble.box.font = 'Segoe UI Symbol'; 
    scramble.box.size = 200;
    Screen('TextFont', scramble.box.win, scramble.box.font);
    Screen('TextSize', scramble.box.win, scramble.box.size); 
    
    ref_word = [10303];
    yPositionIsBaseline = 0; % non negative data without
    scramble.box.references = table('Size',[5 3],'VariableTypes',{'double','cell','cell'},'VariableNames',{'length','coord','size'});
    
    for n = 1:8 % calculate boxes for words 4 to 8 letters long
        % Get positions of entire word
        temp_bounds = TextBounds(scramble.box.win, ref_word, yPositionIsBaseline);
        scramble.box.references.length(n) = n;
        scramble.box.references.coord{n} = temp_bounds;
        scramble.box.references.size{n} = [temp_bounds(3) - temp_bounds(1), temp_bounds(4) - temp_bounds(2)];
        Screen('Flip', scramble.box.win);
        
        % Increase the 'counter' = adds a letter to the reference word
        ref_word = [ref_word,10303];      
    end
    
    % gets coordinates and diameter of a single dot (letter 'a')
    temp_bounds = TextBounds(scramble.box.win, double(10241), yPositionIsBaseline);
    scramble.box.dot.diameter = temp_bounds(3) - temp_bounds(1);
    scramble.box.dot.letter = char(10241);
    Screen('Flip', scramble.box.win);
    
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

scramble.words = table;
for i = 1:size(scramble.temp_list,1)
    % Which word
    scramble.words.word(i) = scramble.temp_list(i);
    % How many letters
    scramble.words.nLetters(i) = size(split(scramble.temp_list{i},''),1) -2;
    % Corresponding to how many pixels
    scramble.words.pxSize(i) = scramble.box.references{scramble.box.references.length == scramble.words.nLetters(i), 3};
    % How many dots to represent
    scramble.words.nDots(i) = getWordDots(scramble.temp_list(i));
end

clearvars ans i n whichscreen yPositionIsBaseline screens temp_bounds

%% Serious stuff: draw
% for each word, in an area that corresponds to its own in braille
% (scramble.words.pxSize), place nDots dots, according to simple rules:
%
% - no dot must be cut out: 
%   no overlaps (distance > diameter of dot) - minimum is 14 px between
%   centers (same distance in braille)
%   no out of boundaries (drawable area is 5 px smaller on each side) 
%                           
% - balancing: L-R? There isn't in the words

% Initialize ptb screen (compressed as it's always the same)

% Screen('Preference', 'SkipSyncTests', 1);
% screens = Screen('Screens');
% whichscreen = max(screens);
% [window, windowRect] = Screen('OpenWindow', whichscreen, [0 0 0], [0,0,500,500]); 
% [xCenter, yCenter] = RectCenter(windowRect); % Get center coordinates
% 
% rand('seed', sum(100 * clock)); % TEMP: CPP HAS A BETTER WAY

PsychDefaultSetup(2);
screens = Screen('Screens');
screenNumber = max(screens);
black = BlackIndex(screenNumber);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black, [0,0,900,900]);
[xCenter, yCenter] = RectCenter(windowRect);
sca;

% General information about the dot:
d = scramble.box.dot.diameter;
r = d/2;

% Minimum distance = usual distance from the center = reference of ⠿ on
% the x axis.
% Distance from the centers of the dots = reference of 1 - diameter
% (the two radiuses of the dots)
minDist = scramble.box.references.size{1,1}(1) - d;

% Only getting coordinates, doesn't draw anything
for k = 1:size(scramble.words,1) % for each word to scramble
    this_w = scramble.words(k,:);
     
    % reduce drawing area
    drawableX = this_w.pxSize{1}(1) - r;
    drawableY = this_w.pxSize{1}(2) - r;
    
%     % Rectangle code: for first times, draw this as well to check everything is
%     % in order
    baseRect = [0 0 drawableX drawableY];
    centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter);
%     rectColor = [1 1 1];  
%     % Draw rectangle
%     Screen('FillRect', window, rectColor, centeredRect);
%     Screen('Flip', window);

    % Set up dots loop
    % Array for previously drawn dots, to calculate distances
    allDots = [];

    % Dots loop - generate the coordinates for all of them
    for l = 1:this_w.nDots
    
        % Get coordinates and check for overlapping
        % First iteration
        this_x = randi(drawableX);
        this_y = randi(drawableY);
        
        while ~checkProximity([this_x,this_y],allDots,minDist)
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
    
    eval(['scramble.result.' scramble.words.word{k} '.coords = dotPositionMatrix;']);
    eval(['scramble.result.' scramble.words.word{k} '.center = dotCenter;']);
    
    % Get dot infos
%     Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
%     dotColor = [1 1 1];   
    
%     % Draw them all
%     Screen('DrawDots', window, dotPositionMatrix, d, dotColor, dotCenter, 2);
%     Screen('Flip', window);
end

%% Save
save('scrambled_words_sota.mat','scramble');











