
clear

realWords = ["canard"; "castor"; "faucon"; "tortue"; "fourmi"; "oiseau"; "poulet"; "renard"; "saumon"; "souris"; ...
             "bouton"; "caméra"; "dessin"; "flacon"; "miroir"; "rasoir"; "montre"; "stéréo"; "valise"; "violon"];

pseudoWords = ["satard"; "catoir"; "fanvon"; "formin"; "paseau"; "poumer"; "renale"; "souson"; "sorise"; "toinue";...
               "boumon"; "cemére"; "disson"; "répoir"; "visoir"; "moitre"; "facoup"; "sivéro";	"vorise"; "voilon"];

nonWords = ["ghkhwz"; "hjjwky"; "kyqgxy"; "kjwqzx"; "jwykzj"; "yghzwx"; "gxhwxk"; "kqgwwh"; "hyygxz"; "gjzyyw"; ...
            "zjxhzq"; "yjgxhw"; "kqkwgy"; "gygqhk"; "xzjgwg"; "zwwyxj"; "qqhgkj"; "jxqkhq"; "qyzyhw"; "zxjqgk"];
 
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

nonWords(:,3) = ["20";"20";"25";"22";"21";"24";"21";"22";"25";"25";"23";"23";"22";"23";"23";"24";"22";"22";"26";"22"];

selNW = nonWords([1 2 4 5 7 8 13 14 15 17 18 20],[1:3]);
selRW = realWords([2:2,4:5,7:8,10:12,16:18,20:20],[1:3]);
selPW = pseudoWords([2:4,6:6,8:8,10:12,14:14,16:16,18:18,20:20],[1:3]);

avgPW = sum(double(selPW(:,3)))/12;
avgRW = sum(double(selRW(:,3)))/12;
avgNW = sum(double(selNW(:,3)))/12;

sdPW = std(double(selPW(:,3)));
sdRW = std(double(selRW(:,3)));
sdNW = std(double(selNW(:,3)));

save('word_analysis.mat');

