%% Set up the environment

clear;
clc;

addpath(genpath('/Users/cerpelloni/Desktop/GitHub/VB_backstage_code'))

% check if the dataset is already extracted. If not, do it
if isempty(dir('dutch.mat'))
    dutch = extractDataset();
else
    load("dutch.mat");
end

%% Summary of the datasets
% The final dataset should contain words that are:
% - 4 to 8 letters long
% - frequent (more than 2/million) and prevalent (more than 1.65)
% - made of 2 to 5 phonemes

% 1. length of words
% minimum 4 and maximum 8 letters
dutch = dutch(dutch.Length >= 4 & dutch.Length <= 8,:);

% 2. frequency AND prevalence, both should be considered.
% For a explanation of word prevalance, see https://doi.org/10.1037/xhp0000159
dutch = dutch(dutch.SUBTLEXWF >= 2 & dutch.Word_prevalence1 >= 1.65,:);

% 3. Number of phonemes
dutch = dutch(dutch.N_phonemes >= 2 & dutch.N_phonemes <= 6,:);

% 4. Lemma or not, already implemented by the dataset itself:
% "In the present study, we examined the impact of the measure by 
% collecting lexical decision times for 30,000 Dutch word lemmas 
% of various lengths (the Dutch Lexicon Project 2)" (from the abstract)


%% Divide the set into letters clusters 
% (run as stand-alone if it's not the first time)

% Divide by letters number
for i = 4:8
    % save chunk of words into specific variable
    eval(['worden_' num2str(i) '_letters = dutch(dutch.Length == i,:);']);

    tempWords = dutch(dutch.Length == i,:);
    tempWords = sortrows(tempWords,'Woord','ascend'); % order alphabetically

    % Total set requires 280 words, ideally 56 per word length.
    % Pick a random selection of twice the final set, to be checked manually
    % Pick 112 random indexes among the words we have
    rng;
    positions = 0;
    maxRand = size(tempWords,1);
    while unique(positions) ~= 112
        positions = randi(maxRand,[1 112]);
    end
    selection = tempWords(positions, :);

    eval(['selection_' num2str(i) '_letters = selection;']);

end

%% Finalize the set

% Merge the different subsets into one
worden_selected = vertcat(selection_4_letters, ...
                          selection_5_letters, ...
                          selection_6_letters, ...
                          selection_7_letters, ...
                          selection_8_letters);

% Print to excel file and save dataset
writetable(worden_selected,'output/vbt - dutch words first selection.xlsx');
save('dutch_first_selection.mat','dutch','worden_4_letters','worden_5_letters','worden_6_letters', ...
                                 'worden_7_letters','worden_8_letters','worden_selected');

