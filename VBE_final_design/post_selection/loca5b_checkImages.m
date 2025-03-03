
% everchanging script to visualize rapidly the stimuli, to check the
% scrambling algorithm of words, images, or the position of the french and
% braille letters

for i=18:18
    
    figure;
    eval(['t = images.sfw.' char(stimuli.variableNames(i)) ';']);  imshow(t);
        
end
