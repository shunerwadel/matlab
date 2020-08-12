%Objective: output the single and double integrals of a discrete data set

%Inputs:    - t = time data array for corresponding data set.
%           - tminus1 = 't' with the last time entry removed.
%           - in1 = discrete data set to be integrated.

%Outputs:   - Set1_int = integrated set 1 data set
%           - Set1_int2 = double integrated set 1 data

% Author: S Hunerwadel (4/1/2019)

function [int, int2]=Integrate(t,tminus1, in) % call function

if isempty(in) == 0 % check for data in array
    int = diff(cumtrapz(t,in)); % integrate the data
    int2 = diff(cumtrapz(tminus1,int)); % integrate the data again
else
    disp('The data set 1 is empty');
end