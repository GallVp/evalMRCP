function [loadedData, fileName, eegFig, manifestString] = quickViewStepIVFile(fileName)
%quickViewStepIVFile A quick view function for step IV files.
%
%
%   Copyright (C) 2018 Usman Rashid
%   urashid@aut.ac.nz
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 3 of the License, or
%   (at your option) any later version.

%% Some Useful constants
EEG_TIME_BEFORE_EVENT   = 3;
BASELINE_WINDOW         = [-3 -2];

%% Load the file
loadedData = load(fileName);

%% Construct manifest string
% Get the tokens
subSessMovTokens = regexp(fileName, '.*sub([0-9]+)_sess([0-9]+).*', 'tokens');
subSessMovTokens = subSessMovTokens{1};

% Construct title string
manifestString = sprintf('%s, Sub %s, Sess %s, %s, %s%s',...
    loadedData.system, subSessMovTokens{1}, subSessMovTokens{2}, loadedData.task, loadedData.paradigm);

%% Plot MRCP and average MRCP
eegFig = figure;
plot((1:length(loadedData.B)) ./ loadedData.fs - EEG_TIME_BEFORE_EVENT, loadedData.B, 'LineWidth', 2);
hold on;
plot(BASELINE_WINDOW, [loadedData.L(3) loadedData.L(3)], 'r--', 'LineWidth', 2);
plot(loadedData.L(2) / 1000, loadedData.L(1), 'ko', 'MarkerSize', 10);
legend({'Grand CZ^*', 'Baseline', 'PN'}, 'Location', 'southwest');
grid on;
axInfo = axis;
yPos = (axInfo(4) + axInfo(1)) / 2;
text(-2, yPos, sprintf('SNR: %.2f dB\nPMN: %.2f\n------------------\nP_d: %.2f dB\nP_t: %.2f dB\nP_a: %.2f dB\nP_b: %.2f dB',...
    loadedData.L(4), loadedData.L(5), loadedData.P(1), loadedData.P(2), loadedData.P(3), loadedData.P(4)),...
    'FontSize', 10, 'FontWeight', 'bold');
xlabel('Time (s)');
ylabel('Amplitude (uV)')
title(manifestString)
drawnow;% Clear draw
end