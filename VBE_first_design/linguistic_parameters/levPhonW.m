function [dist,L] = levPhonW(str1,str2)

% LEVENSHTEIN DISTANCE - Phonological Weighted version
%
% from wikipedia, modified to include weights
%

% Fontan matrices
con_table = table('Size',[17 9],...
                   'VariableTypes',{'categorical','double','double','double','double','double','double','double','double'},...
                   'VariableNames',{'sign','sonant','continu','voise','coronal','nasal','haut','arriere','anterieur'});
con_table(:,1) = {'p','b','t','d','k','g','f','v','s','z','S','Z','m','n','R','l','N'}';
con_table(:,2:end) = {0 0 0 0 0 0 0 1; 0 0 1 0 0 0 0 1; 0 0 0 1 0 0 0 1; 0 0 1 1 0 0 0 1; ...
                      0 0 0 0 0 1 1 0; 0 0 1 0 0 1 1 0; 0 1 0 0 0 0 0 1; 0 1 1 0 0 0 0 1; ...
                      0 1 0 1 0 0 0 1; 0 1 1 1 0 0 0 1; 0 1 0 1 0 1 0 0; 0 1 1 1 0 1 0 0; ...
                      1 1 1 0 1 0 0 1; 1 1 1 1 1 0 0 1; 1 1 1 0 0 1 1 0; 1 1 1 1 0 0 0 1; 1 1 1 0 1 1 0 0};

vow_table = table('Size',[17 7],...
                   'VariableTypes',{'categorical','double','double','double','double','double','double'},...
                   'VariableNames',{'sign','syllabique','nasal','haut','bas','rond','arriere'});
vow_table(:,1) = {'i','y','u','e','2','°','o','E','9','O','a','5','§','@','j','8','w'}';
vow_table(:,2:end) = {1 0 1 0 0 0; 1 0 1 0 1 0; 1 0 1 0 1 1; 1 0 0 0 0 0; ...
                      1 0 0 0 1 0; 1 0 0 0 1 0; 1 0 0 0 1 1; 1 0 0 1 0 0; 1 0 0 1 1 0; ...
                      1 0 0 1 1 1; 1 0 0 1 0 1; 1 1 0 0 1 0; 1 1 0 0 1 1; ...
                      1 1 0 1 0 1; 0 0 1 0 0 0; 0 0 1 0 0 0; 0 0 1 0 1 1};

L1=length(str1)+1;
L2=length(str2)+1;
L=zeros(L1,L2);

g=+1; % just constant
m=+0; % match is cheaper, we seek to minimize

% d is the general cost
%
%d=+1; % not-a-match is more costly.

%do BC's
L(:,1)=([0:L1-1]*g)';
L(1,:)=[0:L2-1]*g;

m4=0; % loop invariant
for idx=2:L1
    for idy=2:L2
        if(str1(idx-1)==str2(idy-1))
            score=m;
        else % depends on the properties
            if any(str1(idx-1) == vow_table{:,1}) % first is vowel (V)
                if any(str2(idy-1) == vow_table{:,1}) % second is vowel (V)
                    prop_str1 = vow_table{vow_table.sign == str1(idx-1),2:end};
                    prop_str2 = vow_table{vow_table.sign == str2(idy-1),2:end};
                    
                    % number of different feautres over the total
                    d = (6 - sum(prop_str1 == prop_str2)) / 6;
                else % first is V, second is consonant (C)
                    d = 1;
                end
            else % first is C
                if any(str2(idy-1) == con_table{:,1}) % second is C
                    prop_str1 = con_table{con_table.sign == str1(idx-1),2:end};
                    prop_str2 = con_table{con_table.sign == str2(idy-1),2:end};
                    
                    % number of different feautres over the total
                    d = (8 - sum(prop_str1 == prop_str2)) / 8;
                else % first is C, second is V
                    d = 1;
                end
            end
            
            % After getting the value, assign it
            score = d;
        end
        m1=L(idx-1,idy-1) + score;
        m2=L(idx-1,idy) + g;
        m3=L(idx,idy-1) + g;
        L(idx,idy)=min(m1,min(m2,m3));
    end
end

dist=L(L1,L2);
return
end