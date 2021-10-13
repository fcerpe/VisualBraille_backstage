
for i=20:-1:1
    
    word = char(stimuli.variableNames(i));
    
    figure;
    subplot(3,2,1)
    eval(['t = images.fw.' word ';']);  imshow(t);
    
    subplot(3,2,2)
    eval(['t = images.sfw.' word ';']);  imshow(t);
    
    subplot(3,2,3)
    eval(['t = images.bw.' word ';']);  imshow(t);
    
    subplot(3,2,4)
    eval(['t = images.sbw.' word ';']);  imshow(t);
    
    subplot(3,2,5)
    eval(['t = images.ld.' word ';']);  imshow(t);
    
    subplot(3,2,6)
    eval(['t = images.sld.' word ';']);  imshow(t);
    
end
