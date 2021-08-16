%% Visualize stimuli
% Show on the screen french and braille words to be screenshotted
% To add:
% - show words according to box view
% - screenshot
% - possible to resize them autmoatically (maybe with gimp?)

% IMPORTANT: CHANGE SOURCE FOR DIFFERENT SETS
load('localizer_stimuli.mat');

%% Print the words
% One at the time, 5 seconds each to screenshot manually

this = stimuli.boxPresentation;

% Open Screen and add background
Screen('Preference', 'SkipSyncTests', 1);

try
    % Routine stuff
    % PTB opens a windows on the screen with the max index
    screens = Screen('Screens');
    whichscreen = max(screens);
    [this.win, this.rect] = Screen('OpenWindow', whichscreen, this.bg_color);
    
    % FONT AND SIZE ARE REALLY IMPORTANT
    Screen('TextFont', this.win, this.font);
    Screen('TextSize', this.win, this.size);
    
    % Get x and y dimensions
    w_x = this.rect(3);  w_y = this.rect(4);
    
    HideCursor;
    
    % Get max absolute
    maxLength = this.max_absolute;
    
    % Show french words first
%     for i=1:size(this.words,1)
        
        % Get word infos and the corresponding char array
        thisWord = this.words(i,:);
        thisChar = char(this.words{i,1});
        
        % Get the single letters and their infos 
        for l = 1:length(thisChar)
            eval(['letter' num2str(l) ' = this.letters(this.letters.char == thisChar(' num2str(l) '),:);']);
        end
        
        % X and Y positions for every letter
        % First is manual, others are looped
        xL1 = w_x/2 - (maxLength/2) - letter1.coord{1}(1);
        yL1 = w_y/2 - letter1.coord{1}(2) + 26; % 26 is height of a letter without 'extensions' at font 50
        
        % Each letter from 2 to 8, if the word is that long
        for c = 2:length(thisChar)
            eval(['prevX = xL' num2str(c-1) ';']);
            eval(['prevL = letter' num2str(c-1) ';']);
            eval(['currL = letter' num2str(c) ';']); 
            currX = prevX + prevL.length + thisWord.spaceLength;
            currY = w_y/2 - currL.coord{1}(2) + 26;
            eval(['xL' num2str(c) ' = currX;']);
            eval(['yL' num2str(c) ' = currY;']);
        end
                
        %Blank screen
        Screen('FillRect', this.win, this.bg_color);
        
        % Make letters start at the same pixel (just with a and b at the moment)
        for d = 1:length(thisChar)
            eval(['DrawFormattedText(this.win, thisChar(' num2str(d) '), xL' num2str(d) ', yL' num2str(d) ');']);
        end
        Screen('Flip', this.win);
        WaitSecs(5);
               
%     end
    
    % Buffer screen 
    Screen('FillRect', this.win, this.bg_color);
    Screen('Flip', this.win);
    WaitSecs(2);
    
    % Show Braille words
       
    
    % Final screen - don't know if it's still needed. Too afraid to delete
    Screen('FillRect', this.win, this.bg_color);
    Screen('Flip', this.win);
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
