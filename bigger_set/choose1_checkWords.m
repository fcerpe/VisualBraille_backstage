%% CHECK WORDS
%
% see if the stimuli we chose from pickWords.m are good.
%
% 1. for words, check their orthographic and phonological (dis)similarity
%    simple levensthein? just number of shared properties?
%
% 2. for pseudowords, check that they are not too close to actual known
%    words. We want to avoid to remind people of words
%    simple levensthein should be good, between 6L psuedowords and 4-5-6-7
%    phonemes long words
%    

clear

% add path of general backstage_code
addpath(genpath('/Users/cerpelloni/Desktop/GitHub/VB_backstage_code'));

% get main lexique, for pseudowords check
load('LexiqueAndInfra_oldSelection.mat','lex');

% load essential stuff
load('first_selection.mat','allBi','allLet','allTri','selLet','selLiving','selNonLiving', ...
                           'selPseudo','selTri','selWords','selBi','words');

% will write on tables
warning('off')

%% WORDS - RDMs of stimuli
% 
% Based on orthography, phonology, semantics

% get selection of words and all their details from lexique
selLv = table; selNl = table;

for l = 1:size(lex,1)
    thisW = lex.ortho{l};

    % if the word is one of the selected ones for living category
    if lex.cgram(l) == 'NOM'
        if any(strcmp(thisW, selLiving))
            selLv = vertcat(selLv, lex(l,:));
        elseif any(strcmp(thisW, selNonLiving)) % or if one of the objects
            selNl = vertcat(selNl, lex(l,:));
        end
    end
end


% slim the tables, add the relevant pieces, join together
selLv = removevars(selLv, {'lemme','cgram','genre','nombre','freqlivres','islem','nblettres','nbsyll','deflem','defobs'});
selNl = removevars(selNl, {'lemme','cgram','genre','nombre','freqlivres','islem','nblettres','nbsyll','deflem','defobs'});

selLv.sem(:) = categorical({'living'});
selNl.sem(:) = categorical({'non living'});

manualSel = vertcat(selLv, selNl);


% make matrices
length = size(manualSel,1);
for n = 1:length
    for o = 1:length        
        % Semantics (easy): RDM so we want to know if they are different
        mat.first.sem(n,o) = manualSel.sem(n) ~= manualSel.sem(o);
        
        % Phonology: simple lev and wieghted lev
        mat.first.phon(n,o) = lev(char(manualSel.phon(n)), char(manualSel.phon(o)));
        mat.first.phonLev(n,o) = levPhonW(char(manualSel.phon(n)), char(manualSel.phon(o)));

        % Orthography: simple lev
        mat.first.ortho(n,o) = lev(manualSel.ortho{n}, manualSel.ortho{o});
    end
end

% extract triangle for correlations
mat.first.tri_sem = mat.first.sem(triu(true(size(mat.first.sem)),1));
mat.first.tri_ortho = mat.first.ortho(triu(true(size(mat.first.ortho)),1));
mat.first.tri_phon = mat.first.phon(triu(true(size(mat.first.phon)),1));
mat.first.tri_phonLev = mat.first.phonLev(triu(true(size(mat.first.phonLev)),1));

% Correlations between RDMs
mat.first.corr = corrcoef([mat.first.tri_sem, mat.first.tri_ortho, mat.first.tri_phon, mat.first.tri_phonLev]);

% Write correlations in a .xlsx file, just in case
writematrix(mat.first.corr,'corr_firstSelection.xlsx');

clearvars l length n o thisW 


%% show graphics (can skip if not needed)

% labels
mat.first.labels = string(manualSel.ortho);

% plots
figure;
mat.first.htmp_sem = heatmap(mat.first.labels, mat.first.labels, double(mat.first.sem), ...
                       'CellLabelColor','none','Colormap',parula,'ColorScaling','scaledcolumns', ...
                           'Units','pixels','Position',[40 40 750 750]);
figure;
mat.first.htmp_ortho = heatmap(mat.first.labels, mat.first.labels, mat.first.ortho, ...
                         'CellLabelColor','none','Colormap',parula,'ColorScaling','scaledcolumns', ...
                           'Units','pixels','Position',[40 40 750 750]);
figure;
mat.first.htmp_phon = heatmap(mat.first.labels, mat.first.labels, mat.first.phon, ...
                        'CellLabelColor','none','Colormap',parula,'ColorScaling','scaledcolumns', ...
                           'Units','pixels','Position',[40 40 750 750]);
figure;
mat.first.htmp_phonLev = heatmap(mat.first.labels, mat.first.labels, mat.first.phonLev, ...
                           'CellLabelColor','none','Colormap',parula,'ColorScaling','scaledcolumns', ...
                           'Units','pixels','Position',[40 40 750 750]);

%% choose 10 words per group (how??)
%
% 'cafard' too similar to 'canard'
% 'limace' randomly
% 'mouton' too phon close to faucon and saumon
% 'fouine' too phon similar to 'faucon'
% 'truite' too similar to 'tortue'
%
% 'ballon' too mant -on elements 
% 'blouse' too close to 'bouton'
% 'bureau' other category, too big
% 'caisse' too similar to
% 'canapé' too similar to 'caméra'
% 'moteur' too big
% 'rideau' too phon close to many other words
% 'tiroir' too similar to 'miroir'

chosenStimuli = manualSel([2 3 4 6 9:14 18 21 23:26 28 30 32 33], :);

% compute RDMs again on selection
length = size(chosenStimuli,1);
for n = 1:length
    for o = 1:length        
        % Semantics (easy): RDM so we want to know if they are different
        mat.chosen.sem(n,o) = chosenStimuli.sem(n) ~= chosenStimuli.sem(o);
        
        % Phonology: simple lev and wieghted lev
        mat.chosen.phon(n,o) = lev(char(chosenStimuli.phon(n)), char(chosenStimuli.phon(o)));
        mat.chosen.phonLev(n,o) = levPhonW(char(chosenStimuli.phon(n)), char(chosenStimuli.phon(o)));

        % Orthography: simple lev
        mat.chosen.ortho(n,o) = lev(chosenStimuli.ortho{n}, chosenStimuli.ortho{o});
    end
end

% extract triangle for correlations
mat.chosen.tri_sem = mat.chosen.sem(triu(true(size(mat.chosen.sem)),1));
mat.chosen.tri_ortho = mat.chosen.ortho(triu(true(size(mat.chosen.ortho)),1));
mat.chosen.tri_phon = mat.chosen.phon(triu(true(size(mat.chosen.phon)),1));
mat.chosen.tri_phonLev = mat.chosen.phonLev(triu(true(size(mat.chosen.phonLev)),1));

% Correlations between RDMs
mat.chosen.corr = corrcoef([mat.chosen.tri_sem, mat.chosen.tri_ortho, mat.chosen.tri_phon, mat.chosen.tri_phonLev]);

% Write correlations in a .xlsx file, just in case
writematrix(mat.chosen.corr,'corr_chosenStimuli.xlsx');

%% again graphics (can skip if not needed)

% labels
mat.chosen.labels = string(chosenStimuli.ortho);

% plots
figure;
mat.chosen.htmp_sem = heatmap(mat.chosen.labels, mat.chosen.labels, double(mat.chosen.sem), ...
                       'CellLabelColor','none','Colormap',parula,'ColorScaling','scaledcolumns', ...
                           'Units','pixels','Position',[40 40 750 750]);
figure;
mat.chosen.htmp_ortho = heatmap(mat.chosen.labels, mat.chosen.labels, mat.chosen.ortho, ...
                         'CellLabelColor','none','Colormap',parula,'ColorScaling','scaledcolumns', ...
                           'Units','pixels','Position',[40 40 750 750]);
figure;
mat.chosen.htmp_phon = heatmap(mat.chosen.labels, mat.chosen.labels, mat.chosen.phon, ...
                        'CellLabelColor','none','Colormap',parula,'ColorScaling','scaledcolumns', ...
                           'Units','pixels','Position',[40 40 750 750]);
figure;
mat.chosen.htmp_phonLev = heatmap(mat.chosen.labels, mat.chosen.labels, mat.chosen.phonLev, ...
                           'CellLabelColor','none','Colormap',parula,'ColorScaling','scaledcolumns', ...
                           'Units','pixels','Position',[40 40 750 750]);


%% PSEUDOWORDS
%
% we can pick somewaht randomly. 
% Already skimmed for the ones with frequent features

%% 1. check that they are not close to ANY 5-6-7 letters long word.
%
% Make rdms for orthographic similarity (we don't have phonological data)

% get words
lex = sortrows(lex,'freqfilms2','descend');
% frequency
lex = lex(lex.freqfilms2 > 2,:);
% length of words
lex = lex(lex.nblettres >= 5 & lex.nblettres <= 7,:); % 5 to 7 letters
% type of words: no onomatopes
lex = lex(lex.cgram ~= 'ONO',:);
lex = deleteRows(lex);

% apply selection to our control variable
controlWords = lex;

% exclude chosen words from control words
toDel = [];
for c = 1:size(controlWords,1)
    
    % if the word is contained in the stimuli set
    if any(strcmp(string(controlWords.ortho{c}), mat.chosen.labels'))
        toDel = horzcat(toDel,c);
        disp('inside')
    end
end
% delete them
controlWords(toDel,:) = [];


% make rdm-like matrix:
% pseudowords, then control words, then chosen words
%    1:3350       3351:10690          10691:10710
joinWords = vertcat(selPseudo, string(controlWords.ortho), mat.chosen.labels);
mat.pseudo.ortho = zeros(size(selPseudo,1),size(joinWords,1));

for p = 1:size(selPseudo,1)
    for w = 1:size(joinWords,1)
        mat.pseudo.controlOrtho(p,w) = lev(char(joinWords(p)),char(joinWords(w)));
    end
end

% get, for each pseudoword, the average distances:
% - from the chosen words
% - from all the others 
mat.pseudo.distances = table;

% get distances: in controlWords
for p = 1:size(selPseudo,1)
    mat.pseudo.distances.pseudo(p) = selPseudo(p);
    mat.pseudo.distances.distChosen(p) = mean(mat.pseudo.controlOrtho(p,10691:end));
    mat.pseudo.distances.distControl(p) = mean(mat.pseudo.controlOrtho(p,3351:10690));
    
    % check on minimum distance, should not be too close to unwanted words
    % only keep track for now
    mat.pseudo.distances.minControl(p) = min(mat.pseudo.controlOrtho(p,3351:10690));
    whichPos = find(mat.pseudo.ortho(p,3351:10690) == min(mat.pseudo.controlOrtho(p,3351:10690)),1);
    mat.pseudo.distances.whichControl(p) = joinWords(3350 + whichPos);

    mat.pseudo.distances.minChosen(p) = min(mat.pseudo.controlOrtho(p,10691:end));
    whichPos = find(mat.pseudo.ortho(p,10691:10710) == min(mat.pseudo.controlOrtho(p,10691:10710)),1);
    mat.pseudo.distances.whichChosen(p) = joinWords(10690 + whichPos);

    % ad-hoc: distance from flacon
    mat.pseudo.distances.distFlacon(p) = lev(char(selPseudo(p)),'flacon');
end

% exclude those too close to a not used word [N = 2007]
mat.pseudo.distances(mat.pseudo.distances.minControl == 1,:) = [];

% pick those pseudowords which are as close (or closer) to a chosen stimulus than to a control word
% (do so by excluding the others) [N = 100]
mat.pseudo.distances(mat.pseudo.distances.minControl < mat.pseudo.distances.minChosen,:) = [];

% we get 100 pseudowords close to 19 words, flacon is missing
% we can get one for each word, and element 27 because it's the closest to flacon
mat.pseudo.distances = sortrows(mat.pseudo.distances,'whichChosen','ascend');
mat.pseudo.chosen = mat.pseudo.distances([1 4 11 17 25 26 27 29 38 43 47 51 57 61 63 69 76 80 96 98],:);


% make orthographic rdm of those pseudowords
length = size(mat.pseudo.chosen,1);
for n = 1:length
    for o = 1:length        
        % Orthography: simple lev
        mat.pseudo.ortho(n,o) = lev(char(mat.pseudo.chosen.pseudo(n)), char(mat.pseudo.chosen.pseudo(o)));
    end
end

% extract triangle for correlations
mat.pseudo.tri_ortho = mat.pseudo.ortho(triu(true(size(mat.pseudo.ortho)),1));

% Correlations between RDMs
mat.chosen.orthoCorr = corrcoef([mat.chosen.tri_ortho, mat.pseudo.tri_ortho]);

% Write correlations in a .xlsx file, just in case
writematrix(mat.chosen.corr,'corr_WordPseudo.xlsx');

%% graphics 

% labels
mat.pseudo.labels = string(mat.pseudo.chosen.pseudo);

% plots
figure;
mat.pseudo.htmp_ortho = heatmap(mat.pseudo.labels, mat.pseudo.labels, mat.pseudo.ortho, ...
                         'CellLabelColor','none','Colormap',parula,'ColorScaling','scaledcolumns', ...
                           'Units','pixels','Position',[50 40 750 750]);

%% Clean-up and save 

clearvars whichPos w toDel thisW n o p minArray l length ans c joinWords selNl selLv

save('chosen_words_pseudo.mat')



        