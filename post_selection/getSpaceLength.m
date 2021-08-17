function out_tab = getSpaceLength(in_arr,box)
% GET SPACE LENGTH 
% From a word, get the # of pixels for each space

wList = in_arr; % list of words
spaceSize = [];

for k = 1:size(wList,1)
    
    wLength = wList.letterLength(k); % length of this word - only chars 
    nbLetters = length(char(wList.string(k)));
    
    % space size = (length of reference - length of single words) / number
    % of spaces (letters - 1)
    spaceSize(k) = round((box.references.length(nbLetters) - wLength) / (nbLetters-1));
    
end

out_tab = spaceSize';
end

