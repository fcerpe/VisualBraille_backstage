%% Visualize stimuli
% Show on the screen french and braille words to be screenshotted
% To add:
% - screenshot -> DOES IT BUT ALL BLACK, NO SIGN OF LETTERS
%
% - possible to resize them autmoatically (maybe with gimp?)

% IMPORTANT: CHANGE SOURCE FOR DIFFERENT SETS
clear
load('word_sota.mat');

%% Print the words

this = stimuli.box;
% cfg = vbEvrel_setParameters;
% cfg = initFixation(cfg);
% cfg.screen.win = this.win;
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
    Screen('TextFont', this.win, this.fakefont);
    Screen('TextSize', this.win, this.fakesize);

    % RUN ONCE: SHOWS IN ORDER THE SAME STIMULUS AS FW, BW, SBW (MORE TO
    % IMPLEMENT)
    for i = 1:size(this.fs,1)
        
        % Get word infos and parameters: char array to print and
        % coordinates on where to do so
        thisFake = this.fs(i,:);
        [thisCharFS, thisCoordFS] = mvpaCoordinates(thisFake, this);
        
        brCoord = stimuli.box.references{6,3}{1};
        stX = this.w_x/2 - (this.references{6,4}/2) - brCoord(1);
        stY = this.w_y/2 - brCoord(2) +47 -12;
        
        % Blank screen
        Screen('FillRect', this.win, this.bg_color);
        
        % FFS
        % Make letters start at the same pixel (just with a and b at the moment)
        for d = 1:length(thisCharFS)
            DrawFormattedText(this.win, thisCharFS(d), thisCoordFS(d,1), thisCoordFS(d,2), this.txt_color);
        end      
        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 3024, 1964]); 
        eval(['images.ffs.w' char(num2str(i)) ' = temp_scr(783:1182, 1013:2012, :);']);    
        WaitSecs(0.3);
     
    end
    
    % Buffer screen 
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
save('word_ffs.mat','stimuli','images');

