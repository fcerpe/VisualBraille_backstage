%% STIMULI POST-SELECTION OPERATIONS
%   
% From simtuli initial selection, get details for presentation in pilot
% experiment.
% Log:
% 06/03/2021 - at the moment, does it for the whole initial selection, later 
%              it will be skimmed based on actual selection 

clear;

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

% create braille words 
load('stimuli_initial_selection.mat','words');

stimuli.french.words = words{:,1}; 
stimuli.braille.words = brailify(stimuli.french.words);

% Add reference to use later in box calculations
stimuli.braille.reference_word = char([10303 10303 10303 10303 10303 10303]);
stimuli.braille.reference_letter = char(10303);

%% 2. CREATE NON-WORDS
% Call function to create non-words based on words. Details of mapping are
% explicitated in the fucntion called.
% Non words for braille are made form the braille, not french due to
% similarity in characters.

stimuli.french.nonwords = makeNonWords(stimuli.french.words,'f');
stimuli.braille.nonwords = makeNonWords(stimuli.french.words,'b');

%% 3. GET GRAPHICAL DETAILS Pt. 1
% Calculate dimensions in pixel for each letter. Open screen to compute the
% smallest box around single letters or words, to be used later in the 
% presentation box script. 
% Actual calculation is made in getWordLength and by TextBounds of PTB.
 
% Open Screen to calculate boxes
Screen('Preference', 'SkipSyncTests', 1);
stimuli.boxPresentation.bg_color = [127 127 127];

try
    % Routine stuff
    % PTB opens a windows on the screen with the max index
    screens = Screen('Screens');
    whichscreen = max(screens);
    [win, rect] = Screen('OpenWindow', whichscreen, stimuli.boxPresentation.bg_color, [0,0,300,300]); 
    
    % Important: box size changes based on font style and size, worth
    % saving them
    % Check if other fonts allow braille 
    stimuli.boxPresentation.font = 'Segoe UI Symbol'; 
    stimuli.boxPresentation.size = 50;
    Screen('TextFont', win, stimuli.boxPresentation.font);
    Screen('TextSize', win, stimuli.boxPresentation.size); 

    % Information about letters and words for boxes is sotred into tables 
    stimuli.boxPresentation.letters = table(string(stimuli.french.letters'),'VariableNames',{'char'});
    stimuli.boxPresentation.words = table(string(stimuli.french.words),'VariableNames',{'string'});
    stimuli.boxPresentation.nonwords = table(string(stimuli.french.nonwords),'VariableNames',{'string'});
    
    % Get the screen resolution in pixel
    win_x = rect(3);  win_y = rect(4);
    
    % For each letter in the french alphabet
    for t = 1:length(stimuli.french.letters)
        
        % Get positions of letter
        yPositionIsBaseline = 0; % non negative data without
        temp_bounds = TextBounds(win, stimuli.french.letters{t}, yPositionIsBaseline);
        stimuli.boxPresentation.letters.coord{t} = temp_bounds; % coordinates for each letter
        stimuli.boxPresentation.letters.length(t) = temp_bounds(3) - temp_bounds(1);
        stimuli.boxPresentation.letters.height(t) = temp_bounds(4) - temp_bounds(2); % necessary for true center
        Screen('Flip', win);
        
    end
    
    % Same for word (with standard spaces included)
    for y = 1:length(stimuli.french.words)
        
        % Get positions of entire word
        temp_bounds = TextBounds(win, stimuli.french.words{y}, yPositionIsBaseline);
        stimuli.boxPresentation.words.coord{y} = temp_bounds; % coordinates for each letter
        stimuli.boxPresentation.words.length(y) = temp_bounds(3) - temp_bounds(1); % x-axis dimension
        Screen('Flip', win);
        
        % Since we're looping, also get the length of single letter words
        % (a.k.a. letters without spaces)
        stimuli.boxPresentation.words.letterLength(y) = getWordLength(stimuli.french.words{y});
        
        % Perform the same for non-words
        % entire non-word
        temp_bounds = TextBounds(win, stimuli.french.nonwords{y}, yPositionIsBaseline);
        stimuli.boxPresentation.nonwords.coord{y} = temp_bounds; % coordinates for each letter
        stimuli.boxPresentation.nonwords.length(y) = temp_bounds(3) - temp_bounds(1); % x-axis dimension
        Screen('Flip', win);
        
        % Single letters summed
        stimuli.boxPresentation.nonwords.letterLength(y) = getWordLength(stimuli.french.nonwords{y});
        
    end
    
    % Get length of braille references. REMEMBER TO CAST AS DOUBLE
    % word 
    temp_bounds = TextBounds(win, double(stimuli.braille.reference_word), yPositionIsBaseline);
    stimuli.boxPresentation.braille.word.string = stimuli.braille.reference_word; 
    stimuli.boxPresentation.braille.word.coord = temp_bounds; 
    stimuli.boxPresentation.braille.word.length = temp_bounds(3) - temp_bounds(1);
    Screen('Flip', win);
    
    % single letter
    temp_bounds = TextBounds(win, double(stimuli.braille.reference_letter), yPositionIsBaseline);
    stimuli.boxPresentation.braille.letterCoord = temp_bounds;
    stimuli.boxPresentation.braille.letterLength = temp_bounds(3) - temp_bounds(1);
    Screen('Flip', win);
    
    % Maximum is necessary, determines FOV ? (TBD)
    stimuli.boxPresentation.max_words = max(stimuli.boxPresentation.words.length);
    stimuli.boxPresentation.max_nonwords = max(stimuli.boxPresentation.nonwords.length);
    
    % Absolute is longest string in pixel among words, non-words, and
    % braille chars. Needed to compute spaces for each stimulus
    % Should be equal to braille (212 px), but we never know for sure
    stimuli.boxPresentation.max_absolute = max([stimuli.boxPresentation.max_words, ...
                                               stimuli.boxPresentation.max_nonwords, ...
                                               stimuli.boxPresentation.braille.word.length]);
    
    % Final screen - don't know if it's still needed. Too afraid to delete
    Screen('FillRect', win, stimuli.boxPresentation.bg_color);
    Screen('Flip', win);
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

save('stimuli_post_selection.mat','stimuli');

%% GET GRAPHICAL DETAILS Pt. 2
% Call to get the spaces for each word and to set up the presentation box
% Different part as it calls for some variables in stimuli

stimuli.boxPresentation.words.spaceLength = getSpaceLength(stimuli.boxPresentation.words);
stimuli.boxPresentation.nonwords.spaceLength = getSpaceLength(stimuli.boxPresentation.nonwords);

%% X. SAVE STIMULI POST SELECTION 
% IMPORTANT: many info about screen are not saved at the moment. Not
% relevant now, can be added later 

save('stimuli_post_selection.mat','stimuli');
'Done'

