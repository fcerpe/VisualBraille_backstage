%% CONCATENATE LETTERS INTO WORDS
%
% Extract list of words and pseudowords provided by Tom Poel
% Run evrything through the script to create images of a standardized size

if isempty(dir('dutch_manual_selection.mat'))
    extractManualSelection();
end

load("dutch_manual_selection.mat");

br_words = struct;
cb_words = struct; 


% Open ptb
Screen('Preference', 'SkipSyncTests', 1);

try
    % Routine stuff: new fullscreen window
    screens = Screen('Screens');
    [scr.win, scr.rect] = Screen('OpenWindow', 0, [255 255 255]);
    Screen('BlendFunction', scr.win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    % Hard-code the positions of the letters on the screen
    %
    % letter size: width 50, height 74
    % Using macbook (width 1512, height 982), center is (756, 491).
    % TEMPORARY: a bit of math to get the actual positions
    positions_3_letters = [661 731 801; 454 454 454; 711 781 851; 528 528 528];
    positions_4_letters = [626 696 766 836; 454 454 454 454; 676 746 816 886; 528 528 528 528];
    positions_5_letters = [591 661 731 801 871; 454 454 454 454 454; 641 711 781 851 921; 528 528 528 528 528];
    positions_6_letters = [556 626 696 766 836 906; 454 454 454 454 454 454; 606 676 746 816 886 956; 528 528 528 528 528 528];
    positions_7_letters = [521 591 661 731 801 871 941; 454 454 454 454 454 454 454; 571 641 711 781 851 921 991; 528 528 528 528 528 528 528];
    positions_8_letters = [486 556 626 696 766 836 906 976; 454 454 454 454 454 454 454 454; 536 606 676 746 816 886 956 1026; 528 528 528 528 528 528 528 528];

    % Go through words and pseudowords length by length
    for nLetters = 4:8
        eval(['currWordLength = words_' num2str(nLetters) '_letters;']);
        eval(['currPseudoLength = pseudowords_' num2str(nLetters) '_letters;']);
        eval(['currPositions = positions_' num2str(nLetters) '_letters;']);

        for iWord = 1:size(currWordLength,1)

            % Process the stimulus, form letters to the images of those
            % letters in the new alphabets
            thisWord = currWordLength{iWord};

            for iLetter = 1:length(thisWord)
                % Get the corresponding image
                eval(['BRchar = imread(''input/letters/br_' char(thisWord(iLetter)) '.png'');']);
                eval(['CBchar = imread(''input/letters/cb_' char(thisWord(iLetter)) '.png'');']);

                % Add the texture to an array of textures to display later
                % (complicated, but it's my understanding of how
                % 'DrawTextures' works)
                eval(['lettersBR' num2str(iLetter) ' = Screen(''MakeTexture'', scr.win, BRchar);']);
                eval(['lettersCB' num2str(iLetter) ' = Screen(''MakeTexture'', scr.win, CBchar);']);
            end

            % Order the textures to be printed
            % (bad code)
            switch iLetter
                case 4, texturesBR = [lettersBR1, lettersBR2, lettersBR3, lettersBR4];
                        texturesCB = [lettersCB1, lettersCB2, lettersCB3, lettersCB4];
                case 5, texturesBR = [lettersBR1, lettersBR2, lettersBR3, lettersBR4, lettersBR5];
                        texturesCB = [lettersCB1, lettersCB2, lettersCB3, lettersCB4, lettersCB5];
                case 6, texturesBR = [lettersBR1, lettersBR2, lettersBR3, lettersBR4, lettersBR5, lettersBR6];
                        texturesCB = [lettersCB1, lettersCB2, lettersCB3, lettersCB4, lettersCB5, lettersCB6];
                case 7, texturesBR = [lettersBR1, lettersBR2, lettersBR3, lettersBR4, lettersBR5, lettersBR6, lettersBR7];
                        texturesCB = [lettersCB1, lettersCB2, lettersCB3, lettersCB4, lettersCB5, lettersCB6, lettersCB7];
                case 8, texturesBR = [lettersBR1, lettersBR2, lettersBR3, lettersBR4, lettersBR5, lettersBR6, lettersBR7, lettersBR8];
                        texturesCB = [lettersCB1, lettersCB2, lettersCB3, lettersCB4, lettersCB5, lettersCB6, lettersCB7, lettersCB8];
            end

            % Draw the words

            % Braille
            Screen('DrawTextures', scr.win, texturesBR, [], currPositions);
            Screen('Flip', scr.win);

            % Take a screenshot, cut a standard size
            % (on macbook, size is actually double)
            temp_scr = Screen('GetImage', scr.win, scr.rect*2);

            % cut image to be 
            eval(['br_words.' char(thisWord) ' = temp_scr(883:1082, 813:2212, :);']);
            WaitSecs(0.5);

            eval(['imwrite(br_words.' char(thisWord) ', ''output/images/br_' char(thisWord) '.png'');']);

            % Connected braille
            Screen('DrawTextures', scr.win, texturesCB, [], currPositions);
            Screen('Flip', scr.win);
            % Screenshot: first all the screen, then cut what we need
            % (PTB was not cooperating, that's why the double step)
            temp_scr = Screen('GetImage', scr.win, scr.rect*2);
            eval(['cb_words.' char(thisWord) ' = temp_scr(883:1082, 813:2212, :);']);
            WaitSecs(0.5);

            eval(['imwrite(cb_words.' char(thisWord) ', ''output/images/cb_' char(thisWord) '.png'');']);

            % Buffer screen
            Screen('FillRect', scr.win, [0 0 0]);
            Screen('Flip', scr.win);
            WaitSecs(1);

        end

        for iPseudo = 1:size(currPseudoLength,1)

            % Process the stimulus, form letters to the images of those
            % letters in the new alphabets
            thisPseudo = currPseudoLength{iPseudo};

            for iLetter = 1:length(thisPseudo)
                % Get the corresponding image
                eval(['BRchar = imread(''input/letters/br_' char(thisPseudo(iLetter)) '.png'');']);
                eval(['CBchar = imread(''input/letters/cb_' char(thisPseudo(iLetter)) '.png'');']);

                % Add the texture to an array of textures to display later
                % (complicated, but it's my understanding of how
                % 'DrawTextures' works)
                eval(['lettersBR' num2str(iLetter) ' = Screen(''MakeTexture'', scr.win, BRchar);']);
                eval(['lettersCB' num2str(iLetter) ' = Screen(''MakeTexture'', scr.win, CBchar);']);
            end

            % Order the textures to be printed
            % (bad code)
            switch iLetter
                case 4, texturesBR = [lettersBR1, lettersBR2, lettersBR3, lettersBR4];
                        texturesCB = [lettersCB1, lettersCB2, lettersCB3, lettersCB4];
                case 5, texturesBR = [lettersBR1, lettersBR2, lettersBR3, lettersBR4, lettersBR5];
                        texturesCB = [lettersCB1, lettersCB2, lettersCB3, lettersCB4, lettersCB5];
                case 6, texturesBR = [lettersBR1, lettersBR2, lettersBR3, lettersBR4, lettersBR5, lettersBR6];
                        texturesCB = [lettersCB1, lettersCB2, lettersCB3, lettersCB4, lettersCB5, lettersCB6];
                case 7, texturesBR = [lettersBR1, lettersBR2, lettersBR3, lettersBR4, lettersBR5, lettersBR6, lettersBR7];
                        texturesCB = [lettersCB1, lettersCB2, lettersCB3, lettersCB4, lettersCB5, lettersCB6, lettersCB7];
                case 8, texturesBR = [lettersBR1, lettersBR2, lettersBR3, lettersBR4, lettersBR5, lettersBR6, lettersBR7, lettersBR8];
                        texturesCB = [lettersCB1, lettersCB2, lettersCB3, lettersCB4, lettersCB5, lettersCB6, lettersCB7, lettersCB8];
            end

            % Draw the words

            % Braille
            Screen('DrawTextures', scr.win, texturesBR, [], currPositions);
            Screen('Flip', scr.win);

            % Take a screenshot, cut a standard size
            % (on macbook, size is actually double)
            temp_scr = Screen('GetImage', scr.win, scr.rect*2);

            % cut image to be 
            eval(['br_words.' char(thisPseudo) ' = temp_scr(883:1082, 813:2212, :);']);
            WaitSecs(0.2);

            eval(['imwrite(br_words.' char(thisPseudo) ', ''output/images/br_' char(thisPseudo) '.png'');']);

            % Connected braille
            Screen('DrawTextures', scr.win, texturesCB, [], currPositions);
            Screen('Flip', scr.win);
            % Screenshot: first all the screen, then cut what we need
            % (PTB was not cooperating, that's why the double step)
            temp_scr = Screen('GetImage', scr.win, scr.rect*2);
            eval(['cb_words.' char(thisPseudo) ' = temp_scr(883:1082, 813:2212, :);']);
            WaitSecs(0.2);

            eval(['imwrite(cb_words.' char(thisPseudo) ', ''output/images/cb_' char(thisPseudo) '.png'');']);

            % Buffer screen
            Screen('FillRect', scr.win, [0 0 0]);
            Screen('Flip', scr.win);
            WaitSecs(0.5);
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

%% Save everything

save('dutch_processed_stimuli.mat','br_words','cb_words','words_4_letters','words_5_letters','words_6_letters','words_7_letters','words_8_letters', ...
                                   'pseudowords_4_letters','pseudowords_5_letters','pseudowords_6_letters','pseudowords_7_letters','pseudowords_8_letters')
