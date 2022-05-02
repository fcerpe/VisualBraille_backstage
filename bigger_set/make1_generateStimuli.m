
clear

realWords = ["canard"; "castor"; "faucon"; "tortue"; "fourmi"; "oiseau"; "poulet"; "renard"; "saumon"; "souris"; ...
             "bouton"; "caméra"; "dessin"; "flacon"; "miroir"; "rasoir"; "montre"; "stéréo"; "valise"; "violon"];

pseudoWords = ["satard"; "catoir"; "fanvon"; "formin"; "paseau"; "poumer"; "renale"; "souson"; "sorise"; "toinue";...
               "boumon"; "cemére"; "disson"; "répoir"; "visoir"; "moitre"; "facoup"; "sivéro";	"vorise"; "voilon"];

nonWords = ["yyqhgw"; "xxykzh"; "ykqgkx"; "zqkhzw"; "gywhxg"; "wxzkgw"; "gkqqzx"; "kyhqwy"; "qqhgwk"; "zghywg";...
            "hhzxyg"; "kqxzzw"; "wxqzgg"; "ykzxwq"; "ygkhkx"; "kyzkxh"; "hwgqyw"; "zgxqyz"; "qgyxkk"; "xhhwqy"];
 
load('mvpa_stimuli.mat');

pseudoWords(:,2) = brailify(pseudoWords, stimuli);
realWords(:,2) = brailify(realWords, stimuli);
nonWords(:,2) = brailify(nonWords, stimuli);

realWords(1,3) = "15";realWords(2,3) = "17";realWords(3,3) = "16";realWords(4,3) = "20";
realWords(5,3) = "18";realWords(6,3) = "14";realWords(7,3) = "19";realWords(8,3) = "18";
realWords(9,3) = "17";realWords(10,3) = "18";realWords(11,3) = "19";realWords(12,3) = "17";
realWords(13,3) = "17";realWords(14,3) = "16";realWords(15,3) = "16";realWords(16,3) = "17";
realWords(17,3) = "20";realWords(18,3) = "26";realWords(19,3) = "15";realWords(20,3) = "19";

pseudoWords(1,3) = "16";pseudoWords(2,3) = "16";pseudoWords(3,3) = "19";pseudoWords(4,3) = "19";
pseudoWords(5,3) = "14";pseudoWords(6,3) = "19";pseudoWords(7,3) = "16";pseudoWords(8,3) = "19";
pseudoWords(9,3) = "17";pseudoWords(10,3) = "18";pseudoWords(11,3) = "18";pseudoWords(12,3) = "19";
pseudoWords(13,3) = "18";pseudoWords(14,3) = "23";pseudoWords(15,3) = "18";pseudoWords(16,3) = "18";
pseudoWords(17,3) = "16";pseudoWords(18,3) = "22";pseudoWords(19,3) = "18";pseudoWords(20,3) = "19";

nonWords(1,3) = "26";nonWords(2,3) = "22";nonWords(3,3) = "22";nonWords(4,3) = "22";
nonWords(5,3) = "24";nonWords(6,3) = "22";nonWords(11,3) = "23";nonWords(12,3) = "23";
nonWords(13,3) = "25";nonWords(14,3) = "24";nonWords(15,3) = "20";nonWords(16,3) = "20";
nonWords(7,3) = "24";nonWords(8,3) = "24";nonWords(9,3) = "23";nonWords(10,3) = "24";
nonWords(17,3) = "25";nonWords(18,3) = "26";nonWords(19,3) = "22";nonWords(20,3) = "24";

selNW = nonWords([2:6,9:12,15:16,19:19],[1:3]);
selRW = realWords([2:2,4:5,7:8,10:12,16:18,20:20],[1:3]);
selPW = pseudoWords([2:4,6:6,8:8,10:12,14:14,16:16,18:18,20:20],[1:3]);

avgPW = sum(double(selPW(:,3)))/12;
avgRW = sum(double(selRW(:,3)))/12;
avgNW = sum(double(selNW(:,3)))/12;

sdPW = std(double(selPW(:,3)));
sdRW = std(double(selRW(:,3)));
sdNW = std(double(selNW(:,3)));

save('word_analysis.mat');

