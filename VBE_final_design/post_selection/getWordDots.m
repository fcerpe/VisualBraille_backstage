function out_num = getWordDots(in_str, in_set)
% COMPUTE NUMBER OF DOTS FOR A WORD 

% Calculate the number of braille dots used to represent a given word
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
num = 0;

% for each letter, gets the position (ascii - 96)
for l = 1:length(char_array)
    
    % Look at the letters table and get the corresponding num of dots for that letter
    this_num = stimuli.braille.summary{strcmp(stimuli.braille.summary.fr_char,char_array(l)),4}; 
    
    % SUm it to the other ones
    num = num + this_num; % new added to tot

end

out_num = num;
end

