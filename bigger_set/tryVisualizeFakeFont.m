
clear
load('stimuliProperties.mat');
this = stimuli.box;

nonwords = ["xxykzh"
            "ykqgkx"
            "zqkhzw"
            "gywhxg"
            "wxzkgw"
            "qqhgwk"
            "zghywg"
            "hhzxyg"
            "kqxzzw"
            "ygkhkx"
            "kyzkxh"
            "qgyxkk"];

% Open Screen and add background
Screen('Preference', 'SkipSyncTests', 1);

try
    % Routine stuff
    % PTB opens a windows on the screen with the max index
    screens = Screen('Screens');
    whichscreen = max(screens);
    [this.win, this.rect] = Screen('OpenWindow', whichscreen, this.bg_color);
    
%     FONT AND SIZE ARE REALLY IMPORTANT
    Screen('TextFont', this.win, 'visbra_fakefont');
    Screen('TextSize', this.win, this.size);

    % RUN ONCE: SHOWS IN ORDER THE SAME STIMULUS AS FW, BW, SBW (MORE TO
    % IMPLEMENT)
    for i = 1:length(nonwords)
        
        thisNW = nonwords(i);
        
        % Blank screen
        Screen('FillRect', this.win, this.bg_color);
        
        DrawFormattedText(this.win, char(thisNW), 'center', 'center', this.txt_color);
            actualFont = Screen('TextFont', this.win)
            type = Screen('Preference','TextRenderer')

        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 1920, 1080]); 
        WaitSecs(0.5);
     
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

