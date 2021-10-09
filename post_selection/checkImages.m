
for i=1:20
   
    figure;
    eval(['t = images.sld.' char(stimuli.variableNames(i)) ';']);
    imshow(t);
    
end
