%% CONCATENATE LETTERS INTO WORDS
%
% Extract list of words and pseudowords provided by Tom Poel
% Run evrything through the script to create images of a standardized size

brailleWords = struct;
lineWords = struct; 

% Read the list of words (TEMP: english)
wordlist = readcell('datasets/en_wordlist.csv', 'TextType', 'char'); 

% Open ptb
Screen('Preference', 'SkipSyncTests', 1);

try
    % Open new fullscreen window
    screens = Screen('Screens');
    [scr.win, scr.rect] = Screen('OpenWindow', 0, [255 255 255]);
    Screen('BlendFunction', scr.win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    % Hard-code the positions of the letters on the screen
    %
    % letter size: width 140, height 250
    % Using macbook (width 1512, height 982), center is (756, 491).
    % TEMPORARY: review positions for bigger letters
    xCenter = scr.rect(3)/2;
    yCenter = scr.rect(4)/2;
    width = 150;
    height = 250;

    % get the positions of each letter image according to the center
    [pos3L, pos4L, pos5L, pos6L, pos7L, pos8L] = vbs_initialize_positions(xCenter, yCenter, width, height);

    % Process and print each word in the list
    for iW = 1:10

        % Extract which word is that, how long it is, and where we should
        % place the letters
        currWord = wordlist{iW};
        currWordLength = length(currWord);
        eval(['currPositions = pos' num2str(currWordLength) 'L;']);

        % Initialize buffers to store images to present in 'DrawTextures'
        brailleTextures = [];
        lineTextures = [];

        % Extract each letter's image
        for iL = 1:currWordLength

            % For both scripts (Braille and line Braille):

            % Select the image of the letter to print
            eval(['brailleChar = imread(''input/vbs_letters/br_' char(currWord(iL)) '.png'');']);
            eval(['lineChar = imread(''input/vbs_letters/ln_' char(currWord(iL)) '.png'');']);

            % Make the texture of the image
            brailleLetter = Screen('MakeTexture', scr.win, brailleChar);
            lineLetter = Screen('MakeTexture', scr.win, lineChar);

            % Add the texture to the buffer
            brailleTextures = [brailleTextures, brailleLetter];
            lineTextures = [lineTextures, lineLetter];

        end


        % Draw the words

        % Braille
        Screen('DrawTextures', scr.win, brailleTextures, [], currPositions);
        Screen('Flip', scr.win);

        % Screenshot the images to save them
        screenshot = Screen('GetImage', scr.win, scr.rect*2);

        % OPTIONAL: crop the screenshot, or save the whole screen
        % eval(['br_words.' char(thisWord) ' = temp_scr(883:1082, 813:2212, :);']);
        eval(['brailleWords.' char(currWord) ' = screenshot;'])
        WaitSecs(0.5);

        % Save image of the word as .png
        eval(['imwrite(brailleWords.' char(currWord) ', ''output/vbs_images/br_' char(currWord) '.png'');']);


        % line Braille
        Screen('DrawTextures', scr.win, lineTextures, [], currPositions);
        Screen('Flip', scr.win);

        % Screenshot the images to save them
        sreenshot = Screen('GetImage', scr.win, scr.rect*2);

        % OPTIONAL: crop the screenshot, or save the whole screen
        % eval(['br_words.' char(thisWord) ' = temp_scr(883:1082, 813:2212, :);']);
        eval(['lineWords.' char(currWord) ' = screenshot;'])
        WaitSecs(0.5);

        % Save image of the word as .png
        eval(['imwrite(lineWords.' char(currWord) ', ''output/vbs_images/ln_' char(currWord) '.png'');']);
        
        % Buffer screen
        Screen('FillRect', scr.win, [255 255 255]);
        Screen('Flip', scr.win);
        WaitSecs(1);

    end

    %% Closing up
    Screen('CloseAll');
    ShowCursor;

catch

    % Closes the onscreen window if it is open.
    Priority(0);
    if exist('origLUT', 'var')
        Screen('LoadNormalizedGammaTable', screenNumber, origLUT);
    end
    Screen('CloseAll');
    psychrethrow(psychlasterror);

end

