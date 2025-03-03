<<<<<<< HEAD
%% Visualize stimuli
% Show on the screen french and braille words to be screenshotted
% To add:
% - screenshot -> DOES IT BUT ALL BLACK, NO SIGN OF LETTERS
%
% - possible to resize them autmoatically (maybe with gimp?)

% IMPORTANT: CHANGE SOURCE FOR DIFFERENT SETS
clear
load('localizer_stimuli.mat');

%% Print the words

this = stimuli.box;

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
        [thisChar, thisCoord] = makeCoordinates(thisWord, this);
               
        % Blank screen
        Screen('FillRect', this.win, this.bg_color);
        
        % FW
        %
        % Make letters start at the same pixel (just with a and b at the moment)
        for d = 1:length(thisChar)
            DrawFormattedText(this.win, thisChar(d), thisCoord(d,1), thisCoord(d,2), this.txt_color);
        end
        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 1920, 1080]); 
        eval(['images.fw.' wordFilename ' = temp_scr(437:644, 701:1220, :)']);
        WaitSecs(3);
        
        % SFW
        %
        % To come later
        
        % BW
        %
        % Just print them as centered
        DrawFormattedText(this.win, double(stimuli.braille.words{i}), 'center', 'center', this.txt_color);
        
        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 1920, 1080]); 
        eval(['images.bw.' wordFilename ' = temp_scr(437:644, 701:1220, :)']);
        WaitSecs(3);
        
        % SBW
        %
        % Get current coords and center
        eval(['thisWord = stimuli.dots.result.' wordFilename ';']);
        
        for d = 1:length(thisWord.coords)
            DrawFormattedText(this.win, double(10241), thisWord.coords(1,d)-204, thisWord.coords(2,d)-49, this.txt_color);
        end
        Screen('Flip', this.win);
                
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 1920, 1080]); 
        eval(['images.sbw.' wordFilename ' = temp_scr(437:644, 701:1220, :)']);
        WaitSecs(3);
        
        
        
        % LD
        %
        % Already made when imported, just to note
        
        % SLD
        %
        % To come later
               
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

% print two examples each 
figure, imshow(images.fw.clef)
figure, imshow(images.bw.clef)
figure, imshow(images.sbw.clef)
figure, imshow(images.fw.cuillere)
figure, imshow(images.bw.cuillere)
figure, imshow(images.sbw.cuillere)

%% FINAL CLEANUP AND SAVE

clearvars ans d i screens temp_scr this thisChar thisCoord thisWord whichscreen wordFilename
save('localizer_stimuli.mat','localizer_words','stimuli','images');


=======
%% Visualize stimuli
% Show on the screen french and braille words to be screenshotted
% To add:
% - screenshot -> DOES IT BUT ALL BLACK, NO SIGN OF LETTERS
%
% - possible to resize them autmoatically (maybe with gimp?)

% IMPORTANT: CHANGE SOURCE FOR DIFFERENT SETS
clear
load('localizer_stimuli.mat');

%% Print the words

this = stimuli.box;

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
        [thisChar, thisCoord] = makeCoordinates(thisWord, this);
               
        % Blank screen
        Screen('FillRect', this.win, this.bg_color);
        
        % FW
        %
        % Make letters start at the same pixel (just with a and b at the moment)
        for d = 1:length(thisChar)
            DrawFormattedText(this.win, thisChar(d), thisCoord(d,1), thisCoord(d,2), this.txt_color);
        end
        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 1920, 1080]); 
        eval(['images.fw.' wordFilename ' = temp_scr(437:644, 701:1220, :)']);
        WaitSecs(3);
        
        % SFW
        %
        % To come later
        
        % BW
        %
        % Just print them as centered
        DrawFormattedText(this.win, double(stimuli.braille.words{i}), 'center', 'center', this.txt_color);
        
        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 1920, 1080]); 
        eval(['images.bw.' wordFilename ' = temp_scr(437:644, 701:1220, :)']);
        WaitSecs(3);
        
        % SBW
        %
        % Get current coords and center
        eval(['thisWord = stimuli.dots.result.' wordFilename ';']);
        
        for d = 1:length(thisWord.coords)
            DrawFormattedText(this.win, double(10241), thisWord.coords(1,d), thisWord.coords(2,d), this.txt_color);
        end
        Screen('Flip', this.win);
                
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 1920, 1080]); 
        eval(['images.sbw.' wordFilename ' = temp_scr(437:644, 701:1220, :)']);
        WaitSecs(3);
        
        
        
        % LD
        %
        % Already made when imported, just to note
        
        % SLD
        %
        % To come later
               
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

% print two examples each 
figure, imshow(images.fw.clef)
figure, imshow(images.bw.clef)
figure, imshow(images.sbw.clef)
figure, imshow(images.fw.cuillere)
figure, imshow(images.bw.cuillere)
figure, imshow(images.sbw.cuillere)

%% FINAL CLEANUP AND SAVE

clearvars ans d i screens temp_scr this thisChar thisCoord thisWord whichscreen wordFilename
save('localizer_stimuli.mat','localizer_words','stimuli','images');


>>>>>>> master
