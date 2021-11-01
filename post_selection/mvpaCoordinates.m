function [outChar, outArray] = mvpaCoordinates(inWord, t, num)
% MAKE COORDINATES
%
% From a word (and its infos) get the coordinates of where every letter
% should start.
% Refers to the stimuli.boxPresentation structure, that should be passed as
% the input variable t

inChar = char(inWord.string);

% How many letters
% Get the single letters and their infos
for l = 1:length(inChar)
    let(l,:) = t.letters(t.letters.char == inChar(l),:);
end

% Final array in the making, to store X and Y coordinates of each letter
coords = zeros(length(inChar),2);

w_x = t.rect(3);
w_y = t.rect(4);

% Get reference length, length of braille word of the same number of chars
ref_length = t.references.length(length(inChar));

% X and Y positions for every letter
% First is manual: 
% X = half of the screen size - half of the reference length - where the letter starts 
coords(1,1) = w_x/2 - (ref_length/2) - let{1,2}{1}(1);
coords(1,2) = w_y/2 - let{1,2}{1}(2) + 26 -6; % 26 is height of a letter without 'extensions' at font 50

% Each letter from 2 to 8, if the word is that long
for c = 2:length(inChar)
    coords(c,1) = coords(c-1,1) + let.length(c-1) + inWord.spaceLength;
    coords(c,2) = w_y/2 - let{c,2}{1}(2) + 26 -6; 
end
 
if startsWith(inWord.string,"balcon") % balcon
    coords(3,1) = coords(3,1) +3;
    coords(4,1) = coords(4,1) +6;   
elseif startsWith(inWord.string,"poulet")
    coords(2,1) = coords(2,1) -2;
    coords(3,1) = coords(3,1) -7;
    coords(4,1) = coords(4,1) -6;
    coords(5,1) = coords(5,1) -4;
elseif startsWith(inWord.string,"poclet")
    coords(3,1) = coords(3,1) -6;
elseif startsWith(inWord.string,"chalet")
    coords(3,1) = coords(3,1) -5;
    coords(4,1) = coords(4,1) -3;
elseif startsWith(inWord.string,"sommet")
    coords(3,1) = coords(3,1) -5;
    coords(4,1) = coords(4,1) -4;   
elseif startsWith(inWord.string,"vamlon")
    coords(2,1) = coords(2,1) -6;
    coords(3,1) = coords(3,1) -16;
    coords(4,1) = coords(4,1) -15;
    coords(5,1) = coords(5,1) -5;
elseif startsWith(inWord.string,"solmet")
    coords(3,1) = coords(3,1) +5;
    coords(4,1) = coords(4,1) +10;
    coords(5,1) = coords(5,1) +3;     
end

outChar = inChar;
outArray = coords;

end

