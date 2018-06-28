function stepIII
%stepIII Pipeline setup for step III of study: "An EEG Experimental Study 
%   Evaluating the Performance of Texas Instruments ADS1299."
%   In this step eye blinks and other artefacts are removed using eeglab
%   runica algorithm.
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
DATA_FOLDER      = fullfile(pwd, 'Data');
INPUT_FOLDER     = fullfile(DATA_FOLDER, 'Step II');
OUTPUT_FOLDER    = fullfile(DATA_FOLDER, 'Step III');

%% Start processFolder Function
processFolder(INPUT_FOLDER, OUTPUT_FOLDER, @procStepIIFile, @quickViewStepIIIFile);
end