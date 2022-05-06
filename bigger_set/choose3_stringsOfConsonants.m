%% Strings of consonants: a.k.a our non-words
%
% Vinckier et al take the bottom 45 percentiles and use those consonants.
% That does not match with our set, probably beacuse of the frequency of
% words indexes used in calculating our parameters.
% To be short, 'j' is frequent for us and not for them
%
% To have more variability, we can include all the letters that are not
% frequent (55th percentile and descending).
%
% Steps:
% 1. get the available consonants
% 2. extarct sizes and positions to be printed (de-novo beacuse of
%    different laptop)
% 3. make random permutations of those letters, to get the consonant
%    strings
% 4. control for properties (same ratio of letters, not more than 2 in a
%    string, tbc)
% 5. finalize set 

addpath(genpath('Users/cerpelloni/Desktop/GitHub'))

clear 

load('first_selection.mat');

%% 1. get consonants

allLet = sortrows(allLet,'nbOccurrencesTok','descend');

notFreq = table;

for l = 1:size(allLet,1)
    if not(strcmp(allLet.lettres(l), selFreqLet.lettres))
        notFreq = vertcat(notFreq,allLet(l,:));
    end
end

% manual selection: easier than to code the difference between vowel and
% consonant
consonants = notFreq([1 2 3 4 6 8 16 18],:);

%% 2. make permutations of strings
%
% only constraint for now is not not have the same letter repeated more
% than twice

% get all the possible permutations of k elements picked from a pool of n
% elements (our letters)
allComb = npermutek([1 2 3 4 5 6 7 8 9],6);
% toDel = [];
% 
% % browse through them
% for c = 1:size(allComb,1)
% 
%     thisC = allComb(c,:);
%     
%     % exlcude those that have more than 2 elements of the same kind
%     if length(unique(thisC)) <= 4
%         toDel = horzcat(toDel, c);
%     end
% end
% allComb(toDel,:) = [];

selLet = consonants.lettres;

% BI
selBi = "";

for i = 1:size(selInfreqBi,1)
    thisB = selInfreqBi.bigramme{i};
    charB = split(thisB,"");
    charB = charB([2 3]);
    validB = [0 0];

    % for every bigramme, it must be made only of frequent letters
    for j = 1:size(charB,1)
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

for i = 1:size(selInfreqTri,1)
    thisT = selInfreqTri.trigrammes{i};
    charT = split(thisT,"");
    charT = charT([2 3 4]);
    validT = [0 0];

    % for every bigramme, it must be made only of frequent letters
    for j = 1:size(charT,1)
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

%% pick randomly 20
% then check that by coloumn, they need to hav the same distribution
<<<<<<< HEAD
=======

% delete those that are made of less than 4 elements: max 1 letter repeated
for i = size(allComb,1):-1:1
    this = allComb(i,:);
    if length(unique(this)) < 5
        allComb(i,:) = [];
    end
    i
end

%%

>>>>>>> master
stillHaventPicked = true;

while stillHaventPicked 

    % pick 20 different strings
    randPos = zeros(1,20);
    while not(unique(randPos) == 20) 
        randPos = randi(size(allComb,1),[20 1]);
    end
    % check the distribution of letters
    thisPick = allComb(randPos,:);

    for p = 1:size(thisPick,2)
        
        % there should be at least 2 istances of each letter in each
        % position
        colDistribution = [sum(thisPick == 1,'all')  sum(thisPick == 2,'all') ...
                            sum(thisPick == 3,'all') sum(thisPick == 4,'all') ...
                            sum(thisPick == 5,'all') sum(thisPick == 6,'all') ...
                            sum(thisPick == 7,'all') sum(thisPick == 8,'all') ...
                            sum(thisPick == 9,'all')]

        % there should not be more than 1 letter repeated in each word
<<<<<<< HEAD
        rowDistribution = [unique(thisPick(1,:)) >= 5, unique(thisPick(2,:)) >= 5, unique(thisPick(3,:)) >= 5, ...
                           unique(thisPick(4,:)) >= 5, unique(thisPick(5,:)) >= 5, unique(thisPick(6,:)) >= 5, ...
                           unique(thisPick(7,:)) >= 5, unique(thisPick(8,:)) >= 5, unique(thisPick(9,:)) >= 5, ...
                           unique(thisPick(10,:)) >= 5, unique(thisPick(11,:)) >= 5, unique(thisPick(12,:)) >= 5, ...
                           unique(thisPick(13,:)) >= 5, unique(thisPick(14,:)) >= 5, unique(thisPick(15,:)) >= 5, ...
                           unique(thisPick(16,:)) >= 5, unique(thisPick(17,:)) >= 5, unique(thisPick(18,:)) >= 5, ...
                           unique(thisPick(19,:)) >= 5, unique(thisPick(20,:)) >= 5];
=======
        rowDistribution = [length(unique(thisPick(1,:))) >= 5, length(unique(thisPick(2,:))) >= 5, length(unique(thisPick(3,:))) >= 5, ...
                           length(unique(thisPick(4,:))) >= 5, length(unique(thisPick(5,:))) >= 5, length(unique(thisPick(6,:))) >= 5, ...
                           length(unique(thisPick(7,:))) >= 5, length(unique(thisPick(8,:))) >= 5, length(unique(thisPick(9,:))) >= 5, ...
                           length(unique(thisPick(10,:))) >= 5, length(unique(thisPick(11,:))) >= 5, length(unique(thisPick(12,:))) >= 5, ...
                           length(unique(thisPick(13,:))) >= 5, length(unique(thisPick(14,:))) >= 5, length(unique(thisPick(15,:))) >= 5, ...
                           length(unique(thisPick(16,:))) >= 5, length(unique(thisPick(17,:))) >= 5, length(unique(thisPick(18,:))) >= 5, ...
                           length(unique(thisPick(19,:))) >= 5, length(unique(thisPick(20,:))) >= 5];
>>>>>>> master

        % all the letters are represented almost equally, we can exit
        if min(colDistribution >= 12) && all(rowDistribution)
            stillHaventPicked = false;
            nonwordPos = thisPick;
        end
    end
end

% assign letters and form strings
nonwords = "";

for n = 1:size(nonwordPos,1)
    thisNW = "" + consonants.lettres(nonwordPos(n,1)) + consonants.lettres(nonwordPos(n,2)) ...
                + consonants.lettres(nonwordPos(n,3)) + consonants.lettres(nonwordPos(n,4)) ...
                + consonants.lettres(nonwordPos(n,5)) + consonants.lettres(nonwordPos(n,6));
    nonwords = vertcat(nonwords,thisNW);
end
nonwords(1) = [];

%% Calc RDM for orthography and show some graphics

% load mat so we store everything together
load('chosen_words_pseudo.mat');

mat.nonwo.nonwords = nonwords;

% make orthographic rdm of those pseudowords
length = size(mat.nonwo.nonwords,1);
for n = 1:length
    for o = 1:length        
        % Orthography: simple lev
        mat.nonwo.ortho(n,o) = lev(char(mat.nonwo.nonwords(n)), char(mat.nonwo.nonwords(o)));
    end
end

% extract triangle for correlations
mat.nonwo.tri_ortho = mat.nonwo.ortho(triu(true(size(mat.nonwo.ortho)),1));

% Correlations between RDMs
mat.chosen.orthoCorr = corrcoef([mat.chosen.tri_ortho, mat.pseudo.tri_ortho mat.nonwo.tri_ortho]);

% Write correlations in a .xlsx file, just in case
writematrix(mat.chosen.orthoCorr,'corr_WordPseudoNon.xlsx');

%% graphics 

% labels
mat.nonwo.labels = string(mat.nonwo.nonwords);

% plots
figure;
mat.nonwo.htmp_ortho = heatmap(mat.nonwo.labels, mat.nonwo.labels, mat.nonwo.ortho, ...
                         'CellLabelColor','none','Colormap',parula,'ColorScaling','scaledcolumns', ...
                           'Units','pixels','Position',[50 40 750 750]);


