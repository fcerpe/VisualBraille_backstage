%% Boxed presentation
% 
% EVER-CHANGING SCRIPT
%
% Presents stimuli (words) with an equal spacing before its components (letters).
% Spacing is proportionate to the one present by default for Braille
% characters. The goal is for words to occupy the same visual field as
% Braille words do.
%
% To-do:
% - get box around each letter DONE
% - get dimensions of words DONE
% - print example of words and 'single' letters DONE
% - calc spaces

clearvars;
close all;
sca;

% Rudimental screen
Screen('Preference', 'SkipSyncTests', 1);
bg_color = [127 127 127]; % background color

load('stimuli_post_selection.mat','stimuli');
load('temp-1703.mat','cfg');
try
    % PTB opens a windows on the screen with the max index
    screens = Screen('Screens');
    whichscreen = max(screens);
    [w, rect] = Screen('OpenWindow', whichscreen, bg_color);
    Screen('TextFont', w, stimuli.boxPresentation.font);
    Screen('TextSize',w, stimuli.boxPresentation.size);

    % 'mywindows' gives as an index to recall the current windows, 'rect' gives the coordinate of that windows in a 4-number array [0, 0, X, Y]
    
    % Get the screen resolution in pixel
    w_x = rect(3);  w_y = rect(4);
    
    HideCursor;
    
    % Get max absolute
    maxLength = stimuli.boxPresentation.max_absolute; 
    
    % Presentation
    for t=1:3
        
        % Get positions in pixels for each letter, based on current word
        % Remember, 192 px (at size 50) is length of braille word. to
        % center it, we need to calc +- 96 around the 0, the center on the
        % x axis
        
        currWord = stimuli.boxPresentation.words(t,:); 
        currWord_char = char(stimuli.boxPresentation.words{t,1});
        
        % Save single letters, to simplify code later
        let1 = stimuli.boxPresentation.letters(stimuli.boxPresentation.letters.char == currWord_char(1),:);
        let2 = stimuli.boxPresentation.letters(stimuli.boxPresentation.letters.char == currWord_char(2),:);
        let3 = stimuli.boxPresentation.letters(stimuli.boxPresentation.letters.char == currWord_char(3),:);
        let4 = stimuli.boxPresentation.letters(stimuli.boxPresentation.letters.char == currWord_char(4),:);
        let5 = stimuli.boxPresentation.letters(stimuli.boxPresentation.letters.char == currWord_char(5),:);
        let6 = stimuli.boxPresentation.letters(stimuli.boxPresentation.letters.char == currWord_char(6),:);
        
        % X and Y positions for every letter
        xLet1 = w_x/2 - (maxLength/2) - let1.coord{1}(1);       
        yLet1 = w_y/2 - let1.coord{1}(2) + 26; % 26 is height of a letter without 'extensions'
        xLet2 = xLet1 + let1.length + currWord.spaceLength;     
        yLet2 = w_y/2 - let2.coord{1}(2) + 26;
        xLet3 = xLet2 + let2.length + currWord.spaceLength;     
        yLet3 = w_y/2 - let3.coord{1}(2) + 26;
        xLet4 = xLet3 + let3.length + currWord.spaceLength;     
        yLet4 = w_y/2 - let4.coord{1}(2) + 26;
        xLet5 = xLet4 + let4.length + currWord.spaceLength;     
        yLet5 = w_y/2 - let5.coord{1}(2) + 26;
        xLet6 = xLet5 + let5.length + currWord.spaceLength;     
        yLet6 = w_y/2 - let6.coord{1}(2) + 26;
        stimuli.boxPresentation.words.pixelLength(t) = (xLet6 + let6.length) - xLet1; % to check for actual length of the word

        %Blank screen
        Screen('FillRect', w, bg_color);

        % Make letters start at the same pixel (just with a and b at the
        % moment)
        DrawFormattedText(w, currWord_char(1), xLet1, yLet1);
        DrawFormattedText(w, currWord_char(2), xLet2, yLet2);
        DrawFormattedText(w, currWord_char(3), xLet3, yLet3);
        DrawFormattedText(w, currWord_char(4), xLet4, yLet4);
        DrawFormattedText(w, currWord_char(5), xLet5, yLet5);
        DrawFormattedText(w, currWord_char(6), xLet6, yLet6);
        drawFixation(cfg);
%         DrawFormattedText(w, char(currWord.string), 'center', 'center');
%         DrawFormattedText(w, double(stimuli.boxPresentation.braille.word.string), w_x/2-(maxLength/2)-8, (w_y/2+60));
        Screen('Flip', w);
        WaitSecs(10);

    end
    %------------End of trial presentation--------------------------
    
    % Final screen
    Screen('FillRect', w, bg_color);
    Screen('Flip', w);
    WaitSecs(1);
    
    % Closing up
    Screen('CloseAll');
    ShowCursor
    
catch
    
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if it is open.
    Priority(0);
    if exist('origLUT', 'var')
        Screen('LoadNormalizedGammaTable', screenNumber, origLUT);
    end
    Screen('CloseAll');
    psychrethrow(psychlasterror);
    
end





