%% CONCATENATE LETTERS INTO WORDS
%
% get list of words
% for each one, split into letters and get the corresponding images
% place images in slots
% screenshot and imwrite

load('singleLetters.mat');
load('visbra_training_set.mat');

% create arrays with positions for DrawTextures
% (static, could be nicer but doesn't matter)
rect1 = [731; 454; 781; 528];
rect2 = [696 766; 454 454; 746 816; 528 528];
rect3 = [661 731 801; 454 454 454; 711 781 851; 528 528 528];
rect4 = [626 696 766 836; 454 454 454 454; 676 746 816 886; 528 528 528 528];
rect5 = [591 661 731 801 871; 454 454 454 454 454; 641 711 781 851 921; 528 528 528 528 528];
rect6 = [556 626 696 766 836 906; 454 454 454 454 454 454; 606 676 746 816 886 956; 528 528 528 528 528 528];
rect7 = [521 591 661 731 801 871 941; 454 454 454 454 454 454 454; 571 641 711 781 851 921 991; 528 528 528 528 528 528 528];
rect8 = [486 556 626 696 766 836 906 976; 454 454 454 454 454 454 454 454; 536 606 676 746 816 886 956 1026; 528 528 528 528 528 528 528 528];


% Open ptb
Screen('Preference', 'SkipSyncTests', 1);

try
    % Routine stuff: new fullscreen window
    screens = Screen('Screens');
    whichscreen = max(screens);
    [this.win, this.rect] = Screen('OpenWindow', whichscreen, [0 0 0]);

    HideCursor;

    Screen('BlendFunction', this.win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    

    % TRAINING SET
%     % for every word
%     for iW = 1:size(training_words,1)
% 
%         thisFilename = fn_train(iW);
% 
%         % get word
%         thisW = training_words.ortho{iW};
% 
%         % for each letter
%         for iL = 1:length(thisW)
% 
%             % choose which ones to draw, get positions from
%             % pre-made array
%             
%             % convert letter into filename
%             currentLet = conversion{conversion.letter == thisW(iL),1};
% 
%             % get corresponding images
%             eval(['thisBR = pl.br.' char(currentLet) ';']);
%             eval(['thisCB = pl.cb.' char(currentLet) ';']);
% 
%             % somehow add the texture to an array of textures according to
%             % what DrawTextureS wants
% 
%             eval(['letBR' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisBR);']);
%             eval(['letCB' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisCB);']);
%         end
%         
%         % get positions based on number of letters
%         eval(['thisPos = rect' num2str(iL) ';']);
%         
%         switch iL
%             case 3, texturesBR = [letBR1, letBR2, letBR3];
%                     texturesCB = [letCB1, letCB2, letCB3];
%             case 4, texturesBR = [letBR1, letBR2, letBR3, letBR4];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4];
%             case 5, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5];
%             case 6, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6];
%             case 7, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6, letBR7];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6, letCB7];
%         end
%         
%         % DRAW BRAILLE WORD
%         Screen('DrawTextures', this.win, texturesBR, [], thisPos);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, this.rect*2); 
%         eval(['pl.br_words.' char(thisFilename) ' = temp_scr(883:1082, 1013:2012, :);']);
%         WaitSecs(0.5);
%         
%         eval(['imwrite(pl.br_words.' char(thisFilename) ', ''figs/training/br_' char(thisFilename) '.png'');']);
% 
%         % DRAW CONNECTED BRAILLE WORD
%         Screen('DrawTextures', this.win, texturesCB, [], thisPos);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, this.rect*2); 
%         eval(['pl.cb_words.' char(thisFilename) ' = temp_scr(883:1082, 1013:2012, :);']);
%         WaitSecs(0.5);
% 
%         eval(['imwrite(pl.cb_words.' char(thisFilename) ', ''figs/training/cb_' char(thisFilename) '.png'');']);
% 
%         % Buffer screen
%         Screen('FillRect', this.win, [0 0 0]);
%         Screen('Flip', this.win);
%         WaitSecs(1);
% 
%     end

%     %% TEST DAY 2
%     for iW = 1:size(test_d2,1)
% 
%         thisFilename = fn_d2(iW);
% 
%         % get word
%         thisW = test_d2(iW);
%         thisC = char(thisW);
% 
%         % for each letter
%         for iL = 1:length(thisC)
% 
%             % choose which ones to draw, get positions from
%             % pre-made array
%             
%             % convert letter into filename
%             currentLet = conversion{conversion.letter == thisC(iL),1};
% 
%             % get corresponding images
%             eval(['thisBR = pl.br.' char(currentLet) ';']);
%             eval(['thisCB = pl.cb.' char(currentLet) ';']);
% 
%             % somehow add the texture to an array of textures according to
%             % what DrawTextureS wants
% 
%             eval(['letBR' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisBR);']);
%             eval(['letCB' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisCB);']);
% 
%         end
%         
%         % get positions based on number of letters
%         eval(['thisPos = rect' num2str(iL) ';']);
%         
%         switch iL
%             case 3, texturesBR = [letBR1, letBR2, letBR3];
%                     texturesCB = [letCB1, letCB2, letCB3];
%             case 4, texturesBR = [letBR1, letBR2, letBR3, letBR4];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4];
%             case 5, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5];
%             case 6, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6];
%             case 7, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6, letBR7];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6, letCB7];
%         end
%         
%         % DRAW BRAILLE WORD
%         Screen('DrawTextures', this.win, texturesBR, [], thisPos);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, this.rect*2); 
%         eval(['pl.br_words.' char(thisFilename) ' = temp_scr(883:1082, 1013:2012, :);']);
%         WaitSecs(0.5);
%         
%         eval(['imwrite(pl.br_words.' char(thisFilename) ', ''figs/test_d2/br_' char(thisFilename) '.png'');']);
% 
%         % DRAW CONNECTED BRAILLE WORD
%         Screen('DrawTextures', this.win, texturesCB, [], thisPos);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, this.rect*2); 
%         eval(['pl.cb_words.' char(thisFilename) ' = temp_scr(883:1082, 1013:2012, :);']);
%         WaitSecs(0.5);
% 
%         eval(['imwrite(pl.cb_words.' char(thisFilename) ', ''figs/test_d2/cb_' char(thisFilename) '.png'');']);
% 
%         % Buffer screen
%         Screen('FillRect', this.win, [0 0 0]);
%         Screen('Flip', this.win);
%         WaitSecs(1);
% 
%     end
% 
%     %% TEST DAY 3
%     for iW = 1:size(test_d3,1)
% 
%         thisFilename = fn_d3(iW);
% 
%         % get word
%         thisW = test_d3(iW);
%         thisC = char(thisW);
% 
%         % for each letter
%         for iL = 1:length(thisC)
% 
%             % choose which ones to draw, get positions from
%             % pre-made array
%             
%             % convert letter into filename
%             currentLet = conversion{conversion.letter == thisC(iL),1};
% 
%             % get corresponding images
%             eval(['thisBR = pl.br.' char(currentLet) ';']);
%             eval(['thisCB = pl.cb.' char(currentLet) ';']);
% 
%             % somehow add the texture to an array of textures according to
%             % what DrawTextureS wants
% 
%             eval(['letBR' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisBR);']);
%             eval(['letCB' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisCB);']);
% 
%         end
%         
%         % get positions based on number of letters
%         eval(['thisPos = rect' num2str(iL) ';']);
%         
%         switch iL
%             case 3, texturesBR = [letBR1, letBR2, letBR3];
%                     texturesCB = [letCB1, letCB2, letCB3];
%             case 4, texturesBR = [letBR1, letBR2, letBR3, letBR4];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4];
%             case 5, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5];
%             case 6, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6];
%             case 7, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6, letBR7];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6, letCB7];
%         end
%         
%         % DRAW BRAILLE WORD
%         Screen('DrawTextures', this.win, texturesBR, [], thisPos);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, this.rect*2); 
%         eval(['pl.br_words.' char(thisFilename) ' = temp_scr(883:1082, 1013:2012, :);']);
%         WaitSecs(0.5);
%         
%         eval(['imwrite(pl.br_words.' char(thisFilename) ', ''figs/test_d3/br_' char(thisFilename) '.png'');']);
% 
%         % DRAW CONNECTED BRAILLE WORD
%         Screen('DrawTextures', this.win, texturesCB, [], thisPos);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, this.rect*2); 
%         eval(['pl.cb_words.' char(thisFilename) ' = temp_scr(883:1082, 1013:2012, :);']);
%         WaitSecs(0.5);
% 
%         eval(['imwrite(pl.cb_words.' char(thisFilename) ', ''figs/test_d3/cb_' char(thisFilename) '.png'');']);
% 
%         % Buffer screen
%         Screen('FillRect', this.win, [0 0 0]);
%         Screen('Flip', this.win);
%         WaitSecs(1);
% 
%     end
% 
%     %% TEST DAY 4
%     for iW = 1:size(test_d4,1)
% 
%         thisFilename = fn_d4(iW);
% 
%         % get word
%         thisW = test_d4(iW);
%         thisC = char(thisW);
% 
%         % for each letter
%         for iL = 1:length(thisC)
% 
%             % choose which ones to draw, get positions from
%             % pre-made array
%             
%             % convert letter into filename
%             currentLet = conversion{conversion.letter == thisC(iL),1};
% 
%             % get corresponding images
%             eval(['thisBR = pl.br.' char(currentLet) ';']);
%             eval(['thisCB = pl.cb.' char(currentLet) ';']);
% 
%             % somehow add the texture to an array of textures according to
%             % what DrawTextureS wants
% 
%             eval(['letBR' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisBR);']);
%             eval(['letCB' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisCB);']);
% 
%         end
%         
%         % get positions based on number of letters
%         eval(['thisPos = rect' num2str(iL) ';']);
%         
%         switch iL
%             case 3, texturesBR = [letBR1, letBR2, letBR3];
%                     texturesCB = [letCB1, letCB2, letCB3];
%             case 4, texturesBR = [letBR1, letBR2, letBR3, letBR4];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4];
%             case 5, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5];
%             case 6, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6];
%             case 7, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6, letBR7];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6, letCB7];
%         end
%         
%         % DRAW BRAILLE WORD
%         Screen('DrawTextures', this.win, texturesBR, [], thisPos);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, this.rect*2); 
%         eval(['pl.br_words.' char(thisFilename) ' = temp_scr(883:1082, 1013:2012, :);']);
%         WaitSecs(0.5);
%         
%         eval(['imwrite(pl.br_words.' char(thisFilename) ', ''figs/test_d4/br_' char(thisFilename) '.png'');']);
% 
%         % DRAW CONNECTED BRAILLE WORD
%         Screen('DrawTextures', this.win, texturesCB, [], thisPos);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, this.rect*2); 
%         eval(['pl.cb_words.' char(thisFilename) ' = temp_scr(883:1082, 1013:2012, :);']);
%         WaitSecs(0.5);
% 
%         eval(['imwrite(pl.cb_words.' char(thisFilename) ', ''figs/test_d4/cb_' char(thisFilename) '.png'');']);
% 
%         % Buffer screen
%         Screen('FillRect', this.win, [0 0 0]);
%         Screen('Flip', this.win);
%         WaitSecs(1);
% 
%     end
% 
%     %% TEST DAY 5
%     for iW = 1:size(test_d5,1)
% 
%         thisFilename = fn_d5(iW);
% 
%         % get word
%         thisW = test_d5(iW);
%         thisC = char(thisW);
% 
%         % for each letter
%         for iL = 1:length(thisC)
% 
%             % choose which ones to draw, get positions from
%             % pre-made array
%             
%             % convert letter into filename
%             currentLet = conversion{conversion.letter == thisC(iL),1};
% 
%             % get corresponding images
%             eval(['thisBR = pl.br.' char(currentLet) ';']);
%             eval(['thisCB = pl.cb.' char(currentLet) ';']);
% 
%             % somehow add the texture to an array of textures according to
%             % what DrawTextureS wants
% 
%             eval(['letBR' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisBR);']);
%             eval(['letCB' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisCB);']);
% 
%         end
%         
%         % get positions based on number of letters
%         eval(['thisPos = rect' num2str(iL) ';']);
%         
%         switch iL
%             case 3, texturesBR = [letBR1, letBR2, letBR3];
%                     texturesCB = [letCB1, letCB2, letCB3];
%             case 4, texturesBR = [letBR1, letBR2, letBR3, letBR4];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4];
%             case 5, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5];
%             case 6, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6];
%             case 7, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6, letBR7];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6, letCB7];
%         end
%         
%         % DRAW BRAILLE WORD
%         Screen('DrawTextures', this.win, texturesBR, [], thisPos);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, this.rect*2); 
%         eval(['pl.br_words.' char(thisFilename) ' = temp_scr(883:1082, 1013:2012, :);']);
%         WaitSecs(0.5);
%         
%         eval(['imwrite(pl.br_words.' char(thisFilename) ', ''figs/test_d5/br_' char(thisFilename) '.png'');']);
% 
%         % DRAW CONNECTED BRAILLE WORD
%         Screen('DrawTextures', this.win, texturesCB, [], thisPos);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, this.rect*2); 
%         eval(['pl.cb_words.' char(thisFilename) ' = temp_scr(883:1082, 1013:2012, :);']);
%         WaitSecs(0.5);
% 
%         eval(['imwrite(pl.cb_words.' char(thisFilename) ', ''figs/test_d5/cb_' char(thisFilename) '.png'');']);
% 
%         % Buffer screen
%         Screen('FillRect', this.win, [0 0 0]);
%         Screen('Flip', this.win);
%         WaitSecs(1);
% 
%     end
% 
%     %% TEST DAY 6
%     for iW = 1:size(test_d6,1)
% 
%         thisFilename = fn_d6(iW);
% 
%         % get word
%         thisW = test_d6(iW);
%         thisC = char(thisW);
% 
%         % for each letter
%         for iL = 1:length(thisC)
% 
%             % choose which ones to draw, get positions from
%             % pre-made array
%             
%             % convert letter into filename
%             currentLet = conversion{conversion.letter == thisC(iL),1};
% 
%             % get corresponding images
%             eval(['thisBR = pl.br.' char(currentLet) ';']);
%             eval(['thisCB = pl.cb.' char(currentLet) ';']);
% 
%             % somehow add the texture to an array of textures according to
%             % what DrawTextureS wants
% 
%             eval(['letBR' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisBR);']);
%             eval(['letCB' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisCB);']);
% 
%         end
%         
%         % get positions based on number of letters
%         eval(['thisPos = rect' num2str(iL) ';']);
%         
%         switch iL
%             case 3, texturesBR = [letBR1, letBR2, letBR3];
%                     texturesCB = [letCB1, letCB2, letCB3];
%             case 4, texturesBR = [letBR1, letBR2, letBR3, letBR4];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4];
%             case 5, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5];
%             case 6, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6];
%             case 7, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6, letBR7];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6, letCB7];
%         end
%         
%         % DRAW BRAILLE WORD
%         Screen('DrawTextures', this.win, texturesBR, [], thisPos);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, this.rect*2); 
%         eval(['pl.br_words.' char(thisFilename) ' = temp_scr(883:1082, 1013:2012, :);']);
%         WaitSecs(0.5);
%         
%         eval(['imwrite(pl.br_words.' char(thisFilename) ', ''figs/test_d6/br_' char(thisFilename) '.png'');']);
% 
%         % DRAW CONNECTED BRAILLE WORD
%         Screen('DrawTextures', this.win, texturesCB, [], thisPos);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, this.rect*2); 
%         eval(['pl.cb_words.' char(thisFilename) ' = temp_scr(883:1082, 1013:2012, :);']);
%         WaitSecs(0.5);
% 
%         eval(['imwrite(pl.cb_words.' char(thisFilename) ', ''figs/test_d6/cb_' char(thisFilename) '.png'');']);
% 
%         % Buffer screen
%         Screen('FillRect', this.win, [0 0 0]);
%         Screen('Flip', this.win);
%         WaitSecs(1);
% 
%     end
% 
%     %% TEST DAY 7
%     for iW = 1:size(test_d7,1)
% 
%         thisFilename = fn_d7(iW);
% 
%         % get word
%         thisW = test_d7(iW);
%         thisC = char(thisW);
% 
%         % for each letter
%         for iL = 1:length(thisC)
% 
%             % choose which ones to draw, get positions from
%             % pre-made array
%             
%             % convert letter into filename
%             currentLet = conversion{conversion.letter == thisC(iL),1};
% 
%             % get corresponding images
%             eval(['thisBR = pl.br.' char(currentLet) ';']);
%             eval(['thisCB = pl.cb.' char(currentLet) ';']);
% 
%             % somehow add the texture to an array of textures according to
%             % what DrawTextureS wants
% 
%             eval(['letBR' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisBR);']);
%             eval(['letCB' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisCB);']);
% 
%         end
%         
%         % get positions based on number of letters
%         eval(['thisPos = rect' num2str(iL) ';']);
%         
%         switch iL
%             case 3, texturesBR = [letBR1, letBR2, letBR3];
%                     texturesCB = [letCB1, letCB2, letCB3];
%             case 4, texturesBR = [letBR1, letBR2, letBR3, letBR4];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4];
%             case 5, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5];
%             case 6, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6];
%             case 7, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6, letBR7];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6, letCB7];
%         end
%         
%         % DRAW BRAILLE WORD
%         Screen('DrawTextures', this.win, texturesBR, [], thisPos);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, this.rect*2); 
%         eval(['pl.br_words.' char(thisFilename) ' = temp_scr(883:1082, 1013:2012, :);']);
%         WaitSecs(0.5);
%         
%         eval(['imwrite(pl.br_words.' char(thisFilename) ', ''figs/test_d7/br_' char(thisFilename) '.png'');']);
% 
%         % DRAW CONNECTED BRAILLE WORD
%         Screen('DrawTextures', this.win, texturesCB, [], thisPos);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, this.rect*2); 
%         eval(['pl.cb_words.' char(thisFilename) ' = temp_scr(883:1082, 1013:2012, :);']);
%         WaitSecs(0.5);
% 
%         eval(['imwrite(pl.cb_words.' char(thisFilename) ', ''figs/test_d7/cb_' char(thisFilename) '.png'');']);
% 
%         % Buffer screen
%         Screen('FillRect', this.win, [0 0 0]);
%         Screen('Flip', this.win);
%         WaitSecs(1);
% 
%     end

%     %% PHRASES WORDS
%     for iW = 2:size(phrases_elements,1)
% 
%         thisFilename = fn_phrases(iW);
% 
%         % get word
%         thisW = phrases_elements(iW);
%         thisC = char(thisW);
% 
%         % for each letter
%         for iL = 1:length(thisC)
% 
%             % choose which ones to draw, get positions from
%             % pre-made array
%             
%             % convert letter into filename
%             currentLet = conversion{conversion.letter == thisC(iL),1};
% 
%             % get corresponding images
%             eval(['thisBR = pl.br.' char(currentLet) ';']);
%             eval(['thisCB = pl.cb.' char(currentLet) ';']);
% 
%             % somehow add the texture to an array of textures according to
%             % what DrawTextureS wants
% 
%             eval(['letBR' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisBR);']);
%             eval(['letCB' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisCB);']);
% 
%         end
%         
%         % get positions based on number of letters
%         eval(['thisPos = rect' num2str(iL) ';']);
%         
%         switch iL
%             case 1, texturesBR = [letBR1];
%                     texturesCB = [letCB1];
%             case 2, texturesBR = [letBR1, letBR2];
%                     texturesCB = [letCB1, letCB2];
%             case 3, texturesBR = [letBR1, letBR2, letBR3];
%                     texturesCB = [letCB1, letCB2, letCB3];
%             case 4, texturesBR = [letBR1, letBR2, letBR3, letBR4];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4];
%             case 5, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5];
%             case 6, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6];
%             case 7, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6, letBR7];
%                     texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6, letCB7];
%         end
%         
%         % DRAW BRAILLE WORD
%         Screen('DrawTextures', this.win, texturesBR, [], thisPos);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, this.rect*2); 
%         eval(['pl.br_words.' char(thisFilename) ' = temp_scr(883:1082, 1013:2012, :);']);
%         WaitSecs(0.5);
%         
%         eval(['imwrite(pl.br_words.' char(thisFilename) ', ''figs/phrases/br_' char(thisFilename) '.png'');']);
% 
%         % DRAW CONNECTED BRAILLE WORD
%         Screen('DrawTextures', this.win, texturesCB, [], thisPos);
%         Screen('Flip', this.win);
%         % Screenshot: first all the screen, then cut what we need 
%         % (PTB was not cooperating, that's why the double step)
%         temp_scr = Screen('GetImage', this.win, this.rect*2); 
%         eval(['pl.cb_words.' char(thisFilename) ' = temp_scr(883:1082, 1013:2012, :);']);
%         WaitSecs(0.5);
% 
%         eval(['imwrite(pl.cb_words.' char(thisFilename) ', ''figs/phrases/cb_' char(thisFilename) '.png'');']);
% 
%         % Buffer screen
%         Screen('FillRect', this.win, [0 0 0]);
%         Screen('Flip', this.win);
%         WaitSecs(1);
% 
%     end

    % temp: reading list
    list = ["fugitif","asphalte","exil","démarrer","avide","antenne","boeuf","brun","bloqué","boxeur", ...
            "injuste","riche","menacer","pavé","festin","exotique","détendre","bonté","fort","confus",...
            "sûreté","rôti","garantie","élite","rotation","sirop","reptile","obscène","site","sirène"];
    fn_list = ["fugitif","asphalte","exil","demarrer","avide","antenne","boeuf","brun","bloque","boxeur", ...
            "injuste","riche","menacer","pave","festin","exotique","detendre","bonte","fort","confus",...
            "surete","reti","garantie","elite","rotation","sirop","reptile","obscene","site","sirene"];
    
    rect4 = [486 556 626 696; 454 454 454 454; 536 606 676 746; 528 528 528 528];
    rect5 = [486 556 626 696 766; 454 454 454 454 454; 536 606 676 746 816; 528 528 528 528 528];
    rect6 = [486 556 626 696 766 836; 454 454 454 454 454 454; 536 606 676 746 816 886; 528 528 528 528 528 528];
    rect7 = [486 556 626 696 766 836 906; 454 454 454 454 454 454 454; 536 606 676 746 816 886 956; 528 528 528 528 528 528 528];
    rect8 = [486 556 626 696 766 836 906 976; 454 454 454 454 454 454 454 454; 536 606 676 746 816 886 956 1026; 528 528 528 528 528 528 528 528];


    for iW = 1:length(list)

        thisFilename = fn_list(iW);
        

        % get word
        thisW = list(iW);
        thisC = char(thisW);

        % for each letter
        for iL = 1:length(thisC)

            % choose which ones to draw, get positions from
            % pre-made array
            
            % convert letter into filename
            currentLet = conversion{conversion.letter == thisC(iL),1};

            % get corresponding images
            eval(['thisBR = pl.br.' char(currentLet) ';']);
            eval(['thisCB = pl.cb.' char(currentLet) ';']);

            % somehow add the texture to an array of textures according to
            % what DrawTextureS wants

            eval(['letBR' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisBR);']);
            eval(['letCB' num2str(iL) ' = Screen(''MakeTexture'', this.win, thisCB);']);

        end
        
        % get positions based on number of letters
        eval(['thisPos = rect' num2str(iL) ';']);
        
        switch iL
            case 1, texturesBR = [letBR1];
                    texturesCB = [letCB1];
            case 2, texturesBR = [letBR1, letBR2];
                    texturesCB = [letCB1, letCB2];
            case 3, texturesBR = [letBR1, letBR2, letBR3];
                    texturesCB = [letCB1, letCB2, letCB3];
            case 4, texturesBR = [letBR1, letBR2, letBR3, letBR4];
                    texturesCB = [letCB1, letCB2, letCB3, letCB4];
            case 5, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5];
                    texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5];
            case 6, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6];
                    texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6];
            case 7, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6, letBR7];
                    texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6, letCB7];
            case 8, texturesBR = [letBR1, letBR2, letBR3, letBR4, letBR5, letBR6, letBR7, letBR8];
                    texturesCB = [letCB1, letCB2, letCB3, letCB4, letCB5, letCB6, letCB7, letCB8];
        end
        
        % DRAW BRAILLE WORD
        Screen('DrawTextures', this.win, texturesBR, [], thisPos);
        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, this.rect*2); 
        eval(['pl.br_words.' char(thisFilename) ' = temp_scr(883:1082, 813:2212, :);']);
        WaitSecs(0.5);
        
        eval(['imwrite(pl.br_words.' char(thisFilename) ', ''br_' char(thisFilename) '.png'');']);

        % DRAW CONNECTED BRAILLE WORD
        Screen('DrawTextures', this.win, texturesCB, [], thisPos);
        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, this.rect*2); 
        eval(['pl.cb_words.' char(thisFilename) ' = temp_scr(883:1082, 813:2212, :);']);
        WaitSecs(0.5);

        eval(['imwrite(pl.cb_words.' char(thisFilename) ', ''cb_' char(thisFilename) '.png'');']);

        % Buffer screen
        Screen('FillRect', this.win, [0 0 0]);
        Screen('Flip', this.win);
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

%% Save everything

% printable = pl;
% 
% save('visbra_training_words.mat','printable','conversion','order','wordFilenames');
