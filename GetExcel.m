% Objective: pull data from excel file and organize into array in matlab.

% Input: - filepath       = path of desired excel file.
%        - filename       = file name of excel file.
%        - xlrange        = cell range to pull data from.
%        - sheet          = sheet in excel file to pull data from.

% Output: - data          = matlab array of data pulled from excel.

% Author: S Hunerwadel (4/1/2019)

function [data] = GetExcel(filename, filepath, xlrange, sheet)

File = fullfile(filepath, filename); % store file name and path
[data] = xlsread(File, sheet, xlrange); % read excel data