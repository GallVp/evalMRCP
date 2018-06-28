function processedData = procStepIFile(fileName)
%procStepIFile Takes a step I file and applies following operations:
%   1. Removes impulse artefacts in the prototype files.
%   2. uses emgGo for processing of emg data.
%
%   Included variables:
%   Same as input file plus:
%   processedEmgData: Emg data used for detection of movement onsets.
%   detectedOnsets: A column vector of detected event indices from emgData.
%   adjustedOnsets: A column vector of manually adjusted event indices
%       from `detectedOnsets`.
%   detectionOptions: Detection Options used for detecting emg events.
%
%   Variable Naming:
%   gs stands for Gold Standard.
%   proto stands for prototype.
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

%% CONSTANTS
SHOW_DIAGNOSTIC_PLOTS   = 1;
FILTER_ORDER            = 2;

%% Load Data
loadedData= load(fileName);

%% Combine EMG Channels
differentialEMGChannel = loadedData.emgData(:, 2) - loadedData.emgData(:, 1);

%% Remove DC from data.
detrendedEMGData = removeDC(differentialEMGChannel, loadedData.sampleRate);

%% Remove 'Impulse' Artefacts from prototype data
if(strcmp(loadedData.system, SYSTEM_PROTOTYPE))
    [impulseRemovedEMGData, ~] = removeImpulseArtefact(detrendedEMGData, SHOW_DIAGNOSTIC_PLOTS);
else
    impulseRemovedEMGData = detrendedEMGData;
end

%% Filter EMG Data
impulseRemovedEMGData = filterStream(impulseRemovedEMGData, loadedData.sampleRate, FILTER_ORDER, loadedData.sampleRate / 2.5, 10);

%% Create EMG struct and load task based detection options
inEMG.channelData = impulseRemovedEMGData;
inEMG.fs = loadedData.sampleRate;
inEMG.channelNames = {'EMG2 - EMG1'};

options.subParams  = getTaskBasedEMGOptions(loadedData.task);

%% Find events from EMG data using emgGo
[outEMG, outDetectionOptions] = emgEventsDetectTool(inEMG, options);

%% Find onsets and offsets using final parameters.
[detectedOnsets, detectedOffsets]               = extendedDTA(inEMG.channelData, inEMG.fs, outDetectionOptions);

%% Save EMAT files
processedData = loadedData;
processedData.saveDate = date;
processedData.processedEmgData = outEMG.channelData;
processedData.detectedOnsets = detectedOnsets;
processedData.detectedOffsets = detectedOffsets;
processedData.adjustedOnsets = outEMG.events.onSets;
processedData.adjustedOffsets = outEMG.events.offSets;
processedData.detectionOptions = outDetectionOptions;
end