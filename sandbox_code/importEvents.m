function eventFile = importEvents(filename)

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 8);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["onset", "duration", "trial_type", "image", "target", "event", "block", "keyName"];
opts.VariableTypes = ["double", "double", "categorical", "categorical", "double", "double", "double", "categorical"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["trial_type", "image", "keyName"], "EmptyFieldRule", "auto");

% Import the data
eventFile = readtable(filename, opts);

end