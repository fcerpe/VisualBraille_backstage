%% CONCATENATE LETTERS INTO WORDS
%
% Run evrything through the script to create images of a standardized size

fonts = ["Arial", "Times New Roman", "American Typewriter", "Futura", "Braille", "Line Braille"];

% Read the list of words
wordlist = readcell('datasets/nl_wordlist.csv', 'TextType', 'char'); 

% Open ptb
Screen('Preference', 'SkipSyncTests', 1);

try
    % Open new fullscreen window
    screens = Screen('Screens');
    [scr.win, scr.rect] = Screen('OpenWindow', 1, [255 255 255], [0 0 1920 1080]);
    Screen('BlendFunction', scr.win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    % Hard-code the positions of the new script letters on the screen
    % letter size: width 140, height 250
    % Using macbook (width 1512, height 982), center is (756, 491).
    % TEMPORARY: review positions for bigger letters
    xCenter = scr.rect(3)/2;
    yCenter = scr.rect(4)/2;
    width = 150;
    height = 250;

    % Iterate through each font
    for iF = 1:length(fonts)

        % Process and print each word in the list
        for iW = 1:length(wordlist)
    
            % Extract which word is that, how long it is, and where we should
            % place the letters
            currWord = wordlist{iW};
    
            if isdatetime(currWord)
                currWord = 'nat';
            end
            currWordLength = length(currWord);

            % Initiate buffer to store the textures to be drawn
            fontTextures = [];
    
            % Extract each letter's image
            for iL = 1:currWordLength
    
                % Select the image of the letter to print in the corresponding font
                eval(['fontChar = imread(''input/vbs_letters/' char(currWord(iL)) '_F' num2str(iF) '.png'');']);
    
                % Make the texture of the image
                fontLetter = Screen('MakeTexture', scr.win, fontChar);
    
                % Add the texture to the buffer
                fontTextures = [fontTextures, fontLetter];
    
            end


            % Determine the positions of each letter
            % If it's Braille, positions are fixed
            if iF == 5 || iF == 6
                % get the positions of each letter image according to the center
                [pos3L, pos4L, pos5L, pos6L, pos7L, pos8L] = vbs_initialize_positions(xCenter, yCenter, width, height);
    
                % Assign the positions based on the number of letters
                eval(['fontPositions = pos' num2str(currWordLength) 'L;']);
    
            % For latin scripts, we have to compute based on the letter's width
            else
                % Compute positions of latin letters based on the individual widths
                fontPositions = vbs_compute_latin_positions(xCenter, yCenter, currWord, iF);
            end

        
            % Draw the words
        
            Screen('DrawTextures', scr.win, fontTextures, [], fontPositions);
            Screen('Flip', scr.win);
    
            % Screenshot the images to save them
            screenshot = Screen('GetImage', scr.win, scr.rect);
    
            % OPTIONAL: crop the screenshot, or save the whole screen
            fontSquare = vbs_create_square(screenshot(400:749, 245:1674, :));
            WaitSecs(0.3);
    
            % Save image of the word as .png
            % eval(['imwrite(screenshot, ''output/images/' char(currWord) '_screenshot.png'');']);
            % eval(['imwrite(fontWords.' char(currWord) ', ''output/images/' char(currWord) '.png'');']);
            eval(['imwrite(fontSquare, ''output/images/' char(currWord) '_F' num2str(iF) '.png'');']);
    
            % Buffer screen
            Screen('FillRect', scr.win, [255 255 255]);
            Screen('Flip', scr.win);
            WaitSecs(0.3);

        end
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

