
d2_seen = ""; d2_new = ""; d2_pseudo = "";
d3_seen = ""; d3_new = ""; d3_pseudo = "";
d4_seen = ""; d4_new = ""; d4_pseudo = "";
d5_seen = ""; d5_new = ""; d5_pseudo = "";
d6_seen = ""; d6_new = ""; d6_pseudo = "";
d7_seen = ""; d7_new = ""; d7_pseudo = "";


for i = 1:120
    for j = 1:60
        if strcmp(test_seenwords{i},test_d2(j)),   d2_seen = vertcat(d2_seen,test_d2(j));   end
        if strcmp(test_newwords{i},test_d2(j)),    d2_new = vertcat(d2_new,test_d2(j));    end
        if strcmp(test_pseudowords(i),test_d2(j)), d2_pseudo = vertcat(d2_pseudo,test_d2(j)); end
        
        if strcmp(test_seenwords{i},test_d3(j)),   d3_seen = vertcat(d3_seen,test_d3(j));   end
        if strcmp(test_newwords{i},test_d3(j)),    d3_new = vertcat(d3_new,test_d3(j));    end
        if strcmp(test_pseudowords(i),test_d3(j)), d3_pseudo = vertcat(d3_pseudo,test_d3(j)); end
        
        if strcmp(test_seenwords{i},test_d4(j)),   d4_seen = vertcat(d4_seen,test_d4(j));   end
        if strcmp(test_newwords{i},test_d4(j)),    d4_new = vertcat(d4_new,test_d4(j));    end
        if strcmp(test_pseudowords(i),test_d4(j)), d4_pseudo = vertcat(d4_pseudo,test_d4(j)); end
        
        if strcmp(test_seenwords{i},test_d5(j)),   d5_seen = vertcat(d5_seen,test_d5(j));   end
        if strcmp(test_newwords{i},test_d5(j)),    d5_new = vertcat(d5_new,test_d5(j));    end
        if strcmp(test_pseudowords(i),test_d5(j)), d5_pseudo = vertcat(d5_pseudo,test_d5(j)); end
        
        if strcmp(test_seenwords{i},test_d6(j)),   d6_seen = vertcat(d6_seen,test_d6(j));   end
        if strcmp(test_newwords{i},test_d6(j)),    d6_new = vertcat(d6_new,test_d6(j));    end
        if strcmp(test_pseudowords(i),test_d6(j)), d6_pseudo = vertcat(d6_pseudo,test_d6(j)); end
        
        if strcmp(test_seenwords{i},test_d7(j)),   d7_seen = vertcat(d7_seen,test_d7(j));   end
        if strcmp(test_newwords{i},test_d7(j)),    d7_new = vertcat(d7_new,test_d7(j));    end
        if strcmp(test_pseudowords(i),test_d7(j)), d7_pseudo = vertcat(d7_pseudo,test_d7(j)); end
    end
end

%% choose the 40 training words to be checked mid-training and do this process
available = "";
for i = 1:300

    add_word = true;
    
    for j = 1:120
        if strcmp(training_words.ortho{i},test_seenwords{j})
            add_word = false;
            break
        end
    end

    if add_word
        available = vertcat(available, training_words.ortho{i});
    end

end
available(1) = [];

toDel = randperm(180);

deleted = available(toDel(81:180),:);

available(toDel(81:180),:) = [];

av1 = unique(available);
av2 = unique(available);

test = randperm(80,40);

av1(test(1:20),2) = "1";
av2(test(21:40),2) = "1";

no_test = zeros(1,60);
test = ones(1,20);
rand_test = horzcat(no_test, test)';
rand1 = shuffle(rand_test);
av1(:,2) = rand1;
rand2 = shuffle(rand_test);
av2(:,2) = rand2;

ortho = string(training_words{:,1});

% delet words
toDel2 = [];
for o = 1:length(ortho)
    if any (strcmp(ortho(o),deleted))
        toDel2 = horzcat(toDel2,o);
    end
end
ortho(toDel2,:) = [];
training_words(toDel2,:) = [];
%%
for k = 1:200
    for l = 1:80
        if strcmp(ortho(k),av1(l))
            ortho(k,2) = av1(l,2);
            break
        else
            ortho(k,2) = "0";
        end
    end
end

for k = 1:200
    for l = 1:80
        if strcmp(ortho(k),av2(l))
            ortho(k,3) = av2(l,2);
            break
        else
            ortho(k,3) = "0";
        end
    end
end