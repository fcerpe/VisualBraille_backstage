% Author: Filippo Cerpelloni (based on previous scripts by Jan Drewes and Luca Ronconi)
% Task: To indicate if you have seen one or two dots?
% Press 'Z' if you have seen only 1 dot, press 'M' if you have seen 2 dots

clearvars;
close all;
sca;

% Put 1 instead of 0 only for script testing, not for real experiment!
Screen('Preference', 'SkipSyncTests', 1);

%--------------------------------
%    Visual setting
%--------------------------------
% Colors in RGB
bg_color = [127 127 127]; % background color
fix_color = [0 0 0]; % fixation color
bars_color = [255 255 255]; % flickering bars color (?)
% Durations and lengths
fix_duration = 1; % fixation duration (sec)
rand_fix_duration = 0.5;


try
    %----------------------------------
    %       Preliminary operations
    %----------------------------------
    % PTB opens a windows on the screen with the max index
    screens = Screen('Screens');
    whichscreen = max(screens);
    [mywindow, rect] = Screen('OpenWindow', whichscreen, bg_color);
    % 'mywindows' gives as an index to recall the current windows, 'rect' gives the coordinate of that windows in a 4-number array [0, 0, X, Y]
    
    % Get the screen resolution in pixel
    mywindow_x = rect(3);
    mywindow_y = rect(4);
    % need to enable alpha blending to make on-the-fly contrast work the way we want it to
    Screen('BlendFunction', mywindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    % Query the frame duration
    ifi = Screen('GetFlipInterval', mywindow);
       
    %----------------------------
    %       Instructions
    %----------------------------
    %Load an example of the target image
    Screen('FillRect', mywindow, bg_color);
    Screen('DrawText', mywindow, 'This is your target!',  mywindow_x*0.4, mywindow_y/2-300, [255 255 255], [], []);
    % Show everything on the screen and wait for button press
    Screen('Flip', mywindow);
    KbWait([], 2);
    
    %-----------------------------------------
    %       Start with trial presentation
    %-----------------------------------------
    HideCursor;
    for t=1:1
        
        %Blank screen
        Screen('FillRect', mywindow, bg_color);
        Screen('DrawText', mywindow, 'WORD',  mywindow_x/2, mywindow_y/2, [255 255 255], [], []);
        Screen('Flip', mywindow);
        WaitSecs(5);
        
 
    end
    %------------End of trial presentation--------------------------
    
    %Final screen
    Screen('FillRect', mywindow, bg_color);
    Screen('DrawText', mywindow, 'Thank you! The experiment has ended', mywindow_x*0.4, mywindow_y/2, [255 255 255], [], []);
    Screen('Flip', mywindow);
    WaitSecs(3);
    
    %Closing up
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
