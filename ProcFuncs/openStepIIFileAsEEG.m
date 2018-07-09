function dataWithEEGStruct = openStepIIFileAsEEG(fileName, electrodeSetupAscFile)
%openStepIIFileAsEEG Takes a step II file and returns data to be used
%   eeglab.
%
%
%   Copyright (C) 2018 Usman Rashid
%   urashid@aut.ac.nz
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 3 of the License, or
%   (at your option) any later version.

%% Constants
PARADIGM_CUED = 'Cued';

%% Load a file
loadedData = load(fileName);

%% Get channel location file
locFile = readlocs(electrodeSetupAscFile, 'filetype', 'asc');

%% Get file tokens
subSessMovTokens = regexp(fileName, '.*sub([0-9]+)_sess([0-9]+).*', 'tokens');
subSessMovTokens = subSessMovTokens{1};

%% Prepare event vector
if(strcmp(loadedData.paradigm, PARADIGM_CUED))
    eventVector = findPrototypeEvents(loadedData.trigger);
    eventType = 'Visual Cue';
    numEvents = strcat(':', num2str(length(eventVector)));
else
    eventVector = loadedData.adjustedOnsets;
    eventType = 'EMG Onset';
    numEvents = '';
end

%% Prepare channel locs
chanLocs = locFile(strcmpIND(upper(transpose({locFile(:).labels})), loadedData.eegChannels));
urChanLocs = locFile(strcmpIND(upper(transpose({locFile(:).labels})), loadedData.eegChannels));
%% Construct title string
detectedOnsetsVector = loadedData.detectedOnsets;
adjustedOnsetsVector = loadedData.adjustedOnsets;
numDetected = length(detectedOnsetsVector);
numSelected = length(adjustedOnsetsVector);
numChanged = length(setdiff(detectedOnsetsVector, adjustedOnsetsVector));
manifestString = sprintf('%s, Sub %s, Sess %s, %s, %s%s\nDetected: %d, Selected: %d, Changed: %d',...
    loadedData.system, subSessMovTokens{1}, subSessMovTokens{2}, loadedData.task,...
    loadedData.paradigm, numEvents, numDetected, numSelected, numChanged);

%% Prepared EEG struct
EEG.setname                         = sprintf('Sub: %s, Sess: %s, Mov: %s', subSessMovTokens{1}, subSessMovTokens{2}, loadedData.task);
EEG.filename                        = fileName;
EEG.filepath                        = [];
EEG.subject                         = subSessMovTokens{1};
EEG.group                           = loadedData.system;
EEG.condition                       = loadedData.task;
EEG.session                         = subSessMovTokens{2};
EEG.comments                        = manifestString;
EEG.nbchan                          = size(loadedData.eegData, 2);
EEG.trials                          = 1;
EEG.pnts                            = size(loadedData.eegData, 1);
EEG.srate                           = loadedData.sampleRate;
EEG.xmin                            = 1 / EEG.srate;
EEG.xmax                            = EEG.pnts / EEG.srate;
EEG.times                           = loadedData.timeVect;
EEG.data                            = permute(loadedData.eegData, [2 1]);
EEG.icaact                          = [];
EEG.icawinv                         = [];
EEG.icasphere                       = [];
EEG.icaweights                      = [];
EEG.icachansind                     = [];
EEG.chanlocs                        = chanLocs;
EEG.urchanlocs                      = urChanLocs;
EEG.chaninfo                        = [];
EEG.ref                             = 'common';
EEG.event                           = eegLabEventStruct(eventVector, eventType);
EEG.urevent                         = eegLabEventStruct(eventVector, eventType);
EEG.eventdescription                = {};
EEG.epoch                           = [];
EEG.epochdescription                = {};
EEG.reject                          = [];
EEG.stats                           = [];
EEG.specdata                        = [];
EEG.specicaact                      = [];
EEG.splinefile                      = '';
EEG.icasplinefile                   = '';
EEG.dipfit                          = [];
EEG.history                         = {'openStepIIFileAsEEG'};
EEG.saved                           = 'no';
EEG.etc                             = [];
EEG.paradigm                        = loadedData.paradigm;

%% Prepare elEmatEEG struct
dataWithEEGStruct.saveDate                  = loadedData.saveDate;
dataWithEEGStruct.adjustedOnsets            = loadedData.adjustedOnsets;
dataWithEEGStruct.trigger                   = loadedData.trigger;
dataWithEEGStruct.EEG                       = EEG;
end

