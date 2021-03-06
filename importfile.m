function importfile(filetoread)

%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: /Users/happy1995419/Documents/MATLAB/HSI 2017.xlsx
%    Worksheet: ^HSI (3)
%
% To extend the code for use with different selected data or a different
% spreadsheet, generate a function instead of a script.

% Auto-generated by MATLAB on 2017/12/28 14:10:28

%% Import the data
[~, ~, raw] = xlsread(filetoread,'');
raw = raw(2:end,:);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
data = reshape([raw{:}],size(raw));
%% Allocate imported array to column variable names
assignin('base','Date1', data(:,1));
assignin('base','Open1', data(:,2));
assignin('base','High1',data(:,3));
assignin('base','Low1', data(:,4));
assignin('base','Close1', data(:,5));
assignin('base','AdjClose1',data(:,6));
assignin('base','Volume1', data(:,7));

%% Clear temporary variables
clearvars data raw R;