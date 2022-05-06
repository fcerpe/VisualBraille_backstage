%% 1. Open and import lexique (xls file) into a MATLAB table
%  Later, add code to download it directly
clear;

addpath(genpath('/Users/cerpelloni/Desktop/GitHub/VB_backstage_code'))

load('lexique_datasets.mat');

%% 2. Selection of relevant words

% High frequency first, sorts by the most frequent (both films and books).
% Films, biggest corups and we don't care too much now
lex = sortrows(lex,'freqfilms2','descend');

% frequency
lex = lex(lex.freqfilms2 > 1,:);

% length of words
lex = lex(lex.nblettres >= 3 & lex.nblettres <= 7,:); % 3 to 7 letters

% number of phonemes: 2 to 5
lexPhon = [];
for iPhon = 1:size(lex,1)
    phonLen = length(char(lex.phon(iPhon)));
    if phonLen > 1 && phonLen < 6
        lexPhon = vertcat(lexPhon,lex(iPhon,:));
    end
end
lex = lexPhon;

% type of words: no onomatopes
lex = lex(lex.cgram ~= 'ONO',:);

lex = deleteRows(lex);

%% Letter-wise division 
% (run as stand-alone if it's not the first time)

% Divide by letters number
% split lexique entries into 4 arrays, each corresponding to a number
for i = 3:7
    this = struct;
    this.words = lex(lex.nblettres == i,:);

    % get 100 each, then slim manually. 
    % Aim is 300 in total. With around 5-10 seconds each, it means up to 
    % 50 minutes of training. Too much?
    % If there are less for 3L it's fine
    setUpRand();

    % get maximum random value from length of table and pick 20
    % just get the unique ones
    this.unique = unique(this.words); % order alphabetically
    for j = size(this.unique,1):-1:2
        if strcmp(this.unique.ortho{j}, this.unique.ortho{j-1}) %if same as precedent,
            this.unique(j,:) = []; % delete
        end
    end

    maxRand = size(this.unique,1);
    positions = randi(maxRand,[1 100]);
    wrds = this.words{positions, 1};
    this.pick = this.unique(positions, :);

    eval(['w' num2str(i) 'L = this;']);
end

% Loop 3-4 times to get different words, handpicked, then merge them all in
% one table and check cgram, lemma, ortho, to avoid repetitions
% 
% GOAL is to get 300 for training + 120 for testing

% get the 120 seen words
positions = 1:300;
shuffle(positions);
test_seenwords = training_words.ortho(positions(1:120));

%% Load french lexicon project and get those 120 psuedo-words
% HouseFot study uses "pronunceable nonwords" aka pseudowords
load('FLP_pseudo.mat');

flp = []; ps3 = []; ps4 = []; ps5 = []; ps6 = []; ps7 = [];

% get 3 to 7 letter ones and split them into different arrays
for i = 1:size(FLPpseudo,1)
    t = FLPpseudo.item{i};
    switch length(char(t))
        case 3, ps3 = vertcat(ps3,FLPpseudo.item(i)); flp = vertcat(flp,FLPpseudo.item(i));
        case 4, ps4 = vertcat(ps4,FLPpseudo.item(i)); flp = vertcat(flp,FLPpseudo.item(i));
        case 5, ps5 = vertcat(ps5,FLPpseudo.item(i)); flp = vertcat(flp,FLPpseudo.item(i));
        case 6, ps6 = vertcat(ps6,FLPpseudo.item(i)); flp = vertcat(flp,FLPpseudo.item(i));
        case 7, ps7 = vertcat(ps7,FLPpseudo.item(i)); flp = vertcat(flp,FLPpseudo.item(i));
    end
end

% get 30 each (120/5 = 24, plus some more to check)
for i = 3:7
    this = struct;
    eval(['this.words = ps' num2str(i) ';']);
    setUpRand();

    % get maximum random value from length of table and pick 20
    % just get the unique ones
    this.unique = unique(this.words); % order alphabetically

    maxRand = size(this.unique,1);
    positions = randi(maxRand,[1 30]);
    wrds = this.words{positions, 1};
    this.pick = this.unique(positions, :);

    eval(['ps' num2str(i) '_rand = this;']);
end

% MANUALLY CHECK PSEUDOWORDS: THERE COULD BE ENGLISH WORDS OR STUFF THAT
% ACQUIRED MEANING 

% combine in one variable 
test_pseudowords = vertcat(ps3_rand.pick, ps4_rand.pick, ps5_rand.pick, ps6_rand.pick, ps7_rand.pick);

%% Save dataset

save('train_selectSet.mat');

