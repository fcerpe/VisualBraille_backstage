
clear

% from previous selection(s)
realWords = ["castor"; "tortue"; "fourmi"; "poulet"; "renard"; "souris"; ...
             "bouton"; "caméra"; "rasoir"; "montre"; "stéréo"; "violon"];

pseudoWords = ["catoir"; "fanvon"; "formin"; "poumer"; "souson"; "toinue";...
               "boumon"; "cemére"; "répoir"; "moitre"; "sivéro"; "voilon"];

nonWords = ["mkhbsl"; "lkmftb"; "dgkbsl"; "pchlzb"; "ybdckg"; "htcdyk"; ...
            "xydchb"; "fhydgk"; "vskrtf"; "tlsncq"; "khsryz"; "ghzntj"];    
 

load('stimuliProperties.mat');

% get braille version and number of dots
realWords = assignDotsAndNumber(realWords, stimuli);
pseudoWords = assignDotsAndNumber(pseudoWords,stimuli);
nonWords = assignDotsAndNumber(nonWords, stimuli);

avgDotsRW = mean(double(realWords(:,3)));
avgDotsPW = mean(double(pseudoWords(:,3)));
avgDotsNW = mean(double(nonWords(:,3)));

save('word_generateStimuli.mat');

