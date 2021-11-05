%% Import images as matlab files
%
% Part X of X of the stimuli pipeline
% get images from the folder and add them to the .mat file

load('localizer_stimuli.mat');

% Open Screen and add background
Screen('Preference', 'SkipSyncTests', 1);

this = stimuli.box;

try
    % Routine stuff
    % PTB opens a windows on the screen with the max index
    screens = Screen('Screens');
    whichscreen = max(screens);
    [this.win, this.rect] = Screen('OpenWindow', whichscreen, this.bg_color);
    
    % FONT AND SIZE ARE REALLY IMPORTANT
    Screen('TextFont', this.win, this.font);
    Screen('TextSize', this.win, this.size);
    
    Screen('BlendFunction', this.win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    
    HideCursor;
    
    for im = 1:length(stimuli.variableNames)
        
        % Load image
        eval(['thisIm = imread(''images/' char(stimuli.variableNames(im)) '_r.png'');']);
        
        % Present image
        imageTexture = Screen('MakeTexture', this.win, thisIm);
        Screen('DrawTexture', this.win, imageTexture, [], [], 0);
        Screen('Flip', this.win);
        
        % screenshot image
        temp_scr = Screen('GetImage', this.win, [0, 0, 1920, 1080]); 
        eval(['images.ld.' char(stimuli.variableNames(im)) ' = temp_scr(437:644, 701:1220, :)']);
        WaitSecs(3);
        
    end
    
    % Buffer screen
    Screen('FillRect', this.win, this.bg_color);
    Screen('Flip', this.win);
    WaitSecs(2);
    
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

clearvars ans im imageTexture screens temp_scr this thisIm whichscreen
save('localizer_stimuli.mat','localizer_words','stimuli','images');

