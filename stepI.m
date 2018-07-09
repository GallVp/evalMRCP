function stepI
%stepI Pipeline setup for step I of study: "An EEG Experimental Study 
%   Evaluating the Performance of Texas Instruments ADS1299."
%   In this step data is imported from two different file tyes depending on
%   the system and saved as mat files with uniform file naming.
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
INPUT_FOLDER     = fullfile(DATA_FOLDER, 'Step Zero');
OUTPUT_FOLDER    = fullfile(DATA_FOLDER, 'Step I');
SYSTEM_PROC_MAP  = {'Gold Standard', @importGoldStandardData;...
    'Prototype', @importPrototypeData; 'NuAmps2', @importNuAmpsData};

% Ask user to select from avilable systems. Each folder in Step Zero folder
% represents a system or file type.
availableSystems    = dir(INPUT_FOLDER);
names               = {availableSystems.name};
names               = names([availableSystems.isdir]);
availableSystems    = names(3:end); % . and .. ignored
chosenSystem        = singleChoiceList('Choose system:', availableSystems);
if(isempty(chosenSystem))
    return;
end
systemDataFolder    = fullfile(INPUT_FOLDER, chosenSystem);

%% Start processFolder Function
importFunctionHandle = SYSTEM_PROC_MAP(strcmpIND(SYSTEM_PROC_MAP(:, 1), {chosenSystem}), 2);
processFolder(systemDataFolder, OUTPUT_FOLDER, importFunctionHandle{1}, @quickViewStepIFile);
end