%% Pipeline of creating stimuli - part 6 (final?)
% Get pixel sizes and resize those who are too long but not too dense
%  1. get values for words (which ones? both)
%  2. get values for LD 
%  3. manually choose and resize to the dimensions of 4-5-6-7-8 long words
%
% Split the dataset in two so it's easier to present them in the scanner
clear
load('localizer_sota1019.mat');

% Calc pixel value for each (intact) stimulus
for i=1:length(stimuli.variableNames)
    
    % Define your images
    % F W
    eval(['fw = images.fw.' char(stimuli.variableNames(i)) ';']);    
    % Convert them in grayscale, easier approach
    fw_gray = rgb2gray(fw);
    % Calculate
    fw_totpx = numel(fw_gray);             % total number of pixel of img
    fw_notBlk = length(fw_gray(fw_gray~=0));  % number of pixel not black of img
    
    stimuli.px_dimensions.fw_pixels(i) = fw_notBlk;
  
    % B W
    eval(['bw = images.bw.' char(stimuli.variableNames(i)) ';']);    
    bw_gray = rgb2gray(bw);
    bw_totpx = numel(bw_gray);             % total number of pixel of img
    bw_notBlk = length(bw_gray(bw_gray~=0));
    
    switch i 
        case {1,2,3,4}
            stimuli.px_dimensions.bw_size{i} = stimuli.box.references.coord{4};
        case {5,6,7,8}
            stimuli.px_dimensions.bw_size{i} = stimuli.box.references.coord{5};
        case {9,10,11,12}
            stimuli.px_dimensions.bw_size{i} = stimuli.box.references.coord{6};
        case {13,14,15,16}
            stimuli.px_dimensions.bw_size{i} = stimuli.box.references.coord{7};
        case {17,18,19,20}
            stimuli.px_dimensions.bw_size{i} = stimuli.box.references.coord{8};
    end
    
    stimuli.px_dimensions.bw_pixels(i) = bw_notBlk;
    
    % L D
    eval(['ld = images.ld.' char(stimuli.variableNames(i)) ';']);
%     if i == 5 || i == 16 || i == 20
%         eval(['ld = images.tmp.' char(stimuli.variableNames(i)) ';']);
%     end
    ld_gray = rgb2gray(ld);
    ld_totpx = numel(ld_gray);             % total number of pixel of img
    ld_wht = length(ld_gray(ld_gray > 20));
    
    stimuli.px_dimensions.ld_pixels(i) = ld_wht;    
  
end

px_fw = table2array(stimuli.px_dimensions(:,3));
px_bw = table2array(stimuli.px_dimensions(:,5));
px_ld = table2array(stimuli.px_dimensions(:,7));

[mean(px_fw), mean(px_bw), mean(px_ld)]

[ht3, pt3] = ttest(px_fw,px_bw)
[ht3, pt3] = ttest(px_bw,px_ld)
[ht3, pt3] = ttest(px_fw,px_ld) 

% All significant or almost (0.07). Not good



save('localizer_sota_1026.mat');

% antialias / import images / cast as white 