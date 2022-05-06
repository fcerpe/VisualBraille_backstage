
clear

% get to the folder
path = "C:\Users\filip\Documents\Gin\VisualBraille\analysis\inputs\raw\sub-003\ses-001\func";

% run for each events.tsv 
fileName = "sub-003_ses-001_task-visualEventRelated_run-007_events.tsv";
fullpath = "C:\Users\filip\Documents\Gin\VisualBraille\analysis\inputs\raw\sub-003\ses-001\func\" + fileName;
thisTSV = importEvents(fullpath);

% in every line
for i = 1:size(thisTSV,1)
    img = split(string(thisTSV.image(i)),'_');
    if size(img,1) == 2 % either F or B
        if img(2) == "B"
            thisTSV.trial_type(i) = 'braille';
        else
            thisTSV.trial_type(i) = 'french';
        end
    else % only one element, so "null"
        thisTSV.trial_type(i) = 'blank';
    end
end

fullpath = fullpath + "_trial";
writetable(thisTSV, fullpath)