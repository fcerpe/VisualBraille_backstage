% Clear the workspace and the screen
sca;
close all;
clearvars;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
screens = Screen('Screens');
screenNumber = max(screens);
black = BlackIndex(screenNumber);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);
baseRect = [0 0 200 200];
centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter);
rectColor = [1 0 0];
Screen('FillRect', window, rectColor, centeredRect);
Screen('Flip', window);
KbStrokeWait;
sca;