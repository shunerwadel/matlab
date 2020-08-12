% Objective: produce a transfer function in the frequnecy domain given an 
%            input and output signal.

% Inputs: - in        = input signal for transfer function.
%         - out       = output (repsonse) signal for transfer function
%         - fs        = sampling rate

% Outputs: - T        = transfer function data array.
%          - F        = freqency array over which TF is calculated.

% Author: S Hunerwadel (4/1/2019)

function [TF, F] = TransFunction(in, out, fs)

[T, F]=tfestimate(in, out, hann(4*fs),... % estimate transfer function
    2*fs,2*fs,fs);

TF=abs(T);
