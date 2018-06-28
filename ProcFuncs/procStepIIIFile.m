function processedData = procStepIIIFile(fileName)
%procStepIIIFile Takes a step III file and create latent variables by
%   applying following operations:
%
%   1. Remove epochs marked using high threshold.
%   2. Computes P<PWR_d, PWR_t, PWR_a, PWR_b> from all channels.
%   3. Computes B, L<PN, PNT, BLA, SNR, PMN> from CZ* of <FC3, FCZ, FC4,
%       C3, CZ, C4, CP3, CPZ, CP4>.
%
%   This pipeline results in a new file with following variables:
%   P: Induced and evoked power in the four eeg bands.
%   B: Band passed~[0.05 5] Hz grand average MRCP.
%   L: Latent variables as listed above.
%   fs: Sampling rate.
%   Xce: Band passed~[0.05 40] Hz data of selected channels and epochs.
%   measureNames, measureUnits, bandNames, and bandUnits.
%   system, task, paradigm, and saveDate.
%   numEvents: Number of events used for epoching. Including those rejected
%       by EEGLAB.
%   interEventDelay: Time delay between successive epoching events. For
%       cued paradigm, it is computed from the cue. It is saved as number
%       of samples.
%   numInterpolatedChans: Number of EEG channels which interpolated.
%   numRejectedEpochs: Epochs rejected by visual inspection.
%   numRejectedComponents: Number of ica components rejected.
%   numMarkedAtHT: Number of epochs rejected at 125 uVpp.
%   numMarkedAtLT: Number of epochs rejected at 75 uVpp.
%   eegChannels: Names of eeg channels retained.
%
%
%   Copyright (C) 2018 Usman Rashid
%   urashid@aut.ac.nz
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 3 of the License, or
%   (at your option) any later version.

% Parameters
EXCLUDE_HT_EPOCHS = 1;
TIME_BEFORE_EVENT = 3;
NOISE_SEGMENT     = [-3 -2];

%% Load data
loadedData = load(fileName);
if(isempty(loadedData))
    disp('Quitting the pipeline...');
    return;
end

%% Epoch selector using threshold status
if(EXCLUDE_HT_EPOCHS ~= 0)
    epochSelector = ~loadedData.markedAtHT;
else
    epochSelector = ones(size(loadedData.EEG.data, 3));
    epochSelector = epochSelector == 1;
end

%% Get data from EEG struct
allChannelData = double(permute(loadedData.EEG.data(:, :, epochSelector), [2 1 3]));
fs             = loadedData.EEG.srate;

%% Compute P, where P stands for induced and evoked power.
[P, ~]      = computeEEGPower(allChannelData, fs);
P           = 10.*log10(P);
bandNames   = {'PWR_d', 'PWR_t', 'PWR_a', 'PWR_b'};
bandUnits   = {'dB'   , 'dB'   , 'dB'   , 'dB'};

%% Compute Pre-movement noise
noiseIndices    = (NOISE_SEGMENT + TIME_BEFORE_EVENT) .* fs;
noiseIndices    = noiseIndices(1) + 1 : noiseIndices(2);
[PMN, ~]        = computeEEGNoise(allChannelData, noiseIndices);
%% Channel selector
loadedChannelNames = {loadedData.EEG.chanlocs(:).labels};

eegChannelsNums = strcmpIND(loadedChannelNames, {'FC3', 'FCZ', 'FC4', 'C3', 'CZ', 'C4', 'CP3',...
    'CPZ', 'CP4'}, 0); % Thus, small laplacian is used. See McFarland et. al., 1997
eegChannels = loadedChannelNames(eegChannelsNums);
centerChannelLoc = strcmpIND(eegChannels, {'CZ'}, 0);

%% Create X (X stands for grand average data).
Xce     = allChannelData(:, eegChannelsNums, :);
if(isempty(Xce))
    measureNames = {'PN'; 'PNT'; 'BLA'   ; 'SNR'; 'PMN'};
    measureUnits = {'uV'; 'ms' ; 'uVrms' ; 'dB' ; 'uVrms'};
    B = [];
    L = [];
else
    Xe = zeros(size(Xce, 1), 1, size(Xce, 3));
    for i=1:size(Xce, 3)
        Xe(:, :, i) = laplacianFilter(Xce(:, :, i), centerChannelLoc);
    end
    %% Create L where L stands for latent variables. And, B which stands for band passed signal ~ [0.05 5] Hz.
    [ L, measureNames, measureUnits, B] = evalMRCP(Xe, fs, TIME_BEFORE_EVENT);
    measureNames = cat(1, measureNames, 'PMN');
    measureUnits = cat(1, measureUnits, 'uVrms');
    L            = cat(1, L, PMN);
end

%% Assign variables
processedData.saveDate              = date;
processedData.eegChannels           = eegChannels;
processedData.system                = loadedData.EEG.group;
processedData.task                  = loadedData.EEG.condition;
processedData.paradigm              = loadedData.EEG.paradigm;
processedData.fs                    = fs;
processedData.L                     = L;
processedData.B                     = B;
processedData.P                     = P;
processedData.Xce                   = Xce;
processedData.measureNames          = measureNames;
processedData.measureUnits          = measureUnits;
processedData.bandNames             = bandNames;
processedData.bandUnits             = bandUnits;
processedData.numEvents             = loadedData.numEvents;
processedData.interEventDelay       = loadedData.interEventDelay;
processedData.numRejectedEpochs     = loadedData.numRejectedEpochs;
processedData.numRejectedComponents = loadedData.numRejectedComponents;
processedData.numMarkedAtHT         = sum(loadedData.markedAtHT);
processedData.numMarkedAtLT         = sum(loadedData.markedAtLT);
processedData.numInterpolatedChans  = length(loadedData.markedEegChannels);
end