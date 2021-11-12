%% Visualize stimuli
% Show on the screen french and braille words to be screenshotted
% To add:
% - screenshot -> DOES IT BUT ALL BLACK, NO SIGN OF LETTERS
%
% - possible to resize them autmoatically (maybe with gimp?)

% IMPORTANT: CHANGE SOURCE FOR DIFFERENT SETS
clear
load('mvpa_sota1109.mat');

%% Print the words

this = stimuli.box;
% cfg = vbEvrel_setParameters;
% cfg = initFixation(cfg);
% cfg.screen.win = this.win;
% 
% 
% thisFixation.fixation = cfg.fixation;
% thisFixation.screen = cfg.screen;

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
    
    HideCursor;
    
    % RUN ONCE: SHOWS IN ORDER THE SAME STIMULUS AS FW, BW, SBW (MORE TO
    % IMPLEMENT)
    for i=1:size(this.words,1)
        
        % Screenshot stuff
        % Name is images.ld.word
        wordFilename = char(stimuli.variableNames(i));
        
        % Get word infos and parameters: char array to print and
        % coordinates on where to do so
        thisWord = this.words(i,:);
        [thisChar, thisCoord] = mvpaCoordinates(thisWord, this, i);
        
        brCoord = stimuli.box.references{6,3}{1};
        stX = this.w_x/2 - (this.references{6,4}/2) - brCoord(1);
        stY = this.w_y/2 - brCoord(2) +26 -3;
        
%         thisNword = this.nonwords(i,:);
%         [thisNchar, thisNcoord] = mvpaCoordinates(thisNword, this, i);

        % Blank screen
        Screen('FillRect', this.win, this.bg_color);
        
        % FW
        %
        % Make letters start at the same pixel (just with a and b at the moment)
        for d = 1:length(thisChar)
            DrawFormattedText(this.win, thisChar(d), thisCoord(d,1), thisCoord(d,2), this.txt_color);
        end
        
        % Fixation cross, needs to be scrennshotted too (?) or at least to
        % speed up adjustments
%         drawFixation(thisFixation);
                
        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 1920, 1080]); 
        eval(['images.words.w' char(num2str(i)) ' = temp_scr(437:644, 701:1220, :)']);
        WaitSecs(0.3);
        
           
        % BW
        %
        % Just print them as centered
        DrawFormattedText(this.win, double(stimuli.braille.words{i}), stX, stY, this.txt_color);
        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 1920, 1080]); 
        eval(['images.words.w' char(num2str(i+8)) ' = temp_scr(437:644, 701:1220, :)']);
        WaitSecs(0.3);
        
%         % FNW
%         %
%         % Make letters start at the same pixel (just with a and b at the moment)
%         for d = 1:length(thisNchar)
%             DrawFormattedText(this.win, thisNchar(d), thisNcoord(d,1), thisNcoord(d,2), this.txt_color);
%         end
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, [0, 0, 1920, 1080]); 
%         eval(['images.nonwords.w' char(num2str(i)) ' = temp_scr(437:644, 701:1220, :)']);
%         WaitSecs(0.3);
        
           
%         % BNW
%         %
%         % Just print them as centered
%         DrawFormattedText(this.win, double(stimuli.braille.nonwords{i}), 'center', 'center', this.txt_color);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, [0, 0, 1920, 1080]); 
%         eval(['images.nonwords.w' char(num2str(i+8)) ' = temp_scr(437:644, 701:1220, :)']);
%         WaitSecs(0.3);
        
               
    end
    
    % Buffer screen 
    Screen('FillRect', this.win, this.bg_color);
    Screen('Flip', this.win);
    WaitSecs(2);
    
    % Show Braille words - later
       
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

%% FINAL CLEANUP AND SAVE

clearvars ans d i screens temp_scr this thisChar thisCoord thisWord whichscreen wordFilename thisNchar thisNword thisNcoord
save('mvpa_stimuli.mat');


