%% Visualize stimuli
% Show on the screen french and braille words to be screenshotted
% To add:
% - screenshot -> DOES IT BUT ALL BLACK, NO SIGN OF LETTERS
%
% - possible to resize them autmoatically (maybe with gimp?)

% IMPORTANT: CHANGE SOURCE FOR DIFFERENT SETS
clear
load('word_scrambleDots.mat');


%% Print the words

this = stimuli.box;

%%
% Open Screen and add background
Screen('Preference', 'SkipSyncTests', 1);

try
    % Routine stuff
    % PTB opens a windows on the screen with the max index
    screens = Screen('Screens');
    whichscreen = max(screens);
    [this.win, this.rect] = Screen('OpenWindow', whichscreen, this.bg_color, [0 0 1512 982]);
    
%     FONT AND SIZE ARE REALLY IMPORTANT
    Screen('TextFont', this.win, this.font);
    Screen('TextSize', this.win, this.size);

    % RUN ONCE: SHOWS IN ORDER THE SAME STIMULUS AS FW, BW, SBW (MORE TO
    % IMPLEMENT)
    for i = 1:size(this.rw,1)
        
        % Get word infos and parameters: char array to print and
        % coordinates on where to do so
        thisRW = this.rw(i,:);
        thisPW = this.pw(i,:);
        thisNW = this.nw(i,:);
        [thisCharRW, thisCoordRW] = mvpaCoordinates(thisRW, this);
        [thisCharPW, thisCoordPW] = mvpaCoordinates(thisPW, this);
        [thisCharNW, thisCoordNW] = mvpaCoordinates(thisNW, this);
        
        brCoord = stimuli.box.references{6,3}{1};
        stX = this.w_x/2 - (this.references{6,4}/2) - brCoord(1);
        stY = this.w_y/2 - brCoord(2) +47 -12;
        
        % Blank screen
        Screen('FillRect', this.win, this.bg_color);
        
        %% REAL WORDS
        % FRW
        % Make letters start at the same pixel (just with a and b at the moment)
        for d = 1:length(thisCharRW)
            DrawFormattedText(this.win, thisCharRW(d), thisCoordRW(d,1), thisCoordRW(d,2), this.txt_color);
        end      
        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 1512, 982]); 
        eval(['images.frw.w' char(num2str(i)) ' = temp_scr(392:591, 507:1006, :);']);   
        eval(['imwrite(images.frw.w' char(num2str(i)) ', ''stimuli_imgs/frw_w' char(num2str(i)) '.png'');']);
        WaitSecs(0.3);
           
        % BRW
        % Just print them as centered
        DrawFormattedText(this.win, double(char(stimuli.braille.rw(i))), stX, stY, this.txt_color);
        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 1512, 982]); 
        eval(['images.brw.w' char(num2str(i)) ' = temp_scr(392:591, 507:1006, :, :);']);
        eval(['imwrite(images.brw.w' char(num2str(i)) ', ''stimuli_imgs/brw_w' char(num2str(i)) '.png'');']);
        WaitSecs(0.3);
        
        %% PSEUDO WORDS
        % FPW
        % Make letters start at the same pixel (just with a and b at the moment)
        for d = 1:length(thisCharPW)
            DrawFormattedText(this.win, thisCharPW(d), thisCoordPW(d,1), thisCoordPW(d,2), this.txt_color);
        end      
        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 1512, 982]); 
        eval(['images.fpw.w' char(num2str(i)) ' = temp_scr(392:591, 507:1006, :);']);    
        eval(['imwrite(images.fpw.w' char(num2str(i)) ', ''stimuli_imgs/fpw_w' char(num2str(i)) '.png'');']);
        WaitSecs(0.3);
           
        % BPW
        % Just print them as centered
        DrawFormattedText(this.win, double(char(stimuli.braille.pw(i))), stX, stY, this.txt_color);
        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 1512, 982]); 
        eval(['images.bpw.w' char(num2str(i)) ' = temp_scr(392:591, 507:1006, :);']);
        eval(['imwrite(images.bpw.w' char(num2str(i)) ', ''stimuli_imgs/bpw_w' char(num2str(i)) '.png'');']);
        WaitSecs(0.3);
        
        %% NON WORDS
        % FNW
        % Make letters start at the same pixel (just with a and b at the moment)
        for d = 1:length(thisCharNW)
            DrawFormattedText(this.win, thisCharNW(d), thisCoordNW(d,1), thisCoordNW(d,2), this.txt_color);
        end      
        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 1512, 982]); 
        eval(['images.fnw.w' char(num2str(i)) ' = temp_scr(392:591, 507:1006, :);']);
        eval(['imwrite(images.fnw.w' char(num2str(i)) ', ''stimuli_imgs/fnw_w' char(num2str(i)) '.png'');']);
        WaitSecs(0.3);
           
        % BRW
        % Just print them as centered
        DrawFormattedText(this.win, double(char(stimuli.braille.nw(i))), stX, stY, this.txt_color);
        Screen('Flip', this.win);
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 1512, 982]); 
        eval(['images.bnw.w' char(num2str(i)) ' = temp_scr(392:591, 507:1006, :);']);
        eval(['imwrite(images.bnw.w' char(num2str(i)) ', ''stimuli_imgs/bnw_w' char(num2str(i)) '.png'');']);
        WaitSecs(0.3);
        
        %% FAKE SCRIPT 
        % only scramble dots
        % Get current coords and center
        eval(['thisBN = stimuli.dots.result.' char(thisNW.string) ';']);
        for d = 1:length(thisBN.coords)
            DrawFormattedText(this.win, double(10241), thisBN.coords(1,d)-204, thisBN.coords(2,d)-49, this.txt_color);
        end
        Screen('Flip', this.win);
                
        % Screenshot: first all the screen, then cut what we need 
        % (PTB was not cooperating, that's why the double step)
        temp_scr = Screen('GetImage', this.win, [0, 0, 1512, 982]); 
        eval(['images.bfs.w' char(num2str(i)) ' = temp_scr(392:591, 507:1006, :);']);
        eval(['imwrite(images.bfs.w' char(num2str(i)) ', ''stimuli_imgs/bfs_w' char(num2str(i)) '.png'');']);
        WaitSecs(0.3);
        
        
    end
    
    % Buffer screen 
    Screen('FillRect', this.win, this.bg_color);
    Screen('Flip', this.win);
    WaitSecs(0);
    
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

% FINAL CLEANUP AND SAVE
save('word_visualizeStimuli.mat','stimuli','images');

