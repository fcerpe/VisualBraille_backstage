%% ARTEM'S CODE

score1 = [8 5 8 10 10 5 5 10 10 5 8 8 5 10 8 8 5 8 5 10 5 8 10 10];
score2 = [0 0 0 0 0 0 0 2 2 2 2 2 2 0 2 0 2 0 0 0 2 2 2 2];

for s1=1:24
    for s2=1:24
        score1_diff(s1,s2) = abs(score1(s1)-score1(s2));
        score2_diff(s1,s2) = abs(score2(s1)-score2(s2));
    end
end

vect_score1_diff = score1_diff(triu(true(size(score1_diff)),1));
vect_score2_diff = score2_diff(triu(true(size(score2_diff)),1));

r = corrcoef(vect_score1_diff,vect_score2_diff);