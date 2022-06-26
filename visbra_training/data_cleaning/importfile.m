function importParticipant = importfile(filename, dataLines)
%IMPORTFILE Import data from a text file
%  PARTICIPANTTRG1D1EXP2022032417H31 = IMPORTFILE(FILENAME) reads data
%  from text file FILENAME for the default selection.  Returns the data
%  as a table.
%
%  PARTICIPANTTRG1D1EXP2022032417H31 = IMPORTFILE(FILE, DATALINES) reads
%  data for the specified row interval(s) of text file FILENAME. Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  PARTICIPANTtrg1d1exp2022032417h31 = importfile("/Users/cerpelloni/Downloads/data_g1d1_0604/PARTICIPANT_tr_g1d1_exp_2022-03-24_17h31.36.534.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 06-Apr-2022 11:40:30

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 51, "Encoding", "UTF-8");

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["welcome_mousex", "welcome_mousey", "welcome_mouseleftButton", "welcome_mousemidButton", "welcome_mouserightButton", "train_mousex", "train_mousey", "train_mouseleftButton", "train_mousemidButton", "train_mouserightButton", "braille_mousex", "braille_mousey", "braille_mouseleftButton", "braille_mousemidButton", "braille_mouserightButton", "let_loopthisRepN", "let_loopthisTrialN", "let_loopthisN", "let_loopthisIndex", "let_loopran", "frLet", "brLet", "cbLet", "subjectID", "date", "expName", "psychopyVersion", "OS", "frameRate", "mousex", "mousey", "mouseleftButton", "mousemidButton", "mouserightButton", "testInstr_mousex", "testInstr_mousey", "testInstr_mouseleftButton", "testInstr_mousemidButton", "testInstr_mouserightButton", "test_responsetext", "testResp", "test_mousex", "test_mousey", "test_mouseleftButton", "test_mousemidButton", "test_mouserightButton", "test_loopthisRepN", "test_loopthisTrialN", "test_loopthisN", "test_loopthisIndex", "test_loopran"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "categorical", "categorical", "categorical", "double", "categorical", "double", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["test_responsetext", "testResp"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["frLet", "brLet", "cbLet", "date", "psychopyVersion", "test_responsetext", "testResp"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["expName", "OS"], "TrimNonNumeric", true);
opts = setvaropts(opts, ["expName", "OS"], "ThousandsSeparator", ",");

% Import the data
temp = readtable(filename, opts);

% eval(['sub-' temp.subjectID(1) '_ses-' temp.expName(1)]);

end