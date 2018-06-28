function processedData = procStepIIFile(fileName)
%procStepIIFile Takes a step II file and applies following operations:
%   1. Marks EEG channels by visual inspection and interpolates them using
%      eeglab pop_interp function.
%   2. Removes 'impulse' aretefact from prototype EEG files.
%   3. Down samples data to 125 Hz.
%   4. Epochs data with [-3 3] window around the event.
%   5. Removes epochs by visual inspection.
%   6. Removes eye artefacts using eeglab runica, pop_selectcomps
%   7. Marks epochs at 125 uVpp and 75uVpp.
%
%
%   This pipeline results in a new file with following variables:
%   EEG: EEG structure from eeglab.
%   numEvents: Number of events used for epoching. Including those rejected
%       by EEGLAB.
%   interEventDelay: Time delay between successive epoching events. For
%       cued paradigm, it is computed from the cue. It is saved as number
%       of samples.
%   markedEegChannels: Names of EEG channels which were marked for
%       interpolation.
%   numRejectedEpochs: Epochs rejected by visual inspection.
%   numRejectedComponents: Number of ica components rejected.
%   markedAtHT: Epochs rejected at 125 uVpp.
%   markedAtLT: Epochs rejected at 75 uVpp.
%
%
%   Copyright (C) 2018 Usman Rashid
%   urashid@aut.ac.nz
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 3 of the License, or
%   (at your option) any later version.

% Set defaults
processedData = [];

%% Setup eeglab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
eeglabFig = gcf;
delete(eeglabFig);

%% Info CONSTANTS
SYSTEM_PROTOTYPE            = 'Prototype';
SHOW_DIAGNOSTIC_PLOTS       = 1;
DIAGNOSTIC_PLOTS_TITLE      = 'Diagnostic plot';
PARADIGM_CUED               = 'Cued';
SETUP_ASC_FILE              = fullfile(pwd, 'Data', 'Setup', 'NuAmps40.asc');

%% Load EMAT file and plot using eeglabEmatFile
dataWithEEGStruct = openStepIIFileAsEEG(fileName, SETUP_ASC_FILE);

%% PROCESSING CONSTANTS
EEG_EPOCH_LIMS                  = [-3 3];
LOW_PASS_FILTER_CUTOFF          = 40;
EEG_NOTCH_WINDOW                = [49 51];
IMPULSE_CUTT_OFF                = 1000;
HIGH_THRESHOLD                  = 125;
LOW_THRESHOLD                   = 75;
SELECTED_CHANNELS_NAMES         = {'F3', 'F4', 'FC3', 'FCZ', 'FC4', 'C3', 'CZ', 'C4', 'CP3',...
    'CPZ', 'CP4', 'P3', 'P4', 'Fp1'};

%% Assign the EEG variable for eeglab and select channels as per SELECTED_CHANNELS_NAMES.
EEG                 = dataWithEEGStruct.EEG;
selectedChanNums    = strcmpIND({EEG.chanlocs(:).labels}, SELECTED_CHANNELS_NAMES, 0);
EEG.chanlocs        = EEG.chanlocs(selectedChanNums);
EEG.nbchan          = length(selectedChanNums);
EEG.data            = EEG.data(selectedChanNums, :, :);

%% Inter event delay
%% Prepare event vector. EEG.event struct cannot be used as it has constant values after epoching
if(strcmp(EEG.paradigm, PARADIGM_CUED))
    eventVector     = findPrototypeEvents(dataWithEEGStruct.trigger);
    interEventDelay = diff(eventVector);
else
    eventVector     = [];
    interEventDelay = diff(dataWithEEGStruct.adjustedOnsets);
end

interEventDelay = interEventDelay ./ EEG.srate;

%% Remove DC from data.
detrendedEEGData = removeDC(transpose(EEG.data), EEG.srate);

%% Remove 'Impulse' Artefacts from prototype data and invert polarity. Do two passes for missed impulses.
if(strcmp(EEG.group, SYSTEM_PROTOTYPE))
    [impulseRemovedEEGData, ~] = removeImpulseArtefact(detrendedEEGData, SHOW_DIAGNOSTIC_PLOTS, DIAGNOSTIC_PLOTS_TITLE, IMPULSE_CUTT_OFF);
    [impulseRemovedEEGData, ~] = removeImpulseArtefact(impulseRemovedEEGData, SHOW_DIAGNOSTIC_PLOTS, DIAGNOSTIC_PLOTS_TITLE, IMPULSE_CUTT_OFF);
    impulseRemovedEEGData = -1 .* impulseRemovedEEGData;
else
    impulseRemovedEEGData = detrendedEEGData;
end

%% Low pass eeg data
processedEegData = lowPassStream(impulseRemovedEEGData,...
    EEG.srate, LOW_PASS_FILTER_CUTOFF);
processedEegData = notchStream(processedEegData, EEG.srate, EEG_NOTCH_WINDOW);

%% Ask user to mark EEG Channels for interpolation
options.legendInfo      = {EEG.chanlocs(:).labels};
options.eventVector     = eventVector;
options.onsetsVector2   = dataWithEEGStruct.adjustedOnsets;
options.title = 'Mark Channels for interpolation';
eegFig = plotChannelData(processedEegData, EEG.srate, options);
prompt = {'Enter numbers of EEG channels to exclude:'};
name = 'EEG Channels';
defaultans = {'[]'};
options.WindowStyle = 'normal';
answerString = inputdlg(prompt, name, [1 60], defaultans, options);
delete(eegFig);
if(isempty(answerString))
    disp('Quitting the pipeline...');
    return;
else
    markedEegChannelNums    = str2num(answerString{1});
    markedEegChannels       = {EEG.chanlocs(markedEegChannelNums).labels};
end

%% Interpolate marked channels
EEG.data            = transpose(processedEegData);
if(~isempty(markedEegChannelNums))
    EEG             = pop_interp(EEG, markedEegChannelNums, 'spherical');
end

%% Downsample Data to 125 Hz
EEG = pop_resample(EEG, 125);
%% Epoch data
EEG = pop_epoch(EEG, {}, EEG_EPOCH_LIMS);
%% Remove epochs using visual inspection
options.legendInfo = {EEG.chanlocs(:).labels};
options.title = 'Exclude epochs by visual inspection';
[~, excludedEpochs] = plotEpochs(permute(EEG.data, [2 1 3]), EEG.srate, options);
if(~sum(excludedEpochs) == 0)
    EEG = pop_rejepoch(EEG, excludedEpochs, 1);
end
%% Perform ica
EEG = pop_runica(EEG, 'icatype', 'runica', 'chanind', 1:EEG.nbchan);
assignin('base', 'EEG', EEG);

%% Reject components pipeline and plot data
pop_selectcomps(EEG);
uiwait(gcf);
EEG = evalin('base', 'EEG');
numRejectedComponents = length(find(EEG.reject.gcompreject));
EEG = evalin('base', 'pop_subcomp(EEG)');

%% Reject epochs at 75uV and 125uV
markedAtHT = thresholdEpochs(permute(EEG.data, [2 1 3]), HIGH_THRESHOLD);
markedAtLT = thresholdEpochs(permute(EEG.data, [2 1 3]), LOW_THRESHOLD);

%% Save PMAT files
processedData.saveDate              = date;
processedData.markedEegChannels     = markedEegChannels;
processedData.interEventDelay       = interEventDelay;
processedData.EEG                   = EEG;
processedData.numRejectedComponents = numRejectedComponents;
processedData.numRejectedEpochs     = sum(excludedEpochs);
processedData.numEvents             = length(interEventDelay) + 1;
processedData.markedAtHT            = markedAtHT;
processedData.markedAtLT            = markedAtLT;
end