%% Look at frequencies and correlations of two possible options for MVPA dataset
%
% Option 1: 
% 2x2 desgin - semnatic and phonological groups, 2 words each group.
% What would be the freqquencies of those words?
%
% Option 2:
% 2x6 design - 2 semantic groups (living, non-living), 6 pairs of phonologically 
% similar words, distant between groups

load('stimuli_initial_selection.mat');
clearvars animals animals_AND mvpa_6L_lex places places_AND loc_lex infra_GrPh

% Get option 1 stimuli
o1 = struct;
o1.on.anim = words([59,63,66,68,71,76,87,90,96],:);   o1.on.plac = words([1,3,23,40,42,46],:);
o1.et.anim = words([58,102],:);                       o1.et.plac = words([17,36],:);

% Get option 2 stimuli
% (possibly useful to revise this way of storing them)
o2 = struct;
o2.phon.on = o1.on;
o2.phon.et = o1.et;
o2.phon.eau.anim = words([57,62],:);           o2.phon.eau.plac = words([2,39,43,50],:);
o2.phon.que.anim = words(86,:);                o2.phon.que.plac = words([4,11,49],:);
o2.phon.ace.anim = words(79,:);                o2.phon.ace.plac = words([5,30],:);
o2.phon.er.anim = words(74,:);                 o2.phon.er.plac = words([9,37],:);
o2.phon.al.anim = words(56,:);                 o2.phon.al.plac = words(54,:);
o2.phon.ue.anim = words(72,:);                 o2.phon.ue.plac = words(25,:);
o2.phon.ar.anim = words([61,67,69,70,73],:);   o2.phon.ar.plac = words([14 29],:);
o2.phon.a.anim = words([103,104],:);           o2.phon.a.plac = words(6,:);
o2.phon.i.anim = words([80,91],:);             o2.phon.i.plac = words(20,:);
o2.phon.ine.anim = words(83,:);                o2.phon.ine.plac = words(13,:);
o2.phon.n.anim = words(99,:);                  o2.phon.n.plac = words(33,:);
o2.phon.an.anim = words([88,98],:);            o2.phon.an.plac = words(31,:);
o2.phon.in.anim = words(65,:);                 o2.phon.in.plac = words([8,27,53],:);

o2.lexique_words = words([1,2,3,4,5,6,8,9,11,13,14,17,20,23,25,27,29,30,31,33,36,37,...
                    39,40,42,43,46,49,50,53,54,56,57,58,59,61,62,63,65,66,67,68,69,70,...
                    71,72,73,74,76,79,80,83,86,87,88,90,91,96,98,99,102,103,104],:);
                
%% HOW TO FORSEE THEIR FREQUENCY RELATIONSHIPS?
%% OPTION 1 - Factorial desing 2 (semantics) * 2 (phonology) * 2 (frequency)

% Possible words
o1.lexique_words = words([59,63,66,68,71,76,87,90,96,58,102,1,3,23,40,42,46,17,36],:);

% Make summary file

%     | Animals  |  Places
% ----+----------+--------
% ON  | cochon   |  balcon
%     | faucon   |  vallon
% ----+----------+--------
% ET  | poulet   |  sommet
%     | roquet   |  chalet

% Get relevant columns (ortho, phon, frequencies) for the words rows
o1.summary = words([17 36 23 42 58 102 59 71],[1 3 8 9]); 

% add phonological group (rhyme with -et or -on)
o1.summary.ph_group([1 2 5 6]) = categorical({'et'});
o1.summary.ph_group([3 4 7 8]) = categorical({'on'});

% add semantic category
o1.summary.sem([1 2 3 4]) = categorical({'place'});
o1.summary.sem([5 6 7 8]) = categorical({'animal'});

% Move phonological group 
o1.summary = movevars(o1.summary, 'phon', 'Before', 'ph_group');

% Calc matrixes and triangles
matrix_length = size(o1.summary,1);
for n = 1:matrix_length
    for o = 1:matrix_length
        
        % USE SUMMARY, IF NOT ORDER CHANGES EVERYTIME AND R(PHON,SEM) = 1
        % Movies and books are the difference between values
        o1.m_mat(n,o) = abs(o1.summary{n,2} - o1.summary{o,2});
        o1.b_mat(n,o) = abs(o1.summary{n,3} - o1.summary{o,3});
        
        % Semantics and phonology are the boolean value of their 
        % comparison: same or not
        % N.B. Dissimilarity, same index of frequencies 
        o1.s_mat(n,o) = o1.summary{n,6} ~= o1.summary{o,6};
        o1.p_mat(n,o) = o1.summary{n,5} ~= o1.summary{o,5};
        
        % Check with newly implemented measures for phonoloigcal similarity
        % (levPW) and orthographic similarity (braille_PWLD)
        o1.ortho_weighted(n,o) = levBrailleW(char(o1.summary{n,1}),char(o1.summary{o,1}));
        o1.phon_weighted(n,o) = levPhonW(char(o1.summary{n,4}),char(o1.summary{o,4}));
               
    end
end

% Extract the triangle from the RDM (either top or bottom, always the same)
o1.m_tri = o1.m_mat(triu(true(size(o1.m_mat)),1));
o1.b_tri = o1.b_mat(triu(true(size(o1.b_mat)),1));
o1.p_tri = o1.p_mat(triu(true(size(o1.p_mat)),1));
o1.s_tri = o1.s_mat(triu(true(size(o1.s_mat)),1));

% Correlations between RDMs
% with both indexes (with movies frequency)
o1.r_withM = corrcoef([o1.m_tri, o1.b_tri, o1.p_tri, o1.s_tri]);

% Without it
o1.r = corrcoef([o1.b_tri, o1.p_tri, o1.s_tri]);

% Write correlations in a .xlsx file, just in case
writematrix(o1.r,'o1_corr.xlsx');

% Later addition: PWLD correlations between old phon and new phon
% Get triangle
o1.pw_tri = o1.phon_weighted(triu(true(size(o1.phon_weighted)),1));
o1.ow_tri = o1.ortho_weighted(triu(true(size(o1.ortho_weighted)),1));
% Correlate phonologies
o1.r_pw_phon = corrcoef(o1.p_tri,o1.pw_tri);
o1.r_wieghted = corrcoef(o1.ow_tri, o1.pw_tri);

clearvars n o matrix_length 

%% OPT1 - Graphics
% Use specific tables for plots, nicer images 

% HEATMAPS (A.K.A COOL RDM-LIKE PLOTS)

% label for everything (always the same order)
lab_fr = o1.summary{:,1}';

o1.m_htmp = heatmap(lab_fr,lab_fr,o1.m_mat,'CellLabelColor','none');   % movies frequency
o1.b_htmp = heatmap(lab_fr,lab_fr,o1.b_mat,'CellLabelColor','none');   % books frequency
o1.p_htmp = heatmap(lab_fr,lab_fr,double(o1.p_mat),'CellLabelColor','none');  % phonology
o1.s_htmp = heatmap(lab_fr,lab_fr,double(o1.s_mat),'CellLabelColor','none');  % semantics

% Later addition: weighted Levenshtein
% orthography
o1.ow_htmp = heatmap(lab_fr,lab_fr,o1.ortho_weighted,'CellLabelColor','none','Colormap',parula,'Units','pixels','Position',[60 60 440 440]);
% phonological similarity with index
o1.pw_htmp = heatmap(lab_fr,lab_fr,o1.phon_weighted,'CellLabelColor','none','Colormap',parula,'Units','pixels','Position',[60 60 440 440]);

% Scater plot: frequency (x) * semantics (y)
x = o1.summary{:,3}'; % frequencies
y = double(o1.summary{:,5}'); % semantic categories
col = [1 0.6916 0.2902; 1 0.6916 0.2902; 0.4118 0.6667 0.6000; 0.4118 0.6667 0.6000]; % colors for phonology (CPP colors)
col = vertcat(col,col); % duplicate them

% Draw scatter plot
o1.scatter = scatter(x([1 2 5 6]),y([1 2 5 6]),80,[1 0.6916 0.2902],'filled');
hold on
o1.scatter = scatter(x([3 4 7 8]),y([3 4 7 8]),80,[0.4118 0.6667 0.6000],'filled');
labelpoints(x,y, lab_fr); % custom code from matlab sharing tools to add labels near the points

clearvars lab_fr col x y 

%% OPTION 2 - Multi-level design 6 (phonology) * 2 (semantics) 

% Every words is eligible at the beginning
o2.words = o2.lexique_words(:,[1 3 8 9]);

% Add phonological group (manually)
group = {'on','eau','on','que','ace','a','in','er','que','ine','ar','et','i','on','ue','in','ar','ace',...
         'an','n','et','er','eau','on','on','eau','on','que','eau','in','al','al','eau','et','on',...
         'ar','eau','on','in','on','ar','on','ar','ar','on','ue','ar','er','on','ace','i','ine',...
         'que','on','an','on','i','on','an','n','et','a','a'};
o2.words.phon = categorical(group'); % assign it to a coloumn

% Store the possible groups 
o2.phon_groups = categorical({'on','eau','et','que','ace','er','ar','al','an','n','i','ue','ine','in','a'});

% Add semantics too (words are already ordered like this)
o2.words.sem(1:31) = categorical({'place'}); 
o2.words.sem(32:end) = categorical({'animal'});

% % Consider the two frequency indexes as separated 
% % This way, we have FREQ, PHON, SEM for both frequency indexes
% o2.freq_movies = o2.words(o2.words.freqfilms2 >= 1,[1 2 4 5]);
% o2.freq_books = o2.words(o2.words.freqlivres >= 1,[1 3 4 5]);

% Get all the possible pairs
% set up the table
o2.pairs = table('Size',[96 2],'VariableNames',{'animal','place'},'VariableTypes',{'string','string'});

for g = 1:96 % already known it's 91 due to previous on-paper math
    for j = 1:15 % for every phonological group
        eval(['this_group = o2.phon.' + string(o2.phon_groups(j)) + ';']); 
        n_an = size(this_group.anim,1);
        n_pl = size(this_group.plac,1);
        
        for k = 1:n_an % for total animals
            for m = 1:n_pl % for total places
                % assign current ones 
                o2.pairs.animal(g) = this_group.anim.Item(k);
                o2.pairs.place(g) = this_group.plac.Item(m);
                
                %update counter
                g = g+1;
            end
        end
    end
end

% There are extra lines that I don't know why they appear. 
% It's just the repetition of maison - cochon all the times (should probably debug it)
% For now, manually deleted
o2.pairs(1:95,:) = [];

% Get pairs according to the index: deletes those pairs that are not
% suitable for the specific frequency, as some elements are not frequent
% enough on one of them. Only keeps those with frequency > 1 (/million)
o2.m_pairs = o2.pairs([1:64 67:78 80 83:88],:);
o2.b_pairs = o2.pairs([1:36 55:72 74:81 83:91],:);
% (not used again)

% Get common pairs (both indexes are >1, theoretically we can pick either)
o2.common_pairs = o2.pairs([1:36 55:57 59:61 63:64 67:72 74:83 85 88:93],:);

clearvars j k m g n_an n_pl this_group

%% OPT2 - Get random pairs 
% Extract 6 random pairs based on the phonology: 
% - randomly select one
% - randomly pick a pair within the phon. category
% - check if it's not a repetition

which_cat = []; % which phonological category is that
which_pairs = []; % which pair is that
av_groups = o2.phon_groups([1:7 8 11:14]); % Which phon. group are represented in common_pairs
while length(which_cat) < 6
    cat = randi(12); % get random phon.
    switch cat
        case 1 % on
            dado = randi(36);
        case 2 % eau
            dado = randi(6) + 36;
        case 3 % et
            dado = randi(2) + 42;
        case 4 % que
            dado = randi(3) + 44;
        case 5 % ace
            dado = randi(2) + 47;
        case 6 % er
            dado = 50;
        case 7 % ar
            dado = randi(5) + 50;
        case 8 % an
            dado = 56;
        case 9 % i
            dado = randi(2) + 56;
        case 10 % ue
            dado = 59;
        case 11 % ine
            dado = 60;
        case 12 % in
            dado = randi(2) + 60;
    end
    if ~ismember(cat,which_cat) % check for repetition: if it's not present, add it
        which_cat = horzcat(which_cat,cat);
        which_pairs = horzcat(which_pairs,dado);
    end
end

% Save extraction of words to a separate struct
o2.extract = struct;
o2.extract.summary = table; % create summary like o1
for k = 1:6 % # pairs
    this_animal = o2.common_pairs{which_pairs(k),1};
    this_place = o2.common_pairs{which_pairs(k),2};
    
    % get all the data: fr, ph, se
    data_animal = o2.words(matches(o2.words.Item, this_animal),:);
    data_place = o2.words(matches(o2.words.Item, this_place),:);
    
    % Add them to the total list: first semantic categories (place /
    % animal), then phonological ones
    o2.extract.summary(k,1:5) = data_place;
    o2.extract.summary(k+6,1:5) = data_animal;
end

clearvars av_groups data_animal data_place k this_group group words this_animal this_place cat dado which_cat which_pairs 

%% OPT2 - Compute RDMs and correlations

% Create matrixes (one loop for all of them)
matrix_length = size(o2.extract.summary,1);
for n = 1:matrix_length
    for o = 1:matrix_length
        
        % Frequency: difference between values
        o2.extract.m_mat(n,o) = abs(o2.extract.summary{n,2} - o2.extract.summary{o,2}); % movies
        o2.extract.b_mat(n,o) = abs(o2.extract.summary{n,3} - o2.extract.summary{o,3}); % books
        
        % Semantics and phonology: boolean of the comparison: are they the same?
        % (DIS-similarity matrices, same = 0, differnet = 1)
        o2.extract.s_mat(n,o) = o2.extract.summary{n,5} ~= o2.extract.summary{o,5}; % semantics
        o2.extract.p_mat(n,o) = o2.extract.summary{n,4} ~= o2.extract.summary{o,4}; % phonology
               
    end
end

% Get upper triangles (triu function) for each
o2.extract.m_tri = o2.extract.m_mat(triu(true(size(o2.extract.m_mat)),1));
o2.extract.b_tri = o2.extract.b_mat(triu(true(size(o2.extract.b_mat)),1));
o2.extract.p_tri = o2.extract.p_mat(triu(true(size(o2.extract.p_mat)),1));
o2.extract.s_tri = o2.extract.s_mat(triu(true(size(o2.extract.s_mat)),1));

% Correlations: first with both frequencies, then only with movies 
% (we just need one)
o2.extract.r_withB = corrcoef([o2.extract.m_tri, o2.extract.b_tri, o2.extract.p_tri, o2.extract.s_tri]);
o2.extract.r = corrcoef([o2.extract.m_tri, o2.extract.p_tri, o2.extract.s_tri]);

% IMPORTANT, MANUAL STEP:
% If a set appears to be relevant and potentially good, manually assign it
% to sets (be sure to update the X value to avoid overlaps)
% sets.vX = o2.extract;

% Clear unnecessary variables
clearvars n o matrix_length 

%% OPT2 - Graphics 
% As indicated in the IMPORTANT comment, we save the opt2.extract set into
% sets, so now the names have changed. Again, be careful of the vX value

% Heatmaps (RDMs)
% works like opt1
labels = sets.v1.summary{:,1}';
sets.v1.f_htmp = heatmap(labels, labels, sets.v1.m_mat,'CellLabelColor','none'); % frequency - movies
sets.v1.p_htmp = heatmap(labels, labels, double(sets.v1.p_mat),'CellLabelColor','none'); % phonology
sets.v1.s_htmp = heatmap(labels, labels, double(sets.v1.s_mat),'CellLabelColor','none'); % semantics

% Scatter plot
% x = frequency, y = semantics, color = phonology
x = sets.v1.summary{:,2}';
y = double(sets.v1.summary{:,5}');
col = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; ...
       0.4940 0.1840 0.5560; 0.4660 0.6740 0.1880; 0.3010 0.7450 0.9330]; % different colors than before
col = vertcat(col,col); % duplicate them

for g = 1:6 
    sets.v1.scatter = figure;
    scatter(x([g g+6]),y([g g+6]),[],col(g,:),'filled');
    hold on
end
hold off

%% OPTION 2 REVISED - Selection of pairs based on a phonological distance
% Any relationship with orthography? 
% New option starting from 07/06/2021
%
% Levenshtein weighted distances 
% - Orthography: distance is given by the overlap of dots (see braille_PWLD)
% - Phonology: distance comes from Fontan's weights (see levPW)

% new struct to save stuff better
o2R = struct; 

% get common pairs words (keep liexique_infra information)
o2R.lexique_words = o2.lexique_words([1:5,7:19,21,23:28,33:53,55,57],[1 3 8 9 17:36]); 
o2R.words = sortrows(o2R.lexique_words,'Item','ascend');

% Work in parallel on orthography and phonology
o2R.ortho = struct;
o2R.phon = struct;

% Add phonological and semantic groups to the list of words
p_group = {'eau';'ar';'ue';'on';'que';'eau';'ine';'ar';'ar';'i';'eau';'et';'on';'que';'ace';'on';'que';...
           'on';'er';'on';'ine';'i';'ar';'an';'ar';'in';'ace';'ar';'i';'on';'in';'on';'eau';'ace';...
           'on';'que';'on';'et';'on';'ar';'in';'an';'on';'et';'ue';'on';'er';'an'};
o2R.words.phGroup = categorical(p_group);

% Same for semantic categories
s_group = {'a';'p';'p';'p';'p';'p';'p';'a';'a';'a';'p';'p';'a';'p';'p';'a';'p';'p';'p';'a';'a';'a';'p';'a';...
           'a';'p';'a';'a';'p';'p';'p';'a';'a';'p';'p';'a';'a';'a';'p';'a';'a';'p';'a';'p';'a';'p';'a';'p'};
o2R.words.semGroup = categorical(s_group);

% Move new variables into an easier to find place
o2R.words = movevars(o2R.words, 'phGroup', 'Before', 'grapheme');
o2R.words = movevars(o2R.words, 'semGroup', 'Before', 'grapheme');

% Order by semantics and then by phonology (same as previous options)
o2R.words = sortrows(o2R.words,{'semGroup','phGroup'},'descend');

% Levenshtein distances matrices 
matrix_length = size(o2R.words,1);
for n = 1:matrix_length
    for o = 1:matrix_length
        o2R.ortho.lev_br(n,o) = levBrailleW(char(o2R.words{n,1}),char(o2R.words{o,1})); % ortho
        o2R.phon.lev_fon(n,o) = levPhonW(char(o2R.words{n,2}),char(o2R.words{o,2})); % phon
    end
end

clearvars group ling matrix_length n o p_group s_group 

%% OPT2REV - Graphics
% Serves as investigation: are there pairs with similar phonology but
% different orthographies? 

% RDMs - run one at the time, then move one to the side
labr = string(o2R.words{:,1}); % labels - words

o2R.ortho.lev_htmp = heatmap(labr,labr,o2R.ortho.lev_br,'CellLabelColor','none','Colormap',parula,'Units','pixels','Position',[60 60 650 650]);
o2R.phon.lev_htmp = heatmap(labr,labr,o2R.phon.lev_fon,'CellLabelColor','none','Colormap',parula,'Units','pixels','Position',[60 60 650 650]);

% Scale values to compare them
% Get max for each
o2R.phon.max_ph = max(o2R.phon.lev_fon,[],'all');
o2R.ortho.max_or = max(o2R.ortho.lev_br,[],'all');

% Divide each by its max, move them into a 0 to 1 scale
o2R.phon.lev_scaled = (o2R.phon.lev_fon) ./ (o2R.phon.max_ph);
o2R.ortho.lev_scaled = (o2R.ortho.lev_br) ./ (o2R.ortho.max_or);

% Comparison is substraction: higher value, more difference
o2R.comp_scaled = abs(o2R.ortho.lev_scaled - o2R.phon.lev_scaled);

% Show comparison values (not very informative)
lab_cmp = string(o2R.words{:,1});
o2R.comp_htmp = heatmap(lab_cmp,lab_cmp,o2R.comp_scaled,'CellLabelColor','none','Colormap',parula,'Units','pixels','Position',[60 60 650 650]);

% Like above, one at the time to show scaled rdms
lab_cmp = string(o2R.words{:,1});
o2R.ortho.scaled_htmp = heatmap(lab_cmp,lab_cmp,o2R.ortho.lev_scaled,'CellLabelColor','none','Colormap',parula,'Units','pixels','Position',[60 60 650 650]);
o2R.phon.scaled_htmp = heatmap(lab_cmp,lab_cmp,o2R.phon.lev_scaled,'CellLabelColor','none','Colormap',parula,'Units','pixels','Position',[60 60 650 650]);

clearvars lab_cmp labr

%% 16-06: ALL WORDS INVESTIGATION

% try getting rdms for all the words, even those where only 1 index is
% sufficiently frequent

attempt = struct;
attempt.allWords.words = sortrows(o2R.words,'Item','ascend');

matrix_length = size(attempt.allWords.words,1);
for n = 1:matrix_length
    for o = 1:matrix_length
        attempt.allWords.ortho.lev_all(n,o) = levBrailleW(char(attempt.allWords.words{n,1}),char(attempt.allWords.words{o,1})); % ortho
        attempt.allWords.phon.lev_all(n,o) = levPhonW(char(attempt.allWords.words{n,2}),char(attempt.allWords.words{o,2})); % phon
    end
end

max_attempt = max(attempt.allWords.phon.lev_all,[],'all');
attempt.allWords.phon.lev_scaled = (attempt.allWords.phon.lev_all) ./ (max_attempt);

l = string(attempt.allWords.words{:,1});
attempt.allWords.phon.all_htmp = heatmap(l,l,attempt.allWords.phon.lev_scaled,'CellLabelColor','none','Colormap',parula,'Units','pixels','Position',[60 60 650 650]);

% maison - mouton - moulin - dindon
% vipère - lézard - désert - ?place?

clearvars matrix_length n o l max_attempt

%% OPT1 - simple levenshtein

attempt.simpleLev = struct;
for p = 1:8
    for b = 1:8
        attempt.simpleLev.lev_mat(p,b) = lev(char(o1.summary{p,4}),char(o1.summary{b,4}));
    end
end
l = string(o1.summary{:,1});
attempt.simpleLev.htmp = heatmap(l,l,attempt.simpleLev.lev_mat,'CellLabelColor','none','Colormap',parula,'Units','pixels','Position',[60 60 650 650]);

clearvars b p l 
