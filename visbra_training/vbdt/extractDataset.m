function dutch = extractDataset()
%% extractDataset
%
% Take table files downloaded for crr.ugent.be and extract a common table
% with dutch words and the realative statistics

% Dutch lexion project 2
% http://crr.ugent.be/programs-data/lexicon-projects
% Lexical decision and word statistics of 30K dtuch words
dlp = readtable('datasets/DLP2_dataset_article_prevalence.xlsx');

% SUBTLEX-NL 
% http://crr.ugent.be/programs-data/subtitle-frequencies
% Word frequency obtained from dutch subtitles (both original and
% translated from english movies)
subtlex = readtable('datasets/SUBTLEX-NL.cd-above2.xlsx');

% 1. Delete unnecessary columns
% - in DLP2 we keep: word, length, SUBTLEX, PoS, N_phonemes, Word_prevalence1
dlp = removevars(dlp, {'Nsyl','SUBTLEX2','Acc_dlp2','RT_dlp2',...
                       'Concreteness','AoA','Word_prev_ratings','OLD20','Colt_N','PLD30','Colt_Nphon'});

% - in SUBTLEX we keep: Word, FREQcount, SUBTLEXWF
subtlex = removevars(subtlex, {'CDcount','FREQlow','CDlow','FREQlemma','Lg10WF','SUBTLEXCD','Lg10CD'});

% 2. Merge datasets
% Goal is a single dataset where words and subtlex index match
% - get the words in common between the datasets and extract a selection of them
subtlex_sel = subtlex(matches(subtlex.Woord, dlp.Woord),:);
dlp_sel = dlp(matches(dlp.Woord, subtlex.Woord),:);

% join the datasets to form a single table
dutch = join(dlp_sel,subtlex_sel,'Keys','Woord');

% delete redundant column
dutch = removevars(dutch, {'SUBTLEX','FREQcount'});

% save and return
save('dutch.mat', 'dutch');

end