function [outList] = makeCSV(inList,name)
% MAKE CSV - 
% Return a list of the words in a filename appropriate manner (no accents)
% and in the meantime saves the csv for each called string in the format
% psychopy wants for its conditions:
% french_word   braille_filename    connected_filename
% tést          images/br_test.png  images/cb_test.png

% create output list
out = string;
csv = "";
csv(1,1) = "frWrd"; csv(1,2) = "brWrd"; csv(1,3) = "cbWrd";

% create filename for csv
csv_fn = name;
 
% scroll through it
for iL = 1:size(inList,1)

    % get current stimulus
    thisWord = inList(iL);

    % make it finder-appropriate
    thisOut = changeLetters(thisWord);    

    % add this line to the csv
    csv(iL+1,1) = thisWord;
    csv(iL+1,2) = "images/br_" + thisOut + ".png";
    csv(iL+1,3) = "images/cb_" + thisOut + ".png";

    % add the new filename to the others
    out = vertcat(out, thisOut);

end

% save csv file
writematrix(csv,csv_fn);

% return list of filenames
outList = out(2:end);

end


function outStr = changeLetters(inStr)
% Actual letter change, just replace it
inC = char(inStr);
outStr = "";
for iS = 1:length(inC)
    switch inC(iS)
        case {'à','â'},         outChar = 'a';
        case 'ç',               outChar = 'c';
        case {'è','ê','ë','é'}, outChar = 'e';
        case {'î','ï'},         outChar = 'i';
        case 'ô',               outChar = 'o';
        case {'ù','û','ü'},     outChar = 'u';
        otherwise,              outChar = inC(iS);
    end
    outStr = strcat(outStr,outChar);
end
end
