function out_tab = getSpaceLength(in_arr)
% GET SPACE LENGTH From a word, get the # of pixels for each space
%
% - in_str: the word as reference (where to get information)
% 
% As first, join the tables with words and non-words, no need to
% differentiate if we have the target string as an index.
% 
%

load('stimuli_post_selection.mat','stimuli');

% Join words and non-words tables, doesn't matter since we have to scroll
% thorugh everything
stimDataset = in_arr;
spaceSize = [];

for k = 1:size(stimDataset,1)
    
    thisLength = stimDataset{k,4};
    spaceSize(k) = round((stimuli.boxPresentation.max_absolute - thisLength) / 5);
    
end

out_tab = spaceSize';
end

