function processedData = editStepIIFile(fileName)
%ediStepIIFile Takes a step II file and edits it using emgEventsManageTool
%   Included variables:
%   Same as input file plus:
%
%
%   Copyright (C) 2018 Usman Rashid
%   urashid@aut.ac.nz
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 3 of the License, or
%   (at your option) any later version.

SYSTEM_PROTOTYPE = 'Prototype';

%% Load Data
loadedData= load(fileName);

%% Create EMG struct
inEMG.channelData = loadedData.processedEmgData;
inEMG.fs = loadedData.sampleRate;
inEMG.channelNames = {'EMG2 - EMG1'};
inEMG.events.onSets = loadedData.adjustedOnsets;
inEMG.events.offSets = loadedData.adjustedOffsets;

%% Edit events using eventsManageTool
[outEMG] = emgEventsManageTool(inEMG);

%% Save EMAT files
processedData = loadedData;
processedData.saveDate = date;
processedData.adjustedOnsets = outEMG.events.onSets;
processedData.adjustedOffsets = outEMG.events.offSets;
end