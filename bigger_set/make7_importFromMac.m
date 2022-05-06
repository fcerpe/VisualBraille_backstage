%% import from mac

clear

load('word_ffs.mat');

% get what to copy
ffs = images.ffs;
french.fakescript = stimuli.french.fakescript;
box.fakeletters = stimuli.box.fakeletters;
box.fs = stimuli.box.fs;
box.fakefont = stimuli.box.fakefont;
box.fakesize = stimuli.box.fakesize;
box.max_fs = stimuli.box.max_fs;

% copy stimuli stuff
load('word_sota.mat');
stimuli.french.fakescript = french.fakescript;
stimuli.box.fakeletters = box.fakeletters;
stimuli.box.fakefont = box.fakefont;
stimuli.box.fakesize = box.fakesize;
stimuli.box.max_fs = box.max_fs;

for i = 1:12
    eval(['images.ffs.w' char(num2str(i)) ' = imresize(ffs.w' char(num2str(i)) ',[200 NaN]);']);
end

stimuli = rmfield(stimuli, 'variableNames');
stimuli.french = rmfield(stimuli.french,'words');
stimuli.braille = rmfield(stimuli.braille,'words');
stimuli.box = rmfield(stimuli.box,'words');

save('blockMvpa_stimuli.mat','stimuli','images');





