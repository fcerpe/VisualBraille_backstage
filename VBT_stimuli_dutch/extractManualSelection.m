function extractManualSelection()

% read txt files
words = readtable('datasets/vbt_mock_words.txt');
pseudowords = readtable('datasets/vbt_mock_pseudowords.txt');

% divide the set according to the number of letters they have:
% 4 letters -> words 1:56, pseudowords 1:16
words_4_letters = [];
pseudowords_4_letters = [];
% 5 letters -> words 57:112, pseudowords 17:32
words_5_letters = [];
pseudowords_5_letters = [];
% 6 letters -> words 113:168, pseudowords 33:48
words_6_letters = [];
pseudowords_6_letters = [];
% 7 letters -> words 169:224, pseudowords 49:64
words_7_letters = [];
pseudowords_7_letters = [];
% 8 letters -> words 225:280, pseudowords 65:80
words_8_letters = [];
pseudowords_8_letters = [];

% scroll through the dataset and divide the stimuli
for i = 1:size(words,1)
    eval(['words_' num2str(length(words.WORDS{i})) '_letters = vertcat(words_' num2str(length(words.WORDS{i})) '_letters, words.WORDS(i));']);
end

% do the same for pseudowords 
for i = 1:size(pseudowords,1)
    eval(['pseudowords_' num2str(length(pseudowords.PSEUDOWORDS{i})) '_letters = ' ...
        'vertcat(pseudowords_' num2str(length(pseudowords.PSEUDOWORDS{i})) '_letters, pseudowords.PSEUDOWORDS(i));']);
end

% save everything
save('dutch_manual_selection.mat', 'words_4_letters','words_5_letters','words_6_letters','words_7_letters','words_8_letters', ...
                                   'pseudowords_4_letters','pseudowords_5_letters','pseudowords_6_letters','pseudowords_7_letters','pseudowords_8_letters');

end

