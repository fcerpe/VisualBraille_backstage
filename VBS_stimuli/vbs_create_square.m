function arrayOut = vbs_create_square(arrayIn)

% From biggest size of input array (words are long and thin), create square
% frame
squareSide = max(size(arrayIn));
arrayOut = uint8(255 * ones(squareSide, squareSide, 3));

% From first size, find the position to center the word on the square
wordHeight = size(arrayIn, 1);

% Calculate the starting row to place the smaller array in the center
startRow = (squareSide - wordHeight) / 2 + 1;

% Insert the smaller array into the larger array
arrayOut(startRow:startRow + wordHeight - 1, :, :) = arrayIn;





