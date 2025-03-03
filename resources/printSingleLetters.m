%% Print single letters for visbra_training

% Open ptb
% for each letter (including the accents) (see stimuli struct)
%   print at the center of the screen
%   screenshot
%   cut and save
% change script and repeat 

clear;

load('localizer_stimuli.mat','stimuli');

%% GO for it

pl = struct;
this = stimuli.box;
fl = stimuli.french.letters; 
bl = stimuli.braille.letters;
% Open ptb 
Screen('Preference', 'SkipSyncTests', 1);

try
    % Routine stuff: new fullscreen window
    screens = Screen('Screens');
    whichscreen = max(screens);
    [this.win, this.rect] = Screen('OpenWindow', whichscreen, this.bg_color);
    
    % FONT AND SIZE ARE REALLY IMPORTANT
    Screen('TextFont', this.win, this.font);
    Screen('TextSize', this.win, this.size*3);
    
    HideCursor;
    
    % RUN ONCE: SHOWS IN ORDER THE SAME STIMULUS AS FW, BW, SBW (MORE TO
    % IMPLEMENT)
    for i=1:size(fl,2)
        
        % get current letter
        thisLetter = fl{i};
        thisFilename = fl{i};
        switch i 
            case 27, thisFilename = "cs"; % ç
            case 28, thisFilename = "eUp"; % é
            case 29, thisFilename = "aDown"; % à
            case 30, thisFilename = "eDown"; % è
            case 31, thisFilename = "uDown"; % ù
            case 32, thisFilename = "aHat"; % â
            case 33, thisFilename = "eHat"; % ê
            case 34, thisFilename = "iHat"; % î
            case 35, thisFilename = "oHat"; % ô
            case 36, thisFilename = "uHat"; % û
            case 37, thisFilename = "eMlaut"; % ë
            case 38, thisFilename = "iMlaut"; % ï
            case 39, thisFilename = "uMlaut"; % ü
        end
               
        % Blank screen
        Screen('FillRect', this.win, this.bg_color);
        
        
        % FRENCH
        toPrint = [thisLetter];
        
        DrawFormattedText(this.win, double(toPrint), 'center', 'center', this.txt_color);
        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 1920, 1080]); 
        eval(['images.fl.' char(thisFilename) ' = temp_scr(341:740, 761:1160, :)']);
        WaitSecs(0.5);
        
        eval(['imwrite(images.fl.' char(thisFilename) ', ''figs/fr_' char(thisFilename) '.png'');']);
        
        
%         % BRAILLE
%         toPrint = [10303 bl{i} 10303];
%         
%         DrawFormattedText(this.win, double(toPrint), 'center', 'center', this.txt_color);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, [0, 0, 1920, 1080]); 
%         eval(['images.bl.' char(thisFilename) ' = temp_scr(501:574, 936:985, :)']);
%         
%         % Length = 40+10; Height = 64+10
%         % half screen: 935:985  503:577
%         
%         WaitSecs(0.5);
% 
%         eval(['imwrite(images.bl.' char(thisFilename) ', ''figs/br_' char(thisFilename) '.png'');']);
%         
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

printLetters = pl;

%% figure, imshow(images.bl.w)

f1 = figure; 
f1.Position = [600 600 100 100];
eval(['imshow(images.fl.' char(thisFilename) ');']);
eval(['imwrite(images.fl.' char(thisFilename) ', ''fr_' char(thisFilename) '.png'');']);


%%
save('singleLetters_images.mat','printLetters','stimuli');