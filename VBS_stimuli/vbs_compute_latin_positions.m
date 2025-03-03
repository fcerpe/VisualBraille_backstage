function positions = vbs_compute_latin_positions(xC, yC, word, font)

% Compute single space width

% get width of all words - based on Braille widths
wordsWidth = [510, 690, 870, 1050, 1230, 1410];
wordsHeight = 250;

% get width of single letters, from vbs_letters/lt_* images metadata
switch font

    % Arial
    case 1 %             A   B   C   D   E   F   G   H  I  J   K  L   M   N   O   P   Q   R   S  T   U   V   W   X   Y   Z
        lettersWidth = [142,136,136,135,142,100,137,128,74,75,130,74,196,128,144,135,135,95,131,88,128,142,199,143,142,137];

    % Times New Roman
    case 2 %             A   B   C   D   E   F   G   H  I  J   K  L   M   N   O   P   Q   R   S  T   U   V   W   X   Y   Z
        lettersWidth = [124,138,117,139,118,121,135,143,80,92,146,81,217,144,130,139,138,107,100,91,146,142,196,140,144,125];

    % American Typewriter
    case 3 %             A   B   C   D   E   F   G   H  I   J   K  L   M   N   O   P   Q   R   S   T   U   V   W   X   Y   Z
        lettersWidth = [156,159,131,160,136,126,154,177,96,103,173,95,244,175,139,159,156,139,125,117,174,175,223,176,179,135];

    % Futura
    case 4 %             A   B   C   D   E  F   G   H  I  J   K  L   M   N   O   P   Q  R   S  T   U   V   W   X   Y   Z
        lettersWidth = [135,135,115,135,130,87,135,118,58,58,123,52,174,118,140,135,135,96,102,81,118,136,198,150,146,144];

end
lettersHeight = 250;

% Compute the total width of the single letters 
maxWidth = wordsWidth(length(word)-2);
lettersCombined = 0;

% Sum the widths of each letter
for iL = 1:length(word)
    lettersCombined = lettersCombined + lettersWidth(int8(word(iL)-96));
end

% Subtract the letters width for the max width of the word
totalSpaceWidth = maxWidth - lettersCombined;

% Divide the total space by the amount of spaces
spaceWidth = round(totalSpaceWidth / (length(word)-1));


% Attribute the positions of the letters based on single letters widths and spaces

% Start the arrays for each dimension
startX = [];
startY = [];
endX = [];
endY = [];

% Start the counter of X positions
totalX = 0;

for iL = 1:length(word)
    
    % Add starting point
    startX = [startX, totalX];
    startY = [startY, 0];

    % Add width of current letter to the total
    thisWidth = lettersWidth(int8(word(iL)-96));
    totalX = totalX + thisWidth;

    % Add ending point
    endX = [endX, totalX];
    endY = [endY, 250];

    % Add space
    totalX = totalX + spaceWidth;

end

% Shift the positions according to the center of the screen (and the length
% of the word) 
startX = startX + xC - (maxWidth / 2);
startY = startY + yC - (lettersHeight / 2);
endX = endX + xC - (maxWidth / 2);
endY = endY + yC - (lettersHeight / 2);

% Collect the positions in a single variable
positions = [startX; 
             startY;
             endX;
             endY];
