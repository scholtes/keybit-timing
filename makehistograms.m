% Garrett Scholtes
% Process CPU timing information to extract key bits from 
% cryptographic numbers
%
% This file makes histogram plots for analysis.
% Run "guesskey.m" if you just want the key
% 
% None of this is strictly necessary but it will give me confidence 
% that the guess is correct, and will let us see how many samples 
% are actually necessary to produce an accurate guess

clear all;
close all;

spytimes;

% Difference in times, per sample
d_spytimes = diff([zeros(size(spy_times,1),1) spy_times], 1, 2);

% Average difference across all samples
mean_d_spytimes = mean(d_spytimes);

% Cumulative change in bits plot
% We will create a function that compares the number of bits that changed
% in successive guesses versus the number of samples used to make a guess.
% We will integrate to give an cumulative plot.  When it begins to 
% flatline, we have enough samples.
cmds = cumsum(d_spytimes, 1)./cumsum(ones(size(spy_times)));
cum_avg_spytime = repmat(mean(cmds, 2), 1, size(spy_times,2));
keybits = cmds > cum_avg_spytime;
bit_diffs = sum(abs(diff(keybits, 2)), 2);
cum_bit_diffs = cumsum(bit_diffs);

% Number of bits changed as we add samples graph
figure;
plot(1:100, bit_diffs(1:100), 'b*');
title('Number of bits that change in guess vs number of samples');
xlabel('Samples used');
ylabel('Bits changed from previous guess (with n-1 samples)');

% Cumulative version
figure;
plot(1:100, cum_bit_diffs(1:100), 'r-');
title('Cumulative number of bit changes as # of samples changes');
xlabel('Samples used');
ylabel('Cumulative # bits changed');

stds_zero = ones(size(spy_times,1),1);
stds_ones = ones(size(spy_times,1),1);
stds_ratio_zero = ones(size(spy_times,1),1);
stds_ratio_ones = ones(size(spy_times,1),1);
for k = 1:size(spy_times,1)
    row = cmds(k,:);
    avg_spytime = cum_avg_spytime(k,1);
    row_zero = row(row < avg_spytime);
    row_ones = row(row > avg_spytime);
    stds_zero(k) = std(row_zero);
    stds_ones(k) = std(row_ones);
    stds_ratio_zero(k) = (avg_spytime - mean(row_zero)) / stds_zero(k);
    stds_ratio_ones(k) = (mean(row_ones) - avg_spytime) / stds_ones(k);
end

% Standard deviations plot
figure;
hold on;
plot(1:100, stds_zero(1:100), 'b-');
plot(1:100, stds_ones(1:100), 'r-');
title('Standard deviation vs number of samples');
xlabel('Number of samples used');
ylabel('Standard deviation (nanoseconds)');
legend('Zero bits', 'One bits');

% Standard deviation ratio/error plot
figure;
hold on;
plot(1:100, stds_ratio_zero(1:100), 'b-');
plot(1:100, stds_ratio_ones(1:100), 'r-');
title('Number of standard deviations for an error to occur');
xlabel('Number of samples used');
ylabel('Number of standard deviations (dimensionless)');
legend('Zero bits', 'One bits');


% Histogram of d/dt spytimes, across all samples and bits
figure;
hist(reshape(d_spytimes, 1, []), 50);
title('Histogram across all samples');
xlabel('Time difference to previous bit');
ylabel('Count (number of sample bits in that time bin)');

% Histogram of d/dt spytimes, averaged across samples, across all bits
figure;
hist(mean_d_spytimes, 20);
title('Histogram of average spy time differences, with 10000 samples');
xlabel('Time difference to previous bit (nanoseconds)');
ylabel('Count (number of bits in that time bin)');

figure;
hist(mean(d_spytimes(1:1000, :)), 20);
title('Histogram of average spy time differences, with 1000 samples');
xlabel('Time difference to previous bit (nanoseconds)');
ylabel('Count (number of bits in that time bin)');

figure;
hist(mean(d_spytimes(1:100, :)), 20);
title('Histogram of average spy time differences, with 1000 samples');
xlabel('Time difference to previous bit (nanoseconds)');
ylabel('Count (number of bits in that time bin)');
