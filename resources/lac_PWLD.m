function [dist,L] = lac_PWLD(str1,str2)

% LEVENSHTEIN DISTANCE - Phonological Weighted version
%
% from wikipedia, modified to include weights
%

% Lacheret table
ph_table = table('Size',[34 10],...
                   'VariableTypes',{'categorical','double','double','double','double','double','double','double','double','double'},...
                   'VariableNames',{'sign','voyelle','arrondi','anterieur','continu','nasal','sonore','sonante','moyen','ferme'});
ph_table(:,1) = {'p','b','m','f','v','t','d','n','s','z','l','k','g','N','S','Z','R',...
                   'i','e','E','a','y','2','°','9','u','o','O','5','@','§','j','w','h'}';
ph_table(:,2:end) = {0 1 1 0 0 0 0 0 0; 0 1 1 0 0 1 0 0 0; 0 1 1 1 1 1 1 0 0; 0 1 1 1 0 0 0 0 0;...
                       0 1 1 1 0 1 0 0 0; 0 0 1 0 0 0 0 0 0; 0 1 0 0 1 0 0 0 0; 0 0 1 1 1 1 1 0 0;...
                       0 0 1 1 0 0 0 0 0; 0 0 1 1 0 1 0 0 0; 0 0 1 1 0 1 1 0 0; 0 0 0 0 0 0 0 0 1;...
                       0 0 0 0 1 0 0 0 1; 0 0 0 1 1 1 1 0 1; 0 0 1 0 0 0 0 0 1; 0 0 0 1 0 1 0 0 1;...
                       0 0 0 1 0 1 1 0 1; 1 0 1 1 0 1 1 0 1; 1 0 1 1 0 1 1 1 1; 1 0 1 1 0 1 1 1 0;...
                       1 0 1 1 0 1 1 0 0; 1 1 1 1 0 1 1 0 1; 1 1 1 1 0 1 1 1 1; 1 1 1 1 0 1 1 1 1; 1 1 1 1 0 1 1 1 0;...
                       1 1 0 1 0 1 1 0 1; 1 1 0 1 0 1 1 1 1; 1 1 0 1 0 1 1 1 0; 1 0 1 1 1 1 1 1 0;...
                       1 0 0 1 1 1 1 0 0; 1 1 0 1 1 1 1 1 0; 0 0 1 1 0 1 1 0 1; 0 1 0 1 0 1 1 0 1; 0 1 1 1 0 1 1 0 1};


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
            if ph_table{ph_table.sign == str1(idx-1),2} == 1 % first is vowel (V)
                if ph_table{ph_table.sign == str2(idy-1),2} == 1 % second is vowel (V)
                    prop_str1 = ph_table{ph_table.sign == str1(idx-1),3:end};
                    prop_str2 = ph_table{ph_table.sign == str2(idy-1),3:end};
                    
                    % number of different feautres over the total
                    d = (6 - sum(prop_str1 == prop_str2)) / 6;
                else % first is V, second is consonant (C)
                    d = 1;
                end
            else % first is C
                if ph_table{ph_table.sign == str2(idy-1),2} == 0 % second is C
                    prop_str1 = ph_table{ph_table.sign == str1(idx-1),3:end};
                    prop_str2 = ph_table{ph_table.sign == str2(idy-1),3:end};
                    
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