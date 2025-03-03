clear;

addpath(genpath('/Users/cerpelloni/Desktop/GitHub/VB_backstage_code'))

load('FrenchLexiconProject_pseudowords.mat');
load('Lexique_selection.mat');
load('LexiqueInfra_components.mat');

% excluse ' and . from letters: whay are they even there?
freqLetters([36, 43],:) = [];

allLet = freqLetters; allBi = freqBigrammes; allTri = freqTrigrammes;
pseudo = flpPseudowords;

%% 1. Selection of relevant words
%
% High frequency first, sorts by the most frequent (both films and books).
% Films, biggest corups and we don't care too much now

lex = sortrows(lex,'freqfilms2','descend');

% frequency
lex = lex(lex.freqfilms2 > 2,:);

% length of words
lex = lex(lex.nblettres == 6,:); % 6 letters long

% type of words: no onomatopes
lex = lex(lex.cgram ~= 'ONO',:);
% names
lex = lex(lex.cgram == 'NOM',:);

% only singular
lex = lex(lex.nombre ~= 'p',:);

% delete composites and dashed
lex = deleteRows(lex);

%% 2. Extract features to be used
% get top x percentile from feature lists

% get logs: to check whether something changes (Vinckier et al. used mean log frequencies) 
allLet.logOccurrencesTok = log(allLet.nbOccurrencesTok);
allBi.logOccurrencesTok = log(allBi.nbOccurrencesTok);
allTri.logOccurrencesTok = log(allTri.nbOccurrencesTok);

% get percentiles and not log ones
p55Let = prctile(allLet.nbOccurrencesTok,55); 
p55Bi = prctile(allBi.nbOccurrencesTok,55); 
p55Tri = prctile(allTri.nbOccurrencesTok,55);

p55LogLet = prctile(allLet.logOccurrencesTok,55);
p55LogBi = prctile(allBi.logOccurrencesTok,55);
p55LogTri = prctile(allTri.logOccurrencesTok,55);

p45Let = prctile(allLet.nbOccurrencesTok,45);
p45Bi = prctile(allBi.nbOccurrencesTok,45);
p45Tri = prctile(allTri.nbOccurrencesTok,45);

p45LogLet = prctile(allLet.logOccurrencesTok,45);
p45LogBi = prctile(allBi.logOccurrencesTok,45);
p45LogTri = prctile(allTri.logOccurrencesTok,45);

% select components above 55th and below 45th percentiles
selFreqLet = allLet(allLet.nbOccurrencesTok >= p55Let,:);
selInfreqLet = allLet(allLet.nbOccurrencesTok <= p45Let,:);
selFreqLogLet = allLet(allLet.logOccurrencesTok >= p55LogLet,:);
selInfreqLogLet = allLet(allLet.logOccurrencesTok <= p45LogLet,:);

selFreqBi = allBi(allBi.nbOccurrencesTok >= p55Bi,:);
selInfreqBi = allBi(allBi.nbOccurrencesTok <= p45Bi,:);
selFreqLogBi = allBi(allBi.logOccurrencesTok >= p55LogBi,:);
selInfreqLogBi = allBi(allBi.logOccurrencesTok <= p45LogBi,:);

selFreqTri = allTri(allTri.nbOccurrencesTok >= p55Tri,:);
selInfreqTri = allTri(allTri.nbOccurrencesTok <= p45Tri,:);
selFreqLogTri = allTri(allTri.logOccurrencesTok >= p55LogTri,:);
selInfreqLogTri = allTri(allTri.logOccurrencesTok <= p45LogTri,:);

%% 3. Select bi- and trigrammes based on the frequent letters only

selLet = selFreqLet.lettres;

% BI
selBi = "";

for i = 1:size(selFreqBi,1)
    thisB = selFreqBi.bigramme{i};
    charB = split(thisB,"");
    charB = charB([2 3]);
    validB = [0 0];

    % for every bigramme, it must be made only of frequent letters
    for j = 1:length(charB)
        if any(strcmp(string(charB{j}), selLet))
            validB(j) = 1;
        else
            validB(j) = 0;
        end
    end

    % if it's only made of frequent letters, add this bigramme to the
    % selection
    if validB
        selBi = vertcat(selBi, thisB);
    end
end

% TRI
selTri = "";

for i = 1:size(selFreqTri,1)
    thisT = selFreqTri.trigrammes{i};
    charT = split(thisT,"");
    charT = charT([2 3 4]);
    validT = [0 0];

    % for every bigramme, it must be made only of frequent letters
    for j = 1:length(charT)
        if any(strcmp(string(charT{j}), selLet))
            validT(j) = 1;
        else
            validT(j) = 0;
        end
    end

    % if it's only made of frequent letters, add this bigramme to the
    % selection
    if all(validT)
        selTri = vertcat(selTri, thisT);
    end
end

clearvars charB i j freqLetters freqBigrammes freqTrigrammes thisB validB thisT validT charT

%% 4. Apply feature selection to words
%
% we now have 6L words, frequent letters, bi-, tri-
% how many of those words have all those features? 

% Give it the words to analyse, the frequent components that must be
% present and you'll get the selection of words that fit the criteria and a
% small report on all the words analysed

% only words as string now
words = string(lex.ortho);

[reportWords, selWords] = checkFrequentComponents(words, selLet, selBi, selTri);

%% 5. Do the same selection for pseudo-words

% length of pseudo must be 6 letters
pseudo_temp = "";
for p = 1:size(pseudo,1)
    spl = split(pseudo.ortho(p),"");
    length = size(spl,1)-2;

    if length == 6
        pseudo_temp = vertcat(pseudo_temp, pseudo.ortho(p));
    end
end
pseudo = pseudo_temp(2:end);

% get those that match the components
[reportPseudo, selPseudo] = checkFrequentComponents(pseudo, selLet, selBi, selTri);

clearvars spl p length pseudo_temp

save('first_selection.mat');

%% 4. Manually choose 20: 10 animate 10 inanimate

%% 5. Build set 


