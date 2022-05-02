function [dist,L] = levBrailleW(str1,str2)

% LEVENSHTEIN DISTANCE - Phonological Weighted version
%
% from wikipedia, modified to include weights
%

% Lacheret table
br_table = table('Size',[39 7],...
                   'VariableTypes',{'categorical','double','double','double','double','double','double'},...
                   'VariableNames',{'sign','dot1','dot2','dot3','dot4','dot5','dot6'});
br_table(:,1) = {'a';'b';'c';'d';'e';'f';'g';'h';'i';'j';'k';'l';'m';'n';'o';...
                 'p';'q';'r';'s';'t';'u';'v';'w';'x';'y';'z';'ç';'é';'à';'è';...
                 'ù';'â';'ê';'î';'ô';'û';'ë';'ï';'ü'};
br_table(:,2:end) = {1 0 0 0 0 0; 1 1 0 0 0 0; 1 0 0 1 0 0; 1 0 0 1 1 0;...
                     1 0 0 0 1 0; 1 1 0 1 0 0; 1 1 0 1 1 0; 1 1 0 0 1 0; 0 1 0 1 0 0; ...
                     0 1 0 1 1 0; 1 0 1 0 0 0; 1 1 1 0 0 0; 1 0 1 1 0 0; 1 0 1 1 1 0;...
                     1 0 1 0 1 0; 1 1 1 1 0 0; 1 1 1 1 1 0; 1 1 1 0 1 0; 0 1 1 1 0 0;...
                     0 1 1 1 1 0; 1 0 1 0 0 1; 1 1 1 0 0 1; 0 1 0 1 1 1; 1 0 1 1 0 1; ...
                     1 0 1 1 1 1; 1 0 1 0 1 1; 1 1 1 1 0 1; 1 1 1 1 1 1; 1 1 1 0 1 1;...
                     0 1 1 1 0 1; 0 1 1 1 1 1; 1 0 0 0 0 1; 1 1 0 0 0 1; 1 0 0 1 0 1; ....
                     1 0 0 1 1 1; 1 0 0 0 1 1; 1 1 0 1 0 1; 1 1 0 1 1 1; 1 1 0 0 1 1};


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
        else % how many overlapping dots?
            
            prop_str1 = br_table{br_table.sign == str1(idx-1),2:end};
            prop_str2 = br_table{br_table.sign == str2(idy-1),2:end};
            
            % number of different feautres over the total
            d = (6 - sum(prop_str1 == prop_str2)) / 6;
            
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