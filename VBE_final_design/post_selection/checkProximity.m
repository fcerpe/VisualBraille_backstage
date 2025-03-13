function out = checkProximity(in_coord, in_array, min)

% CHECK PROXIMITY 
% Checks if the coordinates are too close to existing ones
% Function made for the drawing of dots in the scrambled braille word
% condition. 
%
%   - output: boolean, the coordinates are apart-enough to allow drawing a
%             dot in that position
%   - in_coord: this coordinates x,y where to potentially draw
%   - in_array: all the other coordinates where dots are already drawn
%   - min: minimum distance, since we don't know what the font size will be

% X needs to be distant, and Y too. Distant means >= minimum
tooClose = false;

this_x = in_coord(1);
this_y = in_coord(2);

if size(in_array,1) > 0 % if array is empty, first dot is always ok
    i = 1;
    while ~tooClose && i <= size(in_array,1)
        % if their difference is lower than the minimum, they're too close
        if abs(this_x - in_array(i,1)) < min && abs(this_y - in_array(i,2)) < min
            tooClose = true;
        end
        i = i+1;
    end 
end

out = ~tooClose;

end

