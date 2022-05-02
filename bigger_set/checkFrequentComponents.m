function [rep, sel] = checkFrequentComponents(words, let, bi, tri)

% CHECK FREQUENT COMPONENTS
% get those elements (words or pseudo) that are composed of frequent letters,
% bigrams, trigrams
%
% Inputs:
% - words: table from lexique (or any table, as long as first coloumn is
%           made of strings) from which we get the words to analyse
%           Not a flexible script: we alrady know that the words are 6
%           letters long, won't work with other lengths
% - let: frequent letters for our alphabet (at the moment only french)
% - bi: frequent bigrams
% - tri: frequent trigrams
%
% Outputs:
% - rep: report table, indicating each word analysed, whether it was
%        accepted and, if not, the reason (letters, bigrams, trigrams)
% - sel: table containing the words that passed the selection

warning('off')

report = table;
selWords = "";

% code first, make a function later. Deal with generalized variables in a
% lazy way
lex = words;    selLetters = let;   selBigrammes = bi;  selTrigrammes = tri;

% for each word
for w = 1:size(lex,1)

    % get string array of word
    thisW = split(lex(w),"");
    thisW = thisW([2 3 4 5 6 7]);
    thisW = string(thisW);

    validL = [0 0 0 0 0 0];
    validB = [0 0 0 0 0 0];
    validT = [0 0 0 0 0 0];

    % look at letters
    % each letter must be made a frequent one
    for l = 1:6
        thisL = thisW(l);
        if any(strcmp(thisL, selLetters))
            validL(l) = 1;
        else
            validL(l) = 0;
        end
    end

    % if letters are not ok, there's no reason to look at bi- or tri-
    if not(all(validL))
        report.word(w) = lex(w);
        report.accepted(w) = "no";
        report.reason(w) = "letters";
    else
        % look at bigrammes
        for b = 1:2:6
            thisB = thisW(b) + thisW(b+1);
            if any(strcmp(thisB, selBigrammes))
                validB(b) = 1;
                validB(b+1) = 1;
            else
                validB(b) = 0;
                validB(b+1) = 0;
            end
        end

        % are bigrammes ok? if so, check the trigrammes, otherwise report
        % and exit
        % (if condition is the opposite)
        if not(all(validB))
            report.word(w) = lex(w);
            report.accepted(w) = "no";
            report.reason(w) = "bigrammes";
        else

            % look at trigrammes
            for t = 1:3:6
                thisT = thisW(t) + thisW(t+1) + thisW(t+2);
                if any(strcmp(thisT, selTrigrammes))
                    validT(t) = 1;
                    validT(t+1) = 1;
                    validT(t+2) = 1;
                else
                    validT(t) = 0;
                    validT(t+1) = 0;
                    validT(t+2) = 0;
                end
            end

            % this is the last one, either they're bad (and thus report)
            % or they're good (then report and write them in a new table)
            if not(all(validT))
                report.word(w) = lex(w);
                report.accepted(w) = "no";
                report.reason(w) = "trigrammes";

            else % word is ok, save it
                selWords = vertcat(selWords, lex(w));
                report.word(w) = lex(w);
                report.accepted(w) = "yes";
            end

        end
    end
end

rep = report;
sel = selWords(2:end);

end

