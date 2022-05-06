%% IMPORT ALL DAYS
%
% import data from the different csv 
% (only csv for the moment) 
%

% add downloads folder
addpath(genpath('Users/cerpelloni/Downloads'));

cd '../../../../../Downloads'

folders = dir('data_g*d*');

folderPaths = ""
for f = 1:size(folders,1)
    folderPaths = vertcat(folderPaths, string(folders(1).folder) + '/' + string(folders(f).name));
end
folderPaths(1) = [];

for f = 1:length(folderPaths)
    
    % import file 
    % catch empty exception
end

files = ["sub001ses002taskvisbraTrainingrun004", ...
         "sub001ses003taskvisbraTrainingrun001"];

for s = 1:length(files)
    eval(['this = ' char(files(s)) ';']);
    filename = files(s) + '_log.xls';
    writetable(this, filename);
end

%% prendi solo i dati importanti da log

eval(['this = sub001ses002taskvisbraTrainingrun004;']);
day = 2;
corr = table;
switch day
    case 1
        good_cases = ["french_letter", "test_response: autoDraw", "Keydown"];
        for t = 1:size(this,1)
            if startsWith(string(this.welcome_textUnitsHeight(t)), good_cases)
                corr = vertcat(corr,this(t,:));
            end
        end
    case {2,3,4}
        good_cases = ["Mouse: 0 button down", "french_word: autoDraw = true", ...
                      "braille_word: autoDraw = true", "test_response: autoDraw = true", "Keydown"];
        for t = 1:size(this,1)
            if startsWith(string(this.welcome_textUnitsHeight(t)), good_cases)
                corr = vertcat(corr,this(t,:));
            end
        end
    case 5
end

%% Add time and del multiple clicks
for c = size(corr,1):-1:2
    if strcmp(corr.welcome_textUnitsHeight(c), corr.welcome_textUnitsHeight(c-1))
        corr(c,:) = [];
    end
    if startsWith(corr.welcome_textUnitsHeight(c), "Mouse") && startsWith(corr.welcome_textUnitsHeight(c-1), "Mouse")
        corr(c,:) = [];    
    end
end

for c = 2:size(corr,1)
    corr.time(1) = 0;
    corr.time(c) = corr.VarName1(c) - corr.VarName1(c-1);
end

writetable(corr, 'sub-001_ses-002_run-004_simpleLog.xls');

%% get important data 

warning('off');

files = [
         "sub001ses002run004simpleLog", ...
         "sub001ses003run001simpleLog", ...
         
        ];
% "sub001ses001run001simpleLog", ...
% "sub001ses001run002simpleLog", ... 
% "sub002ses001run001simpleLog", ...
% "sub002ses001run002simpleLog", ...
% "sub003ses001run001simpleLog", ...
% "sub004ses001run001simpleLog", ...

sub001ses002run004simpleLog(2160:end,:) = [];

for f = 1:length(files)
    eval(['this = ' char(files(f)) ';']);
    if size(this,2) == 3
        this.Properties.VariableNames{3} = 'description';
        this.Properties.VariableNames{1} = 'time';
    else 
        this.Properties.VariableNames{4} = 'difference';
        this.Properties.VariableNames{3} = 'description';
        this.Properties.VariableNames{1} = 'time';
    end

    filename = char(files(f));
    filename = filename(1:18);
    % summary table
    that = table;

    switch filename(12) 
        case '1'
            % add difference
            for c = 2:size(this,1)
                this.difference(1) = 0;
                this.difference(c) = this.time(c) - this.time(c-1);
            end
            t = 1;
            % look for magic keywords 
            for i = 1:size(this,1) 
                % training
                if startsWith(string(this.description(i)),"french_letter: autoDraw = null")
                    desc = char(this.description(i-2));
                    that.letter(t) = desc(end);
                    that.readTime(t) = this.difference(i);
                    that.typeTime(t) = 0;

                    t = t + 1;
                % test
                elseif startsWith(string(this.description(i)),"test_response: autoDraw = true")
                    sumTime = 0;
                    d = i+1;
                    while  not(startsWith(string(this.description(d)),"test_response: autoDraw = null"))
                        sumTime = sumTime + this.difference(d);
                        d = d+1;
                    end
                    sumTime = sumTime + this.difference(d);
                    
                    that.letter(t) = '?';
                    that.readTime(t) = 0;
                    that.typeTime(t) = sumTime;
                    t = t+ 1;
                end
            end

        case {'2','3','4'}
            t = 1;
            % look for magic keywords 
            for i = 1:size(this,1) 
                % training
                if startsWith(string(this.description(i)),"braille_word: autoDraw = true")
                    readTime = 0;
                    checkTime = 0;
                    d = i+1;
                    while  not(startsWith(string(this.description(d)),"french_word: autoDraw = true"))
                        readTime = readTime + this.difference(d);
                        d = d+1;
                    end
                    readTime = readTime + this.difference(d);    
                    that.readTime(t) = readTime;

                    d = d + 1;
                    while not(startsWith(string(this.description(d)),"Mouse: 0 button down"))
                        checkTime = checkTime + this.difference(d);
                        d = d+1;
                    end
                    checkTime = checkTime + this.difference(d);
                    that.checkTime(t) = checkTime;
                    that.testTime(t) = 0;
                    t = t + 1;

                % test
                elseif startsWith(string(this.description(i)),"test_response: autoDraw = true")
                    sumTime = 0;
                    d = i+1;
                    while  not(startsWith(string(this.description(d)),"Mouse: 0 button down"))
                        sumTime = sumTime + this.difference(d);
                        d = d+1;
                    end
                    sumTime = sumTime + this.difference(d);
                    
                    that.readTime(t) = 0;
                    that.checkTime(t) = 0;
                    that.testTime(t) = sumTime;
                    t = t+ 1;
                end
            end

    end

    % save timings
    eval([filename 'timings = that;']);

end










