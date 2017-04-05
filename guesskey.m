% Garrett Scholtes
% Process CPU timing information to extract key bits from 
% cryptographic numbers
% 
% Guess the key in this file
% Do variance analysis, make histograms, etc, in "makehistograms.m"

clear all;
close all;

spytimes;

% Difference in times, per sample
d_spytimes = diff([zeros(size(spy_times,1),1) spy_times], 1, 2);

% Average difference across all samples
mean_d_spytimes = mean(d_spytimes);

% It is expected that mean_d_spytimes is bimodal.
% Instead of using iterTime to find the expected times 
% for 0 bits and 1 bits, we can simply extract approximate
% modes from the spyTime data.

avg_spytime = mean(mean_d_spytimes);

% This variable will contain all the keybits (in LSB to MSB order)
keybits = mean_d_spytimes > avg_spytime;

% And let's print out the answer
fprintf('Key bits (guess):\n');
fprintf('%d', fliplr(keybits));
fprintf('\n');