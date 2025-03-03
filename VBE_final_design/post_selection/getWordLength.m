function out_num = getWordLength(in_str, in_set, changeFont)
% COMPUTE WORD LENGTH Length in pixels of a given word

% Calculate the length in pixels of a given word, functional to presentation box
% Length is obtained by the sum of the single lengths of letters composing
% the word itself.
% The whole is different from the sum of its parts, yes. But we need to
% manipulate spaces, so the pre-existing ones between letters do not matter
% here. 
% For (each) word:
% - splits it into the single letters
% - map letters into the coordinates for the least rectangle around it
% (refer to frBr tables, already computed)
% - calculate x difference (x position of the second point - x position of
% the first point)
% - sum them to obtain the word length on the x axis

stimuli = in_set;

char_array = char(split(in_str,''));
char_array = char_array(2:length(char_array)-1); %removes first and last empty chars

% Total length in pixels of the letters
tot_length = 0;

% with fakescript, refer to the new letters
if changeFont
    stimuli.box.letters = stimuli.box.fakeletters;
end

% for each letter, gets the position (ascii - 96)
for l = 1:length(char_array)
    
    % Look at the letters table and get the corresponding length
    this_length = stimuli.box.letters{stimuli.box.letters.char == char_array(l),3}; 
    
    % SUm it to the other ones
    tot_length = tot_length + this_length; % new (end X - begin X) added to tot

end

out_num = tot_length;
end

