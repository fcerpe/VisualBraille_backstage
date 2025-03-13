%% CONCATENATE LETTERS INTO WORDS FOR TEST DATASETS
%
% Run evrything through the script to create images of a standardized size

%% VBE TEST SET

fonts = ["Arial", "Braille"];

% Read the list of words
vbe_list = readcell('datasets/vbe_test_wordlist.csv', 'TextType', 'char'); 

% Open ptb
Screen('Preference', 'SkipSyncTests', 1);


try
    % Open new fullscreen window
    screens = Screen('Screens');
    [scr.win, scr.rect] = Screen('OpenWindow', 1, [255 255 255], [0 0 1920 1080]);
    Screen('BlendFunction', scr.win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    % Hard-code the positions of the new script letters on the screen
    % letter size: width 150, height 250
    xCenter = scr.rect(3)/2;
    yCenter = scr.rect(4)/2;
    width = 150;
    height = 250;

    % Determine positions of each letter image for Braille and Line, to be used later
    [pos3L, pos4L, pos5L, pos6L, pos7L, pos8L] = vbs_initialize_positions(xCenter, yCenter, width, height);

    % Determine dots positions
    fakescript = vbs_determine_dot_positions(vbe_list(37:48), scr);

    % Iterate through each font
    for iF = 1:length(fonts)

        % Print stimuli, based on which category are we dealing with 
        for iW = 1:length(vbe_list)

            % General information about the stimulus to print

            % Which word is that?
            currWord = vbe_list{iW};

            % How long is it?
            currWordLength = length(currWord);

            % Initiate buffer to store the textures to be drawn
            fontTextures = [];
    
            % If we are in the first three categories (RW, PW, NW), 
            % JUST PRINT WORDS
            if iW <= (length(vbe_list) * (3/4))

                % Where to place the letters? 
                for iL = 1:currWordLength
    
                    switch iF
                        case 1, fontID = 1;
                        case 2, fontID = 5;
                    end
        
                    % Select the image of the letter to print in the corresponding font
                    eval(['fontChar = imread(''input/vbs_letters/' char(currWord(iL)) '_F' num2str(fontID) '.png'');']);
        
                    % Make the texture of the image and add to buffer
                    fontLetter = Screen('MakeTexture', scr.win, fontChar);
                    fontTextures = [fontTextures, fontLetter];
                end
    
                % Determine the positions of each letter
                switch iF
                    % Latin - compute positions of latin letters based on the individual widths
                    case 1, fontPositions = vbs_compute_latin_positions(xCenter, yCenter, currWord, iF);

                    % Braille - assign the positions based on the number of letters
                    case 2, fontPositions = pos6L;
                end
            
            % If we are dealing with FS category, things get complicated    
            else
                
                % If the script is Latin, print fake-script
                if iF == 1
                    
                    % Load all the letters needed
                    for iL = 1:currWordLength
                        
                        eval(['fontChar = imread(''input/vbs_letters/' char(currWord(iL)) '_F7.png'');']);
                        fontLetter = Screen('MakeTexture', scr.win, fontChar);
                        fontTextures = [fontTextures, fontLetter];
                    end
        
                    % Determine the positions of each letter and draw them
                    fontPositions = vbs_compute_latin_positions(xCenter, yCenter, currWord, 7);

                    fontID = 1;
                    
                % If the script is Braille, plot random dots
                else 

                    % Get how many dots to plot based of the number of
                    % positions requested
                    fontPositions = fakescript.fakescript.(currWord);

                    % Load "letter" dot
                    for iL = 1:size(fontPositions,2)
                        fontChar = imread('input/vbs_letters/single_dot.png');
                        fontLetter = Screen('MakeTexture', scr.win, fontChar);
                        fontTextures = [fontTextures, fontLetter];
                    end

                    fontID = 5;

                end
            end

            % Draw the words, in whichever script and also dots in case
            Screen('DrawTextures', scr.win, fontTextures, [], fontPositions);
            Screen('Flip', scr.win);

            % Screenshot, crop, square images
            screenshot = Screen('GetImage', scr.win, scr.rect);
            fontSquare = vbs_create_square(screenshot(400:749, 245:1674, :));
            WaitSecs(0.1);

            % Save accordingly to the script and category we are printing
            switch fontID 
                case 1, script_name = 'LT';
                case 5, script_name = 'BR';
            end

            if iW <= 12, category_name = ['_RW_' num2str(iW)];
            elseif iW <= 24, category_name = ['_PW_' num2str(iW-12)];
            elseif iW <= 36, category_name = ['_NW_' num2str(iW-24)];
            elseif iW <= 48, category_name = ['_FS_' num2str(iW-36)];
            end

            filename = [script_name, category_name];

            eval(['imwrite(fontSquare, ''output/vbe_test_images/' char(filename) '.png'');']);

            % Buffer screen
            Screen('FillRect', scr.win, [255 255 255]);
            Screen('Flip', scr.win);
            WaitSecs(0.3);

        end
    end

    % Closing up
    Screen('CloseAll');
    ShowCursor;
catch
    % Closes the onscreen window if it is open.
    Priority(0);
    if exist('origLUT', 'var'), Screen('LoadNormalizedGammaTable', screenNumber, origLUT);
    end
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end


%% VBT TEST SET

fonts = ["Arial", "Braille", "Line Braille"];

% Read the list of words
vbt_list = readcell('datasets/vbt_test_wordlist.csv', 'TextType', 'char'); 

% Open ptb
Screen('Preference', 'SkipSyncTests', 1);

try
    % Open new fullscreen window
    screens = Screen('Screens');
    [scr.win, scr.rect] = Screen('OpenWindow', 1, [255 255 255], [0 0 1920 1080]);
    Screen('BlendFunction', scr.win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    % Hard-code the positions of the new script letters on the screen
    % letter size: width 150, height 250
    xCenter = scr.rect(3)/2;
    yCenter = scr.rect(4)/2;
    width = 150;
    height = 250;

    % Iterate through each font
    for iF = 1:length(fonts)

        % Process and print each word in the list
        for iW = 1:length(vbt_list)
    
            % Which word is that?
            currWord = vbt_list{iW};
    
            % How long is it?
            currWordLength = length(currWord);

            % Initiate buffer to store the textures to be drawn
            fontTextures = [];
    
            % Where to place the letters? 
            for iL = 1:currWordLength

                switch iF
                    case 1, fontID = 1;
                    case 2, fontID = 5;
                    case 3, fontID = 6; 
                end
    
                % Select the image of the letter to print in the corresponding font
                eval(['fontChar = imread(''input/vbs_letters/' char(currWord(iL)) '_F' num2str(fontID) '.png'');']);
    
                % Make the texture of the image
                fontLetter = Screen('MakeTexture', scr.win, fontChar);
    
                % Add the texture to the buffer
                fontTextures = [fontTextures, fontLetter];
            end

            % Determine the positions of each letter
            switch iF
                case 1 % Latin
                    % Compute positions of latin letters based on the individual widths
                    fontPositions = vbs_compute_latin_positions(xCenter, yCenter, currWord, iF);

                case {2,3} % Braille and Line Braille
                    % Assign the positions based on the number of letters
                    eval(['fontPositions = pos' num2str(currWordLength) 'L;']);
            end
        
            % Set name to identify stimuli
            if iW <= 80, stimID = 'S';      % Seen word 
            elseif iW <= 160, stimID = 'N'; % Novel word
            else, stimID = 'P';             % Pseudo word
            end
            savename = [stimID, '_', currWord ,'_F', num2str(fontID)];

            % Draw the words
            Screen('DrawTextures', scr.win, fontTextures, [], fontPositions);
            Screen('Flip', scr.win);
    
            % Screenshot, crop, square, save images
            screenshot = Screen('GetImage', scr.win, scr.rect);
            fontSquare = vbs_create_square(screenshot(400:749, 245:1674, :));
            WaitSecs(0.1);
            eval(['imwrite(fontSquare, ''output/vbt_test_images/' char(savename) '.png'');']);
    
            % Buffer screen
            Screen('FillRect', scr.win, [255 255 255]);
            Screen('Flip', scr.win);
            WaitSecs(0.3);

        end
    end

    % Closing up
    Screen('CloseAll');
    ShowCursor;
catch
    % Closes the onscreen window if it is open.
    Priority(0);
    if exist('origLUT', 'var'), Screen('LoadNormalizedGammaTable', screenNumber, origLUT);
    end
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end



%% SUBFUNCTIONS

function num = get_number_dots(stringIn)
    
    %       B C D F G H J K L M N P Q R S T V W X Y Z
    dots = [2,2,3,3,4,3,3,5,3,3,4,4,5,4,3,4,4,5,4,5,4]; 

    total = 0;

    for iC = 1:length(stringIn), total = total + dots(int8(word(iC)-96));
    end

    num = total;

end

