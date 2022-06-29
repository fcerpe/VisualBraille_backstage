% images have to bein downloads for this to work 
prescanner_braille = imread('../../../../Downloads/prescanner_braille.png');
prescanner_french = imread('../../../../Downloads/prescanner_french.png');

save('prescan_imgs.mat');
save('../../VisualBraille/inputs/prescan_imgs.mat');