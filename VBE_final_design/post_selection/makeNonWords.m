function out_arr = makeNonWords(in_arr,code)

% Creation of nonwords froms an array of words

% Consistent mapping of pre-selected consonants to replace vowels. 
% Optimized for both French and Braille code.
%
% outarr = array of strings. Strings of consonants obtained from words
%
% inarr = array of words to be onverted into non-words. Accepted both
% strings (for french) and double (for braille)
%
% code = 'f' or 'b'. Char index to indicate wheter the set to convert is in
%        regular alphabet (french; f) or in braille (b). 
%
% MAPPING RULES:
% - french 
%   'a' -> 's'      'e' -> 'r'      'i' -> 'l'      'o' -> 'c'      'u' -> 'v'
%   Ignore accents, map them into the corresponding letter (e.g. à -> s)
%
% - braille
%   trickier. Accented letters don't resembe anymore the originals. We need to do them separately
%
%   01/03/21: not yet clear which accented letters will be used or not.
%   Tentative including all of them, if some will not be used, this mapping
%   can be rearranged to have closer matches.
%   a ⠁ (10241) -> b ⠃ (10243)      e ⠑ (10257) -> h ⠓ (10259) 
%   i ⠊ (10250) -> j ⠚ (10266)      o ⠕ (10261) -> r ⠗ (10263)
%   u ⠥ (10277) -> v ⠧ (10279)      é ⠿ (10303) -> y ⠽ (10301) 
%   à ⠷ (10295) -> z ⠵ (10293)      è ⠮ (10286) -> ç ⠯ (10287)
%   ù ⠾ (10302) -> t ⠞ (10270)		â ⠡ (10273) -> k ⠅ (10245)	
%   ê ⠣ (10275) -> l ⠇ (10247)      î ⠩ (10281) -> x ⠭ (10285)      
%   ô ⠹ (10297) -> p ⠏ (10255)      û ⠱ (10289) -> s ⠎ (10254)                   
%   ë ⠫ (10283) -> n ⠝ (10269)      ï ⠻ (10299) -> q ⠟ (10271)      
%   ü ⠳ (10291) -> w ⠺ (10298)
								   		
% Add check if the array is not ok

temp_arr = in_arr;

switch code
    case 'f'
        % Constant mapping:  Same goes for accented letters. 
        % new_fr has repeated letter because of the function: if there are
        % multiple arrays, they must have the same length. Goes 1-to-1
        old_fr = {'a','à','â','e','è','é','ê','i','î','ï','o','ò','ô','u','û','ü'};
        new_fr = {'s','s','s','r','r','r','r','l','l','l','c','c','c','v','v','v'}; 
        temp_arr = replace(in_arr,old_fr,new_fr);
        
    case 'b'
        % Constant mapping: better to not change them much from double
        old_br = {'a','e','i','o','u','é','à','è','ù','â','ê','î','ô','û','ë','ï','ü'};
        new_br = {'b','h','j','r','v','y','z','ç','t','k','l','x','p','s','n','q','w'};
        
        % with multiple arrays in both old and new, performas a 1-to-1 mapping
        % First convert vowels into consonants, according to different
        % mapping
        temp_arr = replace(in_arr,old_br,new_br);
        
        % Then convert them into braille
        temp_arr = brailify(temp_arr);
        
    otherwise % if code variable is wrong
        error('code selected is non-existent or not supported. Please use only ''f'' for french or ''b'' for braille');
end

out_arr = temp_arr;

end

