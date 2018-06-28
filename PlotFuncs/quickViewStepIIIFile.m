function [loadedData, fileName, eegFig, manifestString] = quickViewStepIIIFile(fileName)
%quickViewStepIIIFile A quick view function for step III files.
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
EEG_TIME_BEFORE_EVENT = 3;

%% Load File
loadedData = load(fileName);

%% Construct manifest string
manifestString = loadedData.EEG.comments(end, :);

%% Plot EEG data
options = [];
manifestStringOne = strsplit(manifestString, '\n');
manifestStringOne = manifestStringOne{1};
manifestString = sprintf('EEG Epochs: %s\n Marked at threshold 125(75): %d(%d)',...
    manifestStringOne, sum(loadedData.markedAtHT), sum(loadedData.markedAtLT));
options.title = manifestString;
options.xShift = EEG_TIME_BEFORE_EVENT;
options.xLabel = 'Time (s)';
options.yLabel = 'Amplitude (uV)';
options.legendInfo = {loadedData.EEG.chanlocs(:).labels};
options.blockExecution = 0;
[eegFig] = plotChannelsAndEpochs(permute(loadedData.EEG.data, [2 1 3]), loadedData.EEG.srate, options);

%% Plot averaged ERP
figure
averagedChannels    = mean(permute(loadedData.EEG.data, [2 1 3]), 3);
averagedERP         = mean(mean(permute(loadedData.EEG.data, [2 1 3]), 3), 2);
hold
plot(averagedChannels)
plot(averagedERP, 'r-', 'LineWidth', 2)
xlabel('Sample no. (n)');
ylabel('Amplitude (uV)');
title('Averaged ERP');
axInfo = axis;
eventPoint = length(averagedERP)/2;
plot([eventPoint eventPoint],  [axInfo(3) axInfo(4)], 'LineWidth', 2, 'Color', 'black');
hold off;

[~, pnTime] = min(averagedERP);

% In milliseconds
pnTime = pnTime / loadedData.EEG.srate * 1000;

%% Plot topo
figure
pop_timtopo(loadedData.EEG, [-3000 2990], [-2000 -500 pnTime-3000]);

%% Plot spectopo
figure
pop_spectopo(loadedData.EEG, 1, [-3000 2990], 'EEG', 'freq', [2 5 10]);
end