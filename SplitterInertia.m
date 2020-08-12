% Objective: perform routine to determine the splitter deflection do to 
%            inertia as a transfer function (in of deflection per g).

% Function files required:
%
%   - GetExcel.m
%   - Integrate.m
%   - TransFunction.m

% Notes: The script is intended to pull data from an Excel file which
%        contains data outputed from Pi Toolbox at 200 Hz with columns in 
%        this order: time, LF splitter accel, RF splitter accel, 
%        LF frame accel, RF frame accel. No post-processing of the Excel is
%        required after export from Pi. The last line of the script can be
%        commented out to leave tabular data available in the workspace.

% Author: S Hunerwadel (4/1/2019)

%% Clean up workspace

clear variables
clc

%% Pull data from Excel

h = waitbar(.12, 'Pulling data from Excel');

basedir = 'C:\';  % set base directory

[filename, filepath] = uigetfile('*.xls', ...
      'Please choose an Excel file', basedir); % ask for file to pull data
if filename == 0
    disp('User did not select a file');
    clear variables
    return
end

xlrangeti = 'A2'; % cell to pull initial time value
xlranget = 'A2:A50000'; % cells to pull time data from
xlrange1 = 'B2:B50000'; % cells to pull LF splitter accel data from
xlrange2 = 'C2:C50000'; % cells to pull RF splitter accel data from
xlrange3 = 'D2:D50000'; % cells to pull LF frame accel data from
xlrange4 = 'E2:E50000'; % cells to pull RF frame accel data from

var = {xlrangeti, xlranget, xlrange1, xlrange2, ...
                            xlrange3, xlrange4}; % organize into array
                        
sheet = 'Channel Data'; % excel sheet to pull from

fields = {'toff', 't', 'LF_Spl', 'RF_Spl', ...
                   'LF_Frame', 'RF_Frame'}; % create field names in array

for i = 1:length(fields) % pull excel data and store in fields
    [data.raw.(fields{i})] = GetExcel(filename, filepath, ...
                            (var{i}), sheet);
end

clear xlrangeti xlranget xlrange1 xlrange2 xlrange3 xlrange4 sheet ...
        toff basedir filename filepath i var fields % clear used variables
    
%% Create average frame 'g' data

waitbar(.24, h, 'Creating average frame rail g data');

data.frameg = (data.raw.LF_Frame + ...
                        data.raw.RF_Frame)/2; % average frame accel data
data.frameg(end) = [];
data.frameg(end) = []; % shorten data set twice (to match integrated data)

%% Modify time data

waitbar(.36, h, 'Modifying time data for integration');

data.t = data.raw.t - data.raw.toff; % offset time to start at zero
data.tminus1 = data.t; % create tminus1 data set
data.tminus1(end) = []; % remove last cell value from array (minus 1)

%% Convert data from 'g' to in/s^2

waitbar(.48, h, 'Converting from g to in/s^2');

fields = fieldnames(data.raw); % create field names array
 
for i = 3:4 % loop through splitter accel data and convert to in/s^2
[data.ips.(fields{i})] = data.raw.(fields{i}) * 32.2 * 12;
end

clear i fields % clear used variables

%% Integrate data

waitbar(.60, h, 'Performing integration');

fields = fieldnames(data.ips); % create field names array

for i = 1:length(fields) % loop through data and integrate
[data.int.(fields{i}), data.int2.(fields{i})] = ...
                Integrate(data.t, data.tminus1, data.ips.(fields{i}));
end

clear i fields % clear used variables

%% Calculate transfer function

waitbar(.72, h, 'Calculating transfer function');

fs = 1000; % max sampling rate of exported Pi data (7P is 1024 Hz)

fields = fieldnames(data.int2); % create field names array

for i = 1:length(fields) % loop through data and calculate TF
[data.TF.(fields{i}), data.F] = ...
                 TransFunction(data.frameg, data.int2.(fields{i}), fs);
end

clear i fields fs % clear used variables

%% Display results

waitbar(.84, h, 'Plotting data');

plot(data.F, data.TF.LF_Spl, data.F, data.TF.RF_Spl); % plot transfer function
xlim([0 40]); % set x axis limits
legend('LF Splitter', 'RF Splitter'); % add legend to plot
title('Splitter Deflection Transfer Functions'); % add graph title
xlabel('Frequency (Hz)'); % add x-axis title
ylabel('Splitter Deflection Magnitude (in/g)'); % add y-axis title

close(h) % close waitbar
clear h % clear waitbar
clear data % comment out if tabular data is desired

