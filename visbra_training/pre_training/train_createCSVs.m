
%% Make single datasets for every day of testing
% each one should have 60 stimuli: 
% - 20 seen words, 
% - 20 novel words, 
% - 20 pseudowords
load('visbra_training_set.mat');


% shuffle all arrays independently
test_seenwords = shuffle(test_seenwords);
test_pseudowords = shuffle(test_pseudowords);
test_newwords = shuffle(test_newwords);

% put them in different arrays based on training day
test_d2 = vertcat(test_seenwords(1:20),    test_pseudowords(1:20),    test_newwords(1:20));
test_d3 = vertcat(test_seenwords(21:40),   test_pseudowords(21:40),   test_newwords(21:40));
test_d4 = vertcat(test_seenwords(41:60),   test_pseudowords(41:60),   test_newwords(41:60));
test_d5 = vertcat(test_seenwords(61:80),   test_pseudowords(61:80),   test_newwords(61:80));
test_d6 = vertcat(test_seenwords(81:100),  test_pseudowords(81:100),  test_newwords(81:100));
test_d7 = vertcat(test_seenwords(101:120), test_pseudowords(101:120), test_newwords(101:120));

% get lists and files for each of them
fn_d2 = makeCSV(test_d2,'test_d2.csv');
fn_d3 = makeCSV(test_d3,'test_d3.csv');
fn_d4 = makeCSV(test_d4,'test_d4.csv');
fn_d5 = makeCSV(test_d5,'test_d5.csv');
fn_d6 = makeCSV(test_d6,'test_d6.csv');
fn_d7 = makeCSV(test_d7,'test_d7.csv');

fn_train = makeCSV(string(training_words.ortho),'training_cond.csv');

fn_phrases = makeCSV(phrases_elements,'phrases.csv');

save('visbra_training_set.mat');





