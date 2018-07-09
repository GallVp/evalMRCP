function [loadedData, fileName, eegFig, emgFig, titleString] = quickViewStepIFile(fileName)
%QUICKVIEWMATFILE A quick view function for MatFiles saved according
%   to MatFile descriptor and inspired by Mac's quick view functionality.
%   Detrending applied to data.
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

%% Get file tokens
subSessMovTokens = regexp(fileName, '.*sub([0-9]+)_sess([0-9]+).*', 'tokens');
subSessMovTokens = subSessMovTokens{1};

% Load the file
loadedData = load(fileName);

% Find trigger in files labeled 'Cued'
if(strcmp(loadedData.paradigm, PARADIGM_CUED))
    eventVector = findPrototypeEvents(loadedData.trigger);
    numEvents = strcat(':', num2str(length(eventVector)));
else
    eventVector = [];
    numEvents = '';
end

% Check if isReal flag is present
if(isfield(loadedData, 'isReal'))
    if(loadedData.isReal)
        type = 'Real';
    else
        type = 'Img';
    end
    % Construct title string
    titleString = sprintf('%s, Sub %s, Sess %s, %s, %s, %s%s',...
        loadedData.system, subSessMovTokens{1}, subSessMovTokens{2}, loadedData.task, loadedData.paradigm, type, numEvents);
else
    % Construct title string
    titleString = sprintf('%s, Sub %s, Sess %s, %s, %s%s',...
        loadedData.system, subSessMovTokens{1}, subSessMovTokens{2}, loadedData.task, loadedData.paradigm, numEvents);
end

% Plot eegData
options.yLabel = 'Amplitude (uV)';
options.legendInfo = loadedData.eegChannels;
options.eventVector = eventVector;
options.title = sprintf('EEG: %s',titleString);
eegFig = plotChannelData(loadedData.eegData, loadedData.sampleRate, options);

% Plot emgData
if(size(loadedData.emgData, 2) == 2)
    options.legendInfo = {'EMG'};
    options.title = sprintf('EMG: %s', titleString);
    emgFig = plotChannelData(loadedData.emgData(:, 2) - loadedData.emgData(:, 1), loadedData.sampleRate, options);
else
    options.legendInfo = loadedData.emgChannels;
    options.title = sprintf('EMG: %s', titleString);
    if(~isempty(loadedData.emgData))
        emgFig = plotChannelData(loadedData.emgData, loadedData.sampleRate, options);
    end
end
end