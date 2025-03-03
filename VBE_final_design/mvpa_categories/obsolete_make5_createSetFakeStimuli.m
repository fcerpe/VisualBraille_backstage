%% STIMULI POST-SELECTION OPERATIONS: CREATE THE SET STARTING FROM .TXT FILE
%
% Part 1 of X
% From simtuli initial selection, get the words detials 
% (then: scrambleDots, visualizeStimuli, importImages, scrambleImg)

clear

%% 1. FRENCH - BRAILLE MAPPING
% Create table containing intégral braille conversion of french characters.
% Then, call function to map based on this conversion

% load the word selection
load('word_analysis.mat');

% All these arrays are ordered: 1 = a = ⠁ = 10241

% french alphabet with accented letters
stimuli.french.letters = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',...
    'p','q','r','s','t','u','v','w','x','y','z','ç','é','à','è'...
    'ù','â','ê','î','ô','û','ë','ï','ü'};

stimuli.french.fakescript = {'g','h','j','k','q','w','x','y','z'};

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

stimuli.french.rw = selRW(:,1);
stimuli.french.pw = selPW(:,1);
stimuli.french.nw = selNW(:,1);

stimuli.braille.rw = brailify(stimuli.french.rw, stimuli);
stimuli.braille.pw = brailify(stimuli.french.pw, stimuli);
stimuli.braille.nw = brailify(stimuli.french.nw, stimuli);

% Add reference to use later in box calculations
stimuli.braille.reference_letter = char(10303);

%% 2. CREATE MATLAB-APPROVED NAMES FOR VARIABLES
%
% Remove accents if there are any. Manual
stimuli.names.rw = string(stimuli.french.rw);
stimuli.names.rw(8) = "camera"; stimuli.names.rw(10) = "stereo";
stimuli.names.pw = string(stimuli.french.pw);
stimuli.names.pw(8) = "cemere"; stimuli.names.pw(9) = "repoir"; stimuli.names.pw(11) = "sivero";
stimuli.names.nw = string(stimuli.french.nw);

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
    stimuli.box.font = 'Segoe UI';
    stimuli.box.size = 90;
    Screen('TextFont', stimuli.box.win, stimuli.box.font);
    Screen('TextSize', stimuli.box.win, stimuli.box.size);
    
    % Information about letters and words for boxes is sotred into tables
    stimuli.box.letters = table(string(stimuli.french.letters'),'VariableNames',{'char'});
    stimuli.box.fakeletters = table(string(stimuli.french.fakescript'),'VariableNames',{'char'});
    stimuli.box.fs = table(string(stimuli.french.nw),'VariableNames',{'string'});
    stimuli.box.rw = table(string(stimuli.french.rw),'VariableNames',{'string'});
    stimuli.box.pw = table(string(stimuli.french.pw),'VariableNames',{'string'});
    stimuli.box.nw = table(string(stimuli.french.nw),'VariableNames',{'string'});

%     stimuli.box.nonwords = table(string(stimuli.french.nonwords),'VariableNames',{'string'});
    stimuli.box.references = table('Size',[6 5],'VariableTypes',{'double','string','cell','double','double'},...
                                   'VariableNames',{'nbChar','string','coord','length','height'});
    stimuli.box.refernces(:,4) = [40; 108; 176; 244; 312; 380; 448; 516];
    stimuli.box.refernces(:,6) = [64; 64; 64; 64; 64; 64; 64; 64];

    
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
    for fw = 1:length(stimuli.french.rw)
        
        % FRENCH REAL WORDS
        temp_bounds = TextBounds(stimuli.box.win, char(stimuli.french.rw(fw)), yPositionIsBaseline);
        stimuli.box.rw.coord{fw} = temp_bounds; % coordinates for each letter
        stimuli.box.rw.length(fw) = temp_bounds(3) - temp_bounds(1); % x-axis dimension
        Screen('Flip', stimuli.box.win);
        % Also get the length of single letter words (a.k.a. letters without spaces)
        stimuli.box.rw.letterLength(fw) = getWordLength(stimuli.french.rw(fw), stimuli, 0);
        
        % FRENCH PSEUDO WORDS
        temp_bounds = TextBounds(stimuli.box.win, char(stimuli.french.pw(fw)), yPositionIsBaseline);
        stimuli.box.pw.coord{fw} = temp_bounds; % coordinates for each letter
        stimuli.box.pw.length(fw) = temp_bounds(3) - temp_bounds(1); % x-axis dimension
        Screen('Flip', stimuli.box.win);
        % Also get the length of single letter words (a.k.a. letters without spaces)
        stimuli.box.pw.letterLength(fw) = getWordLength(stimuli.french.pw(fw), stimuli, 0);

        % FRENCH NON WORDS
        temp_bounds = TextBounds(stimuli.box.win, char(stimuli.french.nw(fw)), yPositionIsBaseline);
        stimuli.box.nw.coord{fw} = temp_bounds; % coordinates for each letter
        stimuli.box.nw.length(fw) = temp_bounds(3) - temp_bounds(1); % x-axis dimension
        Screen('Flip', stimuli.box.win);
        % Also get the length of single letter words (a.k.a. letters without spaces)
        stimuli.box.nw.letterLength(fw) = getWordLength(stimuli.french.nw(fw), stimuli, 0);
        
    end
    
    % Get length of braille references
    % Different words spanning lengths from 1 to 8
    ref_word = 10303; % 1 letter to start
    for n = 1:6
        % Get positions of entire word
        temp_bounds = TextBounds(stimuli.box.win, double(ref_word), yPositionIsBaseline);
        stimuli.box.references.nbChar(n) = n;
        stimuli.box.references.string(n) = char(ref_word);
        stimuli.box.references.coord{n} = temp_bounds;
        stimuli.box.references.length(n) = temp_bounds(3) - temp_bounds(1);
        stimuli.box.references.height(n) = temp_bounds(4) - temp_bounds(2);
        Screen('Flip', stimuli.box.win);

        % Increase the 'counter' = adds a letter to the reference word
        ref_word = [ref_word,10303];      %#ok<*AGROW> 
    end

    stimuli.box.references(:,1) = {1;2;3;4;5;6};
    stimuli.box.references(:,2) = {"⠿";"⠿⠿";"⠿⠿⠿";"⠿⠿⠿⠿";"⠿⠿⠿⠿⠿";"⠿⠿⠿⠿⠿⠿"}; %#ok<*CLARRSTR> 
    stimuli.box.references(:,3) = {{[9 0 36 42]};{[9 0 81 42]};{[9 0 126 42]};{[9 0 171 42]}; ...
                                   [9 0 216 42];[9 0 261 42]};
    stimuli.box.references(:,4) = {40; 108; 176; 244; 312; 380};
    stimuli.box.references(:,5) = {64; 64; 64; 64; 64; 64};
    
    % FRENCH FAKE SCRIPT
    stimuli.box.fakefont = 'visbra_fakefont_ultimate';
    stimuli.box.fakesize = 90;
    Screen('TextFont', stimuli.box.win, stimuli.box.fakefont);
    Screen('TextSize', stimuli.box.win, stimuli.box.fakesize);
    
    % FS LETTERS
    for fl = 1:length(stimuli.french.fakescript)    
        % Get positions of letter
        yPositionIsBaseline = 0; % non negative data without (no idea)
        
        temp_bounds = TextBounds(stimuli.box.win, stimuli.french.fakescript{fl}, yPositionIsBaseline);
        stimuli.box.fakeletters.coord{fl} = temp_bounds; % coordinates for each letter
        stimuli.box.fakeletters.length(fl) = temp_bounds(3) - temp_bounds(1);
        stimuli.box.fakeletters.height(fl) = temp_bounds(4) - temp_bounds(2); % necessary for true center
        Screen('Flip', stimuli.box.win);
        
    end
    
    % FS WORDS
    for fw = 1:length(stimuli.french.nw)
        temp_bounds = TextBounds(stimuli.box.win, char(stimuli.french.nw(fw)), yPositionIsBaseline);
        stimuli.box.fs.coord{fw} = temp_bounds; % coordinates for each letter
        stimuli.box.fs.length(fw) = temp_bounds(3) - temp_bounds(1); % x-axis dimension
        Screen('Flip', stimuli.box.win);

        % Also get the length of single letter words (a.k.a. letters without spaces)
        stimuli.box.fs.letterLength(fw) = getWordLength(stimuli.french.nw(fw), stimuli, 1);
    end

    % Maximum is necessary, determines FOV
    stimuli.box.max_rw = max(stimuli.box.rw.length);
    stimuli.box.max_pw = max(stimuli.box.pw.length);
    stimuli.box.max_nw = max(stimuli.box.nw.length);
    stimuli.box.max_fs = max(stimuli.box.fs.length);
    stimuli.box.max_ref = max(stimuli.box.references.length);
    
    % Absolute is longest string in pixel among words and
    % braille chars. Needed to compute spaces for each stimulus
    % Should be equal to braille, but we never know for sure
    stimuli.box.max_absolute = max([stimuli.box.max_rw, stimuli.box.max_pw, ...
                                    stimuli.box.max_nw, stimuli.box.max_ref]);
    
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

stimuli.box.rw.spaceLength = getSpaceLength(stimuli.box.rw, stimuli.box);
stimuli.box.pw.spaceLength = getSpaceLength(stimuli.box.pw, stimuli.box);
stimuli.box.nw.spaceLength = getSpaceLength(stimuli.box.nw, stimuli.box);
stimuli.box.fs.spaceLength = getSpaceLength(stimuli.box.nw, stimuli.box);
% stimuli.box.nonwords.spaceLength = getSpaceLength(stimuli.box.nonwords, stimuli.box);

%% X. SAVE STIMULI POST SELECTION
% IMPORTANT: many info about screen are not saved at the moment. Not
% relevant now, can be added later

clearvars ans avgNW avgPW avgRW brCoord images mvpa_words fl fw n nDots ref_word 
clearvars screens temp_bounds unicode whichscreen yPositionIsBaseline nonWords pseudoWords realWords sdNW sdPW sdRW
clearvars selNW selPW selRW stX stY

save('word_sota.mat');

% Next, run 'scrambleDots.m'


