function [p3L, p4L, p5L, p6L, p7L, p8L] = vbs_initialize_positions(xC, yC, w, h) 
%% Initialize postions on screen for VBS stimuli 
% From center coordinates and dimensions of the image letters to display,
% determine where the letters will go.
% Main function is to hide a lot of code

% Positions are somewhat hard-coded and meant to keep the word at the
% center of the screen

o = 10; % offset to distance letters

% 3-letters words
p3L = [xC-(w/2)-w  xC-(w/2)-o/2    xC+(w/2);     
       yC-(h/2)    yC-(h/2)    yC-(h/2); 
       xC-(w/2)    xC-(w/2)+w  xC+(w/2)+(w); 
       yC+(h/2)    yC+(h/2)    yC+(h/2)];

% 4-letters words
p4L = [xC-(w*2)  xC-w      xC        xC+w; 
       yC-(h/2)  yC-(h/2)  yC-(h/2)  yC-(h/2); 
       xC-w      xC        xC+w      xC+(w*2);
       yC+(h/2)  yC+(h/2)  yC+(h/2)  yC+(h/2)];

% 5-letters words
p5L = [xC-(w/2)-(w*2)  xC-(w/2)-w  xC-(w/2)    xC+(w/2)      xC+(w/2)+(w); 
       yC-(h/2)        yC-(h/2)    yC-(h/2)    yC-(h/2)      yC-(h/2);  
       xC-(w/2)-(w)    xC-(w/2)    xC-(w/2)+w  xC+(w/2)+(w)  xC+(w/2)+(w*2); 
       yC+(h/2)        yC+(h/2)    yC+(h/2)    yC+(h/2)      yC+(h/2)];

% 6-letters words
p6L = [xC-(w*3)  xC-(w*2)  xC-w      xC        xC+w      xC+(w*2); 
       yC-(h/2)  yC-(h/2)  yC-(h/2)  yC-(h/2)  yC-(h/2)  yC-(h/2); 
       xC-(w*2)  xC-w      xC        xC+w      xC+(w*2)  xC+(w*3);
       yC+(h/2)  yC+(h/2)  yC+(h/2)  yC+(h/2)  yC+(h/2)  yC+(h/2)];

% 7-letters words
p7L = [xC-(w/2)-(w*3)  xC-(w/2)-(w*2)  xC-(w/2)-w  xC-(w/2)    xC+(w/2)      xC+(w/2)+(w)    xC+(w/2)+(w*2); 
       yC-(h/2)        yC-(h/2)        yC-(h/2)    yC-(h/2)    yC-(h/2)      yC-(h/2)        yC-(h/2); 
       xC-(w/2)-(w*2)  xC-(w/2)-(w)    xC-(w/2)    xC+(w/2)    xC+(w/2)+(w)  xC+(w/2)+(w*2)  xC+(w/2)+(w*3); 
       yC+(h/2)        yC+(h/2)        yC+(h/2)    yC+(h/2)    yC+(h/2)      yC+(h/2)        yC+(h/2)];

% 8-letters words
p8L = [xC-(w*4)  xC-(w*3)  xC-(w*2)  xC-w      xC        xC+w      xC+(w*2)  xC+(w*3); 
       yC-(h/2)  yC-(h/2)  yC-(h/2)  yC-(h/2)  yC-(h/2)  yC-(h/2)  yC-(h/2)  yC-(h/2); 
       xC-(w*3)  xC-(w*2)  xC-w      xC        xC+w      xC+(w*2)  xC+(w*3)  xC+(w*4);
       yC+(h/2)  yC+(h/2)  yC+(h/2)  yC+(h/2)  yC+(h/2)  yC+(h/2)  yC+(h/2)  yC+(h/2)];
