%% IMPORT ALL DAYS
%
% import data from the different log files to extract the events durations
%

% add downloads folder
addpath(genpath('/Volumes/GoogleDrive-102888221454702880647/My Drive/work/PhD/vwfa_training/data'))
addpath(genpath('.'))

cd '../../../../../Google Drive/My Drive/work/PhD/vwfa_training/data'

% standard sub-0XX name of folder. First * is to avoid case sensitivity
folders = dir('*ub-0*');

% keep also track of the files, to loop through them later
fileList = "";

% go folder by folder and get all the log files that correspond to the standard, a.k.a get the
% participants
for f = 1:size(folders,1)

    eval(['cd ' folders(f).name '']);
    % get the right files
    filesInFolder = dir('sub-*_day-*.log');
    for ff = 1:size(filesInFolder,1)


        % import the file and name is as the filename
        thisLog = importSub(filesInFolder(ff).name);

        % get only important parts out of the full filename
        thisName = char(filesInFolder(ff).name);
        thisName = thisName([1 5:9 13:15 36:37 41:43]);
        fileList = vertcat(fileList, string(thisName));
        eval(['' thisName ' = thisLog;']);

    end

    % go back to main folder
    cd ..

end


% return to visbra_training / data_cleaning
cd /Users/cerpelloni/Desktop/GitHub/VB_backstage_code/visbra_training/data_cleaning

clearvars ans f ff filesInFolder folders thisLog thisName
fileList(1) = [];
save('imported_logs.mat');

%% Clear data for each log file, based on the day of training

% final matrix to look at
summaryOfTiming = struct;
summaryOfTiming.day1 = table; %('Size',[40, 3], 'VariableTypes',{'string','double','double'}, ...
                             % 'VariableNames',{'subNb','avg_trainTime','avg_testTime'});
summaryOfTiming.day2 = table; %('Size',[40, 3], 'VariableTypes',{'string','double','double'}, ...
                             % 'VariableNames',{'subNb','avg_trainTime','avg_testTime'});
summaryOfTiming.day3 = table; %('Size',[40, 3], 'VariableTypes',{'string','double','double'}, ...
                             % 'VariableNames',{'subNb','avg_trainTime','avg_testTime'});
summaryOfTiming.day4 = table; %('Size',[40, 3], 'VariableTypes',{'string','double','double'}, ...
                             % 'VariableNames',{'subNb','avg_trainTime','avg_testTime'});
summaryOfTiming.day5 = table;
d1counter = 1; d2counter = 1; d3counter = 1; d4counter = 1;

for s = 1:length(fileList)

    eval(['thisLog = ' char(fileList(s)) ';']);
    thisName = char(fileList(s));

    correction = table;
    warning('off'); % living dangerously

    % files aredifferent based on day: choose wisely
    switch thisName(9)

        % letters training, letters test
        case '1'
            % clean the first part, all before the training text is not
            % important
            startIdx = find(startsWith(thisLog.message, "train_text: autoDraw = null"));

            % pick the important lines
            good_cases = ["french_letter", "test_response: autoDraw", "Keydown", ...
                          "test_braille: autoDraw = true"];

            for t = startIdx:size(thisLog,1)
                if startsWith(string(thisLog.message(t)), good_cases)
                    % if they match, add it to the pile
                    correction = vertcat(correction,thisLog(t,:));
                end
            end

            % words training, words test
        case {'2','3'}
            startIdx = find(startsWith(thisLog.message, "trainInstr_text: autoDraw = null"));

            good_cases = ["Mouse: 0 button down", "french_word: autoDraw = true", ...
                "braille_word: autoDraw = true", "test_response: autoDraw = true", "Keydown", ...
                "test_word: autoDraw = true"];

            for t = startIdx:size(thisLog,1)
                if startsWith(string(thisLog.message(t)), good_cases)
                    correction = vertcat(correction,thisLog(t,:));
                end
            end

        % phrases training, words test
        case '4'
            startIdx = find(startsWith(thisLog.message, "trainInstr_text: autoDraw = null"));

            good_cases = ["Mouse: 0 button down", "french_phr: autoDraw = true", ...
                "braille_phr: autoDraw = true", "test_response: autoDraw = true", "Keydown", ...
                "test_phr: autoDraw = true"];

            for t = startIdx:size(thisLog,1)
                if startsWith(string(thisLog.message(t)), good_cases)
                    correction = vertcat(correction,thisLog(t,:));
                end
            end
    end


    % Whatever the day of the log file,
    % clear events and calculate differences
    for c = size(correction,1):-1:2
        % if events are repeated or there are multiple clicks
        if strcmp(correction.message(c), correction.message(c-1)) || ...
                startsWith(correction.message(c), "Mouse") && startsWith(correction.message(c-1), "Mouse")

            % brutally delete the row, we don't need it
            correction(c,:) = [];
        end

    end

    % first time difference is 0
    correction.delta(1) = 0;

    % for the others, lets calculate it
    for d = 2:size(correction,1)
        correction.delta(d) = correction.time(d) - correction.time(d-1);
    end

    % temporary save
    eval([char(fileList(s)) '_correction = correction;']);

    % make a nice summary of each table
    % switch again, could be more efficient
    thisTimings = table;

    switch thisName(9)

        case '1'
            t = 1;
            % look for magic keywords
            for i = 1:size(correction,1)
                % training
                if startsWith(string(correction.message(i)),"french_letter: autoDraw = null")
                    desc = char(correction.message(i-2));

                    thisTimings.letter(t) = desc(end);
                    thisTimings.trainReadTime(t) = correction.delta(i);
                    thisTimings.testReadTime(t) = NaN;
                    thisTimings.testTypeTime(t) = NaN;
                    t = t + 1;

                % test
                % word reading
                elseif startsWith(string(correction.message(i)), "test_braille: autoDraw = true")
                    sumTime = 0;
                    d = i+1;
                    while  not(startsWith(string(correction.message(d)), "Keydown: ArrowDown"))
                        sumTime = sumTime + correction.delta(d);
                        d = d+1;
                    end
                    sumTime = sumTime + correction.delta(d);

                    thisTimings.trainReadTime(t) = NaN;
                    thisTimings.testReadTime(t) = sumTime;                    
                
                % test typing time
                elseif startsWith(string(correction.message(i)), "test_response: autoDraw = true")
                    sumTime = 0;
                    d = i+1;
                    while  not(startsWith(string(correction.message(d)), "test_response: autoDraw = null"))
                        sumTime = sumTime + correction.delta(d);
                        d = d+1;
                    end
                    sumTime = sumTime + correction.delta(d);

                    thisLetter = char(correction.message(d-1));
                    
                    thisTimings.letter(t) = thisLetter(end);
                    thisTimings.trainReadTime(t) = NaN;
                    thisTimings.testTypeTime(t) = sumTime;
                    t = t+ 1;
                end
            end

            % get data of participant and add it to the summary
            trainingReadTime = mean(thisTimings.trainReadTime(1:259));
            testReadTime = mean(thisTimings.testReadTime(260:end));

        case {'2','3'}
            t = 1;
            % look for magic keywords
            for i = 1:size(correction,1)

                % training
                if startsWith(string(correction.message(i)),"braille_word: autoDraw = true")
                    readTime = 0;
                    checkTime = 0;
                    d = i+1;

                    while  not(startsWith(string(correction.message(d)),"french_word: autoDraw = true"))
                        readTime = readTime + correction.delta(d);
                        d = d+1;
                    end
                    readTime = readTime + correction.delta(d);
                    thisTimings.trainReadTime(t) = readTime;
                    d = d + 1;

                    while not(startsWith(string(correction.message(d)),"Mouse: 0 button down"))
                        checkTime = checkTime + correction.delta(d);
                        d = d+1;
                    end
                    checkTime = checkTime + correction.delta(d);
                    thisTimings.trainCheckTime(t) = checkTime;
                    thisTimings.testReadTime(t) = 0;
                    t = t + 1;

                    % test - CHECK THAT IT GETS WHAT WE WANT
                elseif startsWith(string(correction.message(i)), "test_word: autoDraw = true")
                    sumTime = 0;
                    d = i+1;
                    while  not(startsWith(string(correction.message(d)), "Keydown: ArrowDown"))
                        sumTime = sumTime + correction.delta(d);
                        d = d+1;
                    end
                    sumTime = sumTime + correction.delta(d);

                    thisTimings.trainReadTime(t) = 0;
                    thisTimings.trainCheckTime(t) = 0;
                    thisTimings.testReadTime(t) = sumTime;
                    t = t+ 1;
                end
            end
    
            % get data of participant and add it to the summary
            trainingReadTime = mean(thisTimings.trainReadTime(1:200));
            testReadTime = mean(thisTimings.testReadTime(201:end));

        case '4'
            t = 1;
            % look for magic keywords
            for i = 1:size(correction,1)

                % training
                if startsWith(string(correction.message(i)), "braille_phr: autoDraw = true")
                    readTime = 0;
                    checkTime = 0;
                    d = i+1;

                    while  not(startsWith(string(correction.message(d)), "french_phr: autoDraw = true"))
                        readTime = readTime + correction.delta(d);
                        d = d+1;
                    end
                    readTime = readTime + correction.delta(d);
                    thisTimings.trainReadTime(t) = readTime;
                    d = d + 1;

                    while not(startsWith(string(correction.message(d)),"Mouse: 0 button down"))
                        checkTime = checkTime + correction.delta(d);
                        d = d+1;
                    end
                    checkTime = checkTime + correction.delta(d);
                    thisTimings.trainCheckTime(t) = checkTime;
                    thisTimings.testReadTime(t) = 0;
                    t = t + 1;

                    % test - CHECK THAT IT GETS WHAT WE WANT
                elseif startsWith(string(correction.message(i)), "test_phr: autoDraw = true")
                    sumTime = 0;
                    d = i+1;
                    while  not(startsWith(string(correction.message(d)), "Keydown: ArrowDown"))
                        sumTime = sumTime + correction.delta(d);
                        d = d+1;
                    end
                    sumTime = sumTime + correction.delta(d);

                    thisTimings.trainReadTime(t) = 0;
                    thisTimings.trainCheckTime(t) = 0;
                    thisTimings.testReadTime(t) = sumTime;
                    t = t+ 1;
                end
            end
    
            % get data of participant and add it to the summary
            trainingReadTime = mean(thisTimings.trainReadTime(1:30));
            testReadTime = mean(thisTimings.testReadTime(31:end));

    
    end

    

    eval(['summaryOfTiming.day' thisName(9) '.subNb(d' thisName(9) 'counter) = string(thisName(2:4));']);
    eval(['summaryOfTiming.day' thisName(9) '.avg_trainTime(d' thisName(9) 'counter) = trainingReadTime;']);
    eval(['summaryOfTiming.day' thisName(9) '.avg_testTime(d' thisName(9) 'counter) = testReadTime;']);
    eval(['d' thisName(9) 'counter = d' thisName(9) 'counter + 1;']);

    % temporary save of the single subject timings
    eval([char(fileList(s)) '_timings = thisTimings;']);

end


%% clear data and save .mat

clearvars ans c checkTime correction d desc good_cases i readTime s startIdx sumTime t thisLog thisName thisSummary
clearvars d1counter d2counter d3counter d4counter trainingReadTime testReadTime thisLetter thisTimings

writetable(summaryOfTiming.day1,'output/summary_timings_day1.xlsx');
writetable(summaryOfTiming.day2,'output/summary_timings_day2.xlsx');
writetable(summaryOfTiming.day3,'output/summary_timings_day3.xlsx');
writetable(summaryOfTiming.day4,'output/summary_timings_day4.xlsx');

save('summary_of_logs.mat')
