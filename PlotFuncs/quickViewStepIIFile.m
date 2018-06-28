function [loadedData, fileName, eegFig, emgFig, manifestString] = quickViewStepIIFile(fileName)
%quickViewStepIIFile A quick view function for step II Files. Inspired by
%   Mac's quick view functionality.
%   Detrending applied.
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
PARADIGM_CUED = 'Cued';

%% Get the tokens
subSessMovTokens = regexp(fileName, '.*sub([0-9]+)_sess([0-9]+)_mov([0-9]+)', 'tokens');
subSessMovTokens = subSessMovTokens{1};

%% Load the file
loadedData = load(fileName);

%% Find trigger in files labeled 'Cued'
if(strcmp(loadedData.paradigm, PARADIGM_CUED))
    eventVector = findPrototypeEvents(loadedData.trigger);
    numEvents = strcat(':', num2str(length(eventVector)));
else
    eventVector = [];
    numEvents = '';
end

%% Load emg onset events
detectedOnsetsVector = loadedData.detectedOnsets;
adjustedOnsetsVector = loadedData.adjustedOnsets;
numDetected = length(detectedOnsetsVector);
numSelected = length(adjustedOnsetsVector);
numChanged = length(setdiff(detectedOnsetsVector, adjustedOnsetsVector));

%% Construct title string
manifestString = sprintf('%s, Sub %s, Sess %s, %s, %s%s\nDetected: %d, Selected: %d, Changed: %d',...
    loadedData.system, subSessMovTokens{1}, subSessMovTokens{2}, loadedData.task,...
    loadedData.paradigm, numEvents, numDetected, numSelected, numChanged);

% Plot processedEmgData
options.yLabel = 'Amplitude (uV)';
options.eventVector = eventVector;
options.onsetsVector = detectedOnsetsVector;
options.onsetsVector2 = adjustedOnsetsVector;

options.legendInfo = {'Processed EMG'};
options.title = sprintf('EMG: %s', manifestString);
emgFig = plotChannelData(loadedData.processedEmgData, loadedData.sampleRate, options);

% Plot eegData
options.legendInfo = loadedData.eegChannels;
options.title = sprintf('EEG: %s',manifestString);
eegFig = plotChannelData(loadedData.eegData, loadedData.sampleRate, options);
end