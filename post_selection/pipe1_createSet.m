%% STIMULI POST-SELECTION OPERATIONS: CREATE THE SET STARTING FROM .TXT FILE
%
% Part 1 of X
% From simtuli initial selection, get the words detials 
% (then: scrambleDots, visualizeStimuli, importImages, scrambleImg)

clear

%% 1. FRENCH - BRAILLE MAPPING
% Create table containing intégral braille conversion of french characters.
% Then, call function to map based on this conversion

% All these arrays are ordered: 1 = a = ⠁ = 10241

% french alphabet with accented letters
stimuli.french.letters = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',...
    'p','q','r','s','t','u','v','w','x','y','z','ç','é','à','è'...
    'ù','â','ê','î','ô','û','ë','ï','ü'};

% braille alphabet with accented letters
stimuli.braille.letters = {'⠁','⠃','⠉','⠙','⠑','⠋','⠛','⠓','⠊','⠚','⠅','⠇','⠍','⠝',...
    '⠕','⠏','⠟','⠗','⠎','⠞','⠥','⠧','⠺','⠭','⠽','⠵','⠯','⠿',...
    '⠷','⠮','⠾','⠡','⠣','⠩','⠹','⠱','⠫','⠻','⠳'};

% unicode codes for each braille character
unicode = [10241, 10243, 10249, 10265, 10257, 10251, 10267, 10259, 10250, 10266,...
    10245, 10247, 10253, 10269, 10261, 10255, 10271, 10263, 10254, 10270,...
    10277, 10279, 10298, 10285, 10301, 10293, 10287, 10303, 10295, 10286,...
    10302, 10273, 10275, 10281, 10297, 10289, 10283, 10299, 10291];

nDots = [1,2,2,3,2,3,4,3,2,3,2,3,3,4,3,4,5,4,3,4,3,4,4,4,5,4,5,6,5,4,5,2,3,3,4,3,4,5,4];

% Summary table for Braille chars
stimuli.braille.summary = table(string(stimuli.french.letters'),string(stimuli.braille.letters'),unicode',nDots',...
    'VariableNames',{'fr_char','br_char','unicode','numDots'});

% match letters into one table
stimuli.conversion = table(string(stimuli.french.letters'), string(stimuli.braille.letters'),'variableNames',{'fr','br'});

% IMPORTANT: CHANGE SOURCE FOR DIFFERENT SETS
% create braille words
% load('localizer_stimuli.mat');
localizer_words = importWords('localizer_selection.txt');

stimuli.french.words = localizer_words{:,1};
stimuli.braille.words = brailify(stimuli.french.words, stimuli);

% Add reference to use later in box calculations
stimuli.braille.reference_letter = char(10303);

%% 2. CREATE MATLAB-APPROVED NAMES FOR VARIABLES
%
% Remove accents if there are any. Manual
stimuli.variableNames = string(stimuli.french.words);

% Change names with the accent into file-compatible chars
stimuli.variableNames(20) = "cuillere";

%% 3. GET GRAPHICAL DETAILS Pt. 1
% Calculate dimensions in pixel for each letter. Open screen to compute the
% smallest box around single letters or words, to be used later in the
%  box script.
% Actual calculation is made in getWordLength and by TextBounds of PTB.

% Open Screen to calculate boxes
Screen('Preference', 'SkipSyncTests', 1);
stimuli.box.bg_color = [0 0 0];
stimuli.box.txt_color = [255 255 255];

try
    % Routine stuff
    % PTB opens a windows on the screen with the max index
    screens = Screen('Screens');
    whichscreen = max(screens);
    [stimuli.box.win, stimuli.box.rect] = Screen('OpenWindow', whichscreen, stimuli.box.bg_color);
    
    % Important: box size changes based on font style and size, worth
    % saving them
    stimuli.box.font = 'Segoe UI Symbol';
    stimuli.box.size = 90;
    Screen('TextFont', stimuli.box.win, stimuli.box.font);
    Screen('TextSize', stimuli.box.win, stimuli.box.size);
    
    % Information about letters and words for boxes is sotred into tables
    stimuli.box.letters = table(string(stimuli.french.letters'),'VariableNames',{'char'});
    stimuli.box.words = table(string(stimuli.french.words),'VariableNames',{'string'});
    stimuli.box.references = table('Size',[8 5],'VariableTypes',{'double','string','cell','double','double'},...
                                   'VariableNames',{'nbChar','string','coord','length','height'});
    
    % Get the screen resolution in pixel
    stimuli.box.w_x = stimuli.box.rect(3);  stimuli.box.w_y = stimuli.box.rect(4);
    
    % For each letter in the french alphabet
    for fl = 1:length(stimuli.french.letters)
        
        % Get positions of letter
        yPositionIsBaseline = 0; % non negative data without (no idea)
        
        temp_bounds = TextBounds(stimuli.box.win, stimuli.french.letters{fl}, yPositionIsBaseline);
        stimuli.box.letters.coord{fl} = temp_bounds; % coordinates for each letter
        stimuli.box.letters.length(fl) = temp_bounds(3) - temp_bounds(1);
        stimuli.box.letters.height(fl) = temp_bounds(4) - temp_bounds(2); % necessary for true center
        Screen('Flip', stimuli.box.win);
        
    end
    
    % Same for word (with standard spaces included)
    for fw = 1:length(stimuli.french.words)
        
        % Get positions of entire word
        temp_bounds = TextBounds(stimuli.box.win, stimuli.french.words{fw}, yPositionIsBaseline);
        stimuli.box.words.coord{fw} = temp_bounds; % coordinates for each letter
        stimuli.box.words.length(fw) = temp_bounds(3) - temp_bounds(1); % x-axis dimension
        Screen('Flip', stimuli.box.win);
        
        % Also get the length of single letter words (a.k.a. letters without spaces)
        stimuli.box.words.letterLength(fw) = getWordLength(stimuli.french.words{fw}, stimuli);
        
%         % Perform the same for non-words
%         % entire non-word
%         temp_bounds = TextBounds(stimuli.box.win, stimuli.french.nonwords{fw}, yPositionIsBaseline);
%         stimuli.box.nonwords.coord{fw} = temp_bounds; % coordinates for each letter
%         stimuli.box.nonwords.length(fw) = temp_bounds(3) - temp_bounds(1); % x-axis dimension
%         Screen('Flip', stimuli.box.win);
%         
%         % Single letters summed
%         stimuli.box.nonwords.letterLength(fw) = getWordLength(stimuli.french.nonwords{fw});    
    end
    
    % Get length of braille references
    % Different words spanning lengths from 1 to 8
    ref_word = 10303; % 1 letter to start
    for n = 1:8
        % Get positions of entire word
        temp_bounds = TextBounds(stimuli.box.win, double(ref_word), yPositionIsBaseline);
        stimuli.box.references.nbChar(n) = n;
        stimuli.box.references.string(n) = char(ref_word);
        stimuli.box.references.coord{n} = temp_bounds;
        stimuli.box.references.length(n) = temp_bounds(3) - temp_bounds(1);
        stimuli.box.references.height(n) = temp_bounds(4) - temp_bounds(2);
        Screen('Flip', stimuli.box.win);
        
        % Increase the 'counter' = adds a letter to the reference word
        ref_word = [ref_word,10303];      
    end
    
    % Maximum is necessary, determines FOV
    stimuli.box.max_words = max(stimuli.box.words.length);
    stimuli.box.max_ref = max(stimuli.box.references.length);
%     stimuli.box.max_nonwords = max(stimuli.box.nonwords.length);
    
    % Absolute is longest string in pixel among words and
    % braille chars. Needed to compute spaces for each stimulus
    % Should be equal to braille, but we never know for sure
    stimuli.box.max_absolute = max([stimuli.box.max_words, ...
                                                stimuli.box.max_ref]);
    
    % Final screen 
    Screen('FillRect', stimuli.box.win, stimuli.box.bg_color);
    Screen('Flip', stimuli.box.win);
    WaitSecs(1);
    
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


%% GET GRAPHICAL DETAILS Pt. 2
% Call to get the spaces for each word and to set up the  box
% Different part as it calls for some variables in stimuli

stimuli.box.words.spaceLength = getSpaceLength(stimuli.box.words, stimuli.box);
% stimuli.box.nonwords.spaceLength = getSpaceLength(stimuli.box.nonwords);

%% X. SAVE STIMULI POST SELECTION
% IMPORTANT: many info about screen are not saved at the moment. Not
% relevant now, can be added later

save('localizer_sota1008.mat','localizer_words','stimuli');

% Next, run 'scrambleDots.m'


