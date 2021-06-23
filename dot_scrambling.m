%% DOT SCRAMBLING FUNCTION
%
% Author: Filippo Cerpelloni
% 
% Aim: scramble braille words into random dot patterns.
% Functioning DOES NOT actually scramble dots.
% Starting from a number of dots (extracted from the braille translation of
% a french word), prints the same number of dots in pre-selected spots,
% mimicking a random spread.
%
clear;
scramble = struct;

%% Load the list of words to be scrambled

load('stimuli_post_selection.mat','stimuli');
scramble.temp_list = {'bague'; 'balai'; 'ballon'; 'biberon'; 'bougie'; 'boussole'; ... 
             'brosse'; 'cahier'; 'cartable'; 'casque'; 'chariot'; 'cintre'; ...
             'clavier'; 'clef'; 'couronne'; 'crayon'};

%% 'Translate' french words into Braille ones

scramble.bWords = brailify(scramble.temp_list);

%% Get general infos: length in pixels and size of a dot

Screen('Preference', 'SkipSyncTests', 1);
scramble.box.bg_color = [127 127 127];

try
    % Routine stuff: PTB opens a windows on the screen with the max index
    screens = Screen('Screens');
    whichscreen = max(screens);
    [scramble.box.win, scramble.box.rect] = Screen('OpenWindow', whichscreen, scramble.box.bg_color, [0,0,500,500]); 
    
    % Important: box size changes based on font style and size, worth
    % saving them
    % Check if other fonts allow braille 
    scramble.box.font = 'Segoe UI Symbol'; 
    scramble.box.size = 50;
    Screen('TextFont', scramble.box.win, scramble.box.font);
    Screen('TextSize', scramble.box.win, scramble.box.size); 
    
    ref_word = [10303 10303 10303 10303];
    yPositionIsBaseline = 0; % non negative data without
    scramble.box.references = table('Size',[5 3],'VariableTypes',{'double','cell','cell'},'VariableNames',{'length','coord','size'});
    
    for n = 1:5 % calculate boxes for words 4 to 8 letters long
        
        
        % Get positions of entire word
        temp_bounds = TextBounds(scramble.box.win, ref_word, yPositionIsBaseline);
        scramble.box.references.length(n) = n+3;
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

%% Serious stuff: draw
% 
% 
% 
% 













