
%% Make stimuli lists for training and test of each day
%
% Start from 280 words and 80 pseudowords
% Words: 
% - 200 for training, 
% - 20 for each testing day (novel words), 
% - 20 for each testing day (seen words).
% Should be balanced across letter length 

load('dutch_manual_selection.mat');

% Distribute the words in the training and test sets
% shuffle each letter length
words_4_letters = shuffle(words_4_letters);
words_5_letters = shuffle(words_5_letters);
words_6_letters = shuffle(words_6_letters);
words_7_letters = shuffle(words_7_letters);
words_8_letters = shuffle(words_8_letters);

% Last 16 (4 per day) will be part of the test set (novel words)
test_novel_words = vertcat(words_4_letters(41:end), words_5_letters(41:end), words_6_letters(41:end), words_7_letters(41:end), words_8_letters(41:end));

test_novel_d1 = vertcat(words_4_letters(41:44), words_5_letters(41:44), words_6_letters(41:44), words_7_letters(41:44), words_8_letters(41:44));
test_novel_d2 = vertcat(words_4_letters(45:48), words_5_letters(45:48), words_6_letters(45:48), words_7_letters(45:48), words_8_letters(45:48));
test_novel_d3 = vertcat(words_4_letters(49:52), words_5_letters(49:52), words_6_letters(49:52), words_7_letters(49:52), words_8_letters(49:52));
test_novel_d4 = vertcat(words_4_letters(53:56), words_5_letters(53:56), words_6_letters(53:56), words_7_letters(53:56), words_8_letters(53:56));

% First 16 (4 per day) will be part of the test set (seen words)
test_seen_words = vertcat(words_4_letters(1:16), words_5_letters(1:16), words_6_letters(1:16), words_7_letters(1:16), words_8_letters(1:16));

test_seen_d1 = vertcat(words_4_letters(1:4), words_5_letters(1:4), words_6_letters(1:4), words_7_letters(1:4), words_8_letters(1:4));
test_seen_d2 = vertcat(words_4_letters(5:8), words_5_letters(5:8), words_6_letters(5:8), words_7_letters(5:8), words_8_letters(5:8));
test_seen_d3 = vertcat(words_4_letters(9:12), words_5_letters(9:12), words_6_letters(9:12), words_7_letters(9:12), words_8_letters(9:12));
test_seen_d4 = vertcat(words_4_letters(13:16), words_5_letters(13:16), words_6_letters(13:16), words_7_letters(13:16), words_8_letters(13:16));

% First 40 will be part of the training set
training_words = vertcat(words_4_letters(1:40), words_5_letters(1:40), words_6_letters(1:40), words_7_letters(1:40), words_8_letters(1:40));

% Distribute the pseudowords 
pseudowords_4_letters = shuffle(pseudowords_4_letters);
pseudowords_5_letters = shuffle(pseudowords_5_letters);
pseudowords_6_letters = shuffle(pseudowords_6_letters);
pseudowords_7_letters = shuffle(pseudowords_7_letters);
pseudowords_8_letters = shuffle(pseudowords_8_letters);

test_pseudo_d1 = vertcat(pseudowords_4_letters(1:4), pseudowords_5_letters(1:4), pseudowords_6_letters(1:4), pseudowords_7_letters(1:4), pseudowords_8_letters(1:4));
test_pseudo_d2 = vertcat(pseudowords_4_letters(5:8), pseudowords_5_letters(5:8), pseudowords_6_letters(5:8), pseudowords_7_letters(5:8), pseudowords_8_letters(5:8));
test_pseudo_d3 = vertcat(pseudowords_4_letters(9:12), pseudowords_5_letters(9:12), pseudowords_6_letters(9:12), pseudowords_7_letters(9:12), pseudowords_8_letters(9:12));
test_pseudo_d4 = vertcat(pseudowords_4_letters(13:16), pseudowords_5_letters(13:16), pseudowords_6_letters(13:16), pseudowords_7_letters(13:16), pseudowords_8_letters(13:16));

% Assign each test stimulus to the corresponding test day
test_d1 = vertcat(test_seen_d1, test_pseudo_d1, test_novel_d1);
test_d2 = vertcat(test_seen_d2, test_pseudo_d2, test_novel_d2);
test_d3 = vertcat(test_seen_d3, test_pseudo_d3, test_novel_d3);
test_d4 = vertcat(test_seen_d4, test_pseudo_d4, test_novel_d4);

% get lists and files for each of them
list_test_d1 = makeCSV(test_d1,'output/test_d1.csv');
list_test_d2 = makeCSV(test_d2,'output/test_d2.csv');
list_test_d3 = makeCSV(test_d3,'output/test_d3.csv');
list_test_d4 = makeCSV(test_d4,'output/test_d4.csv');

list_training = makeCSV(training_words,'output/training_cond.csv');

