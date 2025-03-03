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
clearvars p4* p5* selF* selL* selN* selP* selW* selT* pseudo selB*

%% 1. get consonants

allLet = sortrows(allLet,'nbOccurrencesTok','descend');

% manual selection: easier than to code the difference between vowel and
% consonant.
%                    s  t  n  r l  p  d  m  c  v  f  j  b  q  h  g  z  x  y  k  w
consonants = allLet([2  5  6  8 10 11 12 13 14 15 17 18 19 20 21 22 23 25 27 35 37],:);

% Alternative: only non frequent ones
% consonants = notFreq([1 2 3 4 6 8 16 18],:);

%% 2. get infrequent properties of strings

% Select those infrequent given the letters
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

    % for every bigramme, it must be made only of infrequent letters
    for j = 1:size(charT,1)
        if any(strcmp(string(charT{j}), selLet))
            validT(j) = 1;
        else
            validT(j) = 0;
        end
    end

    % if it's only made of infrequent letters, add this bigramme to the
    % selection
    if all(validT)
        selTri = vertcat(selTri, thisT);
    end
end

%% 3C. Get permutations from another script
% lot of failed attempts later...
% Requires strong pc with many cores

% get permutations without repetition (39 billion)
[permComb, permIdx] = npermutek_noRep(char(consonants.lettres),6);

% convert them from array of chars to string. Is there a better way?
permStrings = string(permComb(:,:));
permTable = table(permComb,permIdx);

% check for properites
[selIndexes, selNonWords] = checkFrequentComponents(permStrings, selLet, selBi, selTri);

% get the numbers too
selNonWords = assignDotsAndNumber(selNonWords,stimuli);

% make everything into one big array / table / whatever
selData = table('Size',[size(selNonWords,1) 9], ...
    'VariableTypes',{'string', 'string', 'double', 'double','double','double','double','double','double'}, ...
    'VariableNames',{'nonWord','braille','numDots','let1','let2','let3','let4','let5','let6'});
selData.nonWord = selNonWords(:,1);
selData.braille = selNonWords(:,2);
selData.numDots = str2double(selNonWords(:,3));

for i = 1:size(selIndexes,1)
    selData.let1(i) = permIdx(selIndexes(i),1);
    selData.let2(i) = permIdx(selIndexes(i),2);
    selData.let3(i) = permIdx(selIndexes(i),3);
    selData.let4(i) = permIdx(selIndexes(i),4);
    selData.let5(i) = permIdx(selIndexes(i),5);
    selData.let6(i) = permIdx(selIndexes(i),6);
end

% order by number of dots
selData = sortrows(selData,'numDots','ascend');

% save, you don't want to do this again
clearvars allBi allLet allTri ans charT charB flpPseudowords i images j lex reportWords reportPseudo words validB validT
save('temp_1906_manual.mat');


%% calc total letter distribution
% used to understand how we can pick letters

lettersIndexes = selData{1:1464,4:9};
totalLetterDistribution = zeros(1,21);

% check distribution
for v = 1:length(totalLetterDistribution)
    totalLetterDistribution(v) = sum(lettersIndexes == v,'all');
end


%% Select the non words: random by random option
% fake randomization to achieve 19 +- 0.5 of average number of dots
%
%   num. dots       num. strings    num. picked
%       15                4             0
%       16               24             1
%       17               99             2
%       18              234             2
%       19              483             2
%       20              620             2      
%       21              707             2
%       22              478             1
%       23              297             0
%       24               96             0
%       25                3             0
%
% AVG(rw) = 19   AVG(pw) = 19.03    AVG(nw) = 228/12 = 19
%
% As reminder: letter indexes correspond to
% s   t   n   r   l   p   d   m   c   v   f   j   b   q   h   g   z   x   y   k   w
% 1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20  21
%
% Starting letters and the number of them:
% S - 1:23          T - 24:237        N - 238:409
% R - 410:452       L - 453:727       P - 728:982
% D - 983:1140      M - 1141:1183     V - 1184:1344
% F - 1345:1511     B - 1512:1552     H - 1553:1889
% G - 1890:2040     Z - 2041:2262     X - 2263:2495
% Y - 2496:2675     K - 2676:2962     W - 2963:3045
%
% Representation is tricky to control, both ranomly and manually
% maximum number of appearances is the distribution of letters across the
% set +3 iterations. A lot skewed to B C M K D
%
% What happens here:
% - control that all the letters appear
% - check that they do not appear more than 4 times in the same position

possible = struct;

% parfor ns = 1:10

    notAll = true;

    while notAll

        % letters vector
        letterDistribution = zeros(1,21);

        % already picked if there are already 3 instances
        alreadyPicked = [];
        % max = distribution of letters in the set +2, with a ceiling at 9
        maximums = [7 6 5 3 7 3 7 5 5 3 4 3 6 3 8 5 5 3 7 9 4];
        % starter picked if the first letter already appears
        starterPicked = [];

        numDotsArray = [16 17 17 18 18 19 19 20 20 21 21 22];

        for nPick = 1:length(numDotsArray)

            nDotsThisPick = numDotsArray(nPick);

            % PICK 1 N-dots NONWORD
            currentSet = selData(selData.numDots == nDotsThisPick ...
                & not(ismember(selData.let1,starterPicked))  ...       ,:);
                & not(ismember(selData.let1,alreadyPicked)) & not(ismember(selData.let2,alreadyPicked)) ...
                & not(ismember(selData.let3,alreadyPicked)) & not(ismember(selData.let4,alreadyPicked)) ...
                & not(ismember(selData.let5,alreadyPicked)) & not(ismember(selData.let6,alreadyPicked)) ,:);

            if not(isempty(currentSet))
                ranDots = randi(size(currentSet,1),1);

                % put the non-word in the char array
                if nPick == 1
                    randData = currentSet(ranDots,:);
                    randIndexes = currentSet{ranDots,4:9};
                else
                    randData = vertcat(randData,currentSet(ranDots,:));
                    randIndexes = vertcat(randIndexes,currentSet{ranDots,4:9});
                end

                % check distribution
                for v = 1:length(letterDistribution)
                    letterDistribution(v) = sum(randIndexes == v,'all');
                end

                % Flag those already picked
                starterPicked = randData.let1;
                alreadyPicked = find(letterDistribution == maximums);
            end
        end
        % check vertical distribution, can be implemented live but it requires
        % a lot of time
        verticalDistribution = zeros(21,6);
        for vd = 1:size(randData,1)
            for l = 1:6
                thisIdx = randData{vd,3+l};
                verticalDistribution(thisIdx,l) = verticalDistribution(thisIdx,l) +1;
            end
        end

        % don't force all the letters 
        % 12 words must be selected
        % maximum 3 elements of each letter in a position
        if not(min(letterDistribution([14 18 19])) == 0) && ...
           size(randData,1) == 12 && ...
           max(verticalDistribution,[],'all') <= 3
            
            notAll = false;
        end


    end

    % do vertical control live
    % do I need all the letters? I don't have them in RW or PW
    % skipping dist could improve variability
    % drop starter, limit is 2 not 1

%     % assign to struct - only in parfor
%     possibleTables(:,:,ns) = randData{:,:};
%     possibleDist(:,:,ns) = letterDistribution;
%     possibleVert(:,:,ns) = verticalDistribution;
% end

% still too many Ks

%% Clear and save, we can go back later on

% 21/06 - best set is set15
selection = possibleSets.set15;

clearvars alreadyPicked avg brCoord currentSet l letterDistribution maximums mvpa_words ...
          nDotsThisPick notAll nPick numDotsArray possible randData randIndexes ranDots ...
          selIndexes selInfr* selNonWords starterPicked stimuli stX stY this* v vd verticalDistribution


save('selection_nonwords.mat')








