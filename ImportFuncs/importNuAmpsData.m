function [importedData] = importNuAmpsData(fileName)
%importNuAmpsData Takes an Acquire .cnt file and returns a structure.
%
%   Included Variables:
%   saveDate: The date the file was saved.
%   eegData: EEG channels as columns and values as rows.
%   emgData: EMG channels as columns and values as rows.
%   sampleRate: The sampling rate of the data.
%   eegChannels: A cell array of eeg channel names corresponding to column number.
%   emgChannels: A cell array of emg channel names corresponding to column number.
%   timeVect: A column vector containing a time series for the recording, starting at 1/sampleRate.
%   trigger: A column vector of logical values. 1 for trigger.
%   system: The name of the system used for recording. One of {'Gold Standard', 'Prototype'}.
%   task: The name of the task performed during the recording. One of {'Dorsiflexion', 'Step on/off'}.
%   paradigm: The name of the paradigm for recording. One of {'Self-paced', 'Cued'}.
%
%   Requisites:
%   Before running this script, please load eeglab using 'eeglab' function.
%
%   Variable Naming:
%   gs stands for Gold Standard.
%
%
%   Copyright (C) 2018 Usman Rashid
%   urashid@aut.ac.nz
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 3 of the License, or
%   (at your option) any later version.

%% Predefined variables
 % As per studysetup.ast file used with the Acquire Software (Neuroscan Labs). 
CHANNEL_LABELS          = {'EMG1', 'EMG2', 'FP1', 'FP2', 'VEOU', 'VEOL', 'F7', 'F3', 'FZ', 'F4', 'F8',...
    'FT7', 'FC3', 'FCZ', 'FC4', 'FT8', 'T3', 'C3', 'CZ', 'C4', 'T4', 'TP7', 'CP3',...
    'CPZ', 'CP4', 'TP8', 'A1', 'T5', 'P3', 'PZ', 'P4', 'T6', 'A2', 'O1', 'OZ',...
    'O2', 'FT9', 'FT10', 'PO1', 'PO2'};
EMG_CHANNEL_LABELS      = {};
EEG_CHANNEL_LABELS      = { 'FP1',...
    'F3', 'FZ', 'F4',...
    'FC3', 'FCZ', 'FC4',...
    'C3', 'CZ', 'C4',...
    'CP3', 'CPZ', 'CP4',...
    'P3', 'PZ', 'P4'};
TASK_NAMES              = {'Dorsiflexion', 'Step on/off', 'Sit/stand', 'Step forward', 'Step backward', 'Step up'};
PARADIGM_NAMES          = {'Self-paced', 'Cued'};

%% Asign default values
importedData = [];
                        
% Load the cnt file using pop_loadcnt
cntFile = pop_loadcnt(fileName);
importedData.sampleRate = cntFile.srate;

%% Prepare storage variables
importedData.saveDate = date;

% EEG data
eegChannelLocs = strcmpMSC(CHANNEL_LABELS, EEG_CHANNEL_LABELS);
importedData.eegData = double(cntFile.data(eegChannelLocs, :))';
timeVect = (1:1:length(importedData.eegData)) ./ importedData.sampleRate;
importedData.timeVect = timeVect';

% EMG data
emgChannelLocs = [];
importedData.emgData = [];

% Other variables
importedData.eegChannels = EEG_CHANNEL_LABELS';
importedData.emgChannels = EMG_CHANNEL_LABELS';
importedData.system = 'NuAmps2';

% Trigger
cntEvents            = cntFile.event;
cntEvents            = cntEvents(~strcmp({cntEvents.type}, 'boundary'));
importedData.trigger = zeros(size(timeVect))';
importedData.trigger([cntEvents.latency]) = 1;

subSessMovTokens = regexp(fileName, '.*sub([0-9]+)_sess([0-9]+)_mov([0-9]+).cnt', 'tokens');
if(~isempty(subSessMovTokens))
    subSessMovTokens = subSessMovTokens{1};
    addInfo = sprintf('sub:%s sess:%s mov:%s', subSessMovTokens{1}, subSessMovTokens{2}, subSessMovTokens{3});
else
    [~, addInfo, ~] = fileparts(fileName);
end

% Ask user for task.
taskName = singleChoiceList(sprintf('Choose task for %s', addInfo), TASK_NAMES);
if(isempty(taskName))
    importedData = [];
    return;
else
    importedData.task = taskName;
end
% Ask user for paradigm.
paradigmName = singleChoiceList(sprintf('Choose paradigm for %s', addInfo), PARADIGM_NAMES);
if(isempty(paradigmName))
    importedData = [];
    return;
else
    importedData.paradigm = paradigmName;
end
end

