function [outList] = makeCSV(inList,name)
% MAKE CSV files - 
% Return a list of the words in a filename appropriate manner (no accents)
% and in the meantime saves the csv for each called string in the format
% psychopy wants for its conditions:
% dutch_word   braille_filename    connected_filename
% test         images/br_test.png  images/cb_test.png

% create output list
out = string;
csv = "";
csv(1,1) = "nlWrd"; csv(1,2) = "brWrd"; csv(1,3) = "cbWrd";

% create filename for csv
csv_fn = name;
 
% scroll through it
for iL = 1:size(inList,1)

    % get current stimulus
    thisStimulus = inList{iL};

    % add this line to the csv
    csv(iL+1,1) = thisStimulus;
    csv(iL+1,2) = ['images/br_' thisStimulus '.png'];
    csv(iL+1,3) = ['images/cb_' thisStimulus '.png'];

    % add the new filename to the others
    out = vertcat(out, thisStimulus);

end

% save csv file
writematrix(csv,csv_fn);

% return list of filenames
outList = out(2:end);

end
