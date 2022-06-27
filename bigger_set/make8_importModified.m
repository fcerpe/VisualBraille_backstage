% MAKE STIMULI - 8
% Import images of fake script and save .mat to be used in VisualBraille

clear

% latest step in the non-automatic pipeline
load('word_visualizeStimuli.mat');

% get images from the stimuli_imgs folder
% those images have to be put manually, at least the first time
files = dir('stimuli_imgs');

for f = 3:size(files,1)
    name = files(f).name;
    condition = name(1:3);
    if length(name) == 10
        number = name([5 6]);
    elseif length(name) == 11
        number = name([5 6 7]);
    end

    % read img and save it
    eval(['images.' char(condition) '.' char(number) ' = imread(''stimuli_imgs/' char(name) ''');']);
end
% save them into the images struct
save('blockMvpa_stimuli.mat','images','stimuli');
save('../../VisualBraille/inputs/blockMvpa_stimuli.mat','images','stimuli');

% save everything both here and in the VisualBraille folder automatically