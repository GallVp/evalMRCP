function [ emgOptions ] = getTaskBasedEMGOptions( taskName)
%getTaskBasedEMGOptions Gives a structure of task based EMG options.
%   Possible tasks {'Dorsiflexion', 'Step-up'}.
%
%   Options sequence
%   EMG_BASELINE_LENGTH_SEC
%   EMG_EVENT_NUM_STDS
%   EMG_BASELINE_LEVEL
%   EMG_ONSET_TIME_SEC
%   EMG_OFFSET_TIME_SEC
%   EMG_EVENT_MIN_TIME_SEC
%   EMG_NON_TYPICAL_NUM_STDS
%   EMG_JOIN_MOVEMENTS_IN
%
%   Copyright (C) 2018 Usman Rashid
%   urashid@aut.ac.nz
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 3 of the License, or
%   (at your option) any later version.
if(strcmp(taskName, 'Dorsiflexion'))
    emgOptions = [0.1   2   1    0.05   0.05    0.5     2   0];
else
    emgOptions = [0.1   1   2    0.05   0.1    0.35     5   1.1];
end
end
