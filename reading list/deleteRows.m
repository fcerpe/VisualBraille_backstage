function out_tab = deleteRows(in_tab)
% DELETE ROWS From a table, delete all the rows that fit our criterium
% Suited only for InfraGrPh and lexFreq in readingList.m, clears all the
% rows with a repeated entry (same word as the previous one). 

% FOR FUTURE: IF WE NEED TO DISTINGUISH BETWEEN TYPES OF WORDS (ADJ, NOM,
% ETC) ALSO LOOK FOR MATCHING 'cgram'

toDel = [];
temp_tab = in_tab;
% Deletes doubes (we don't care)
for i = size(temp_tab,1):-1:2
    % Try to split for spaces or -
    nbWords_current = size(split(temp_tab{i,1},[" ","-"]));
    
    % if one entry is the same as the previous one OR
    % if the word is composed (e.g. "afin que"), mark it
    if matches(temp_tab{i,1}, temp_tab{i-1,1}) || nbWords_current(1) > 1
       toDel = horzcat(toDel,i);
    end
end
% Deletes duplicate rows
temp_tab(toDel,:) = [];


out_tab = temp_tab;
end

