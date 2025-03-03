function out_str = brailify(in_str, in_conv)
%BRAILIFY Converts a string from french alphabet to french expressed in braille
%   Char referring to french letters (even all the accented ones) are
%   replaced by braille chars

% Order of braille unicode kept for simplicity.
% IMPORTANT: LOWERCASE ONLY (for the moment at least)

% Load workspace containing mapping between characters
stimuli = in_conv;

fr = stimuli.conversion{:,1};
br = stimuli.conversion{:,2};

% replace each french letter to the corresponding braille character
temp_str = replace(in_str,fr,br);

out_str = temp_str;

end

