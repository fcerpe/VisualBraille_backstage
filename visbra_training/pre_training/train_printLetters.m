%% Print single letters for visbra_training
%
% Screenshot each letter to be used in the construction of words
% and to be connected for second alphabet

clear;

addpath '/Users/cerpelloni/Desktop/GitHub/VB_backstage_code/post_selection'

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
    Screen('TextFont', this.win, 'Arial');
    Screen('TextSize', this.win, this.size*4);
    
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

        % BRAILLE
        toPrint = [10303 fl{i} 10303];
        
        DrawFormattedText(this.win, double(toPrint), 'center', 'center', this.txt_color);
        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 3024, 1964]); 
        eval(['pl.xl.' char(thisFilename) ' = temp_scr(483:1482, 1013:2012, :);']);
        
        % ON WINDOWS, CHANGE TO RUN ON MAC
        % Length = 40+10; Height = 64+10
        % half screen: 935:985  503:577
        
        WaitSecs(0.5);

        eval(['imwrite(pl.xl.' char(thisFilename) ', ''figs/xl_' char(thisFilename) '.png'');']);
        
    end
    
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


%%
clearvars ans bl fl i pl screens temp_scr this thisFilename thisLetter toPrint whichscreen
save('singleLetters_images.mat','printLetters','stimuli');

%% Load images after Emma's work

addpath /Users/cerpelloni/'Google Drive'/'My Drive'/work/PhD/vwfa_training/stimuli

filenamesList = {'a','aDown','aHat','b','c','cs','d','e','eDown','eHat','eMlaut','eUp','f','g','h',...
    'i','iHat','iMlaut','j','l','m','n','o','oHat','p','q','r','s','t','u','uDown','uHat',...
    'uMlaut','v','x','y','z'};

lettersList = {'a','à','â','b','c','ç','d','e','è','ê','ë','é','f','g','h','i','î','ï','j','l',...
    'm','n','o','ô','p','q','r','s','t','u','ù','û','ü','v','x','y','z'};

% match letters into one table
conversion = table(string(filenamesList'), string(lettersList'),'variableNames',{'filename','letter'});

pl = struct;

% Load all the stimuli as images and save them in a struct

for iLet = 1:size(conversion,1)
    % get corresponding image for braille
    eval(['pl.br.' char(filenamesList{iLet}) ' = imread(''br_' char(filenamesList{iLet}) '.png'');']);

    % and for connected
    eval(['pl.cb.' char(filenamesList{iLet}) ' = imread(''cb_' char(filenamesList{iLet}) '.png'');']);

end

clearvars ans iLet % let's make some order

% temporary save of letters
save('singleLetters.mat');




