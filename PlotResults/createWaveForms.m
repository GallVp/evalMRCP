function createWaveForms
%createWaveForms Exports wavefors to be plotted with confidence intervals
%   in R and plots topographical plots.
%
%
%   Copyright (C) 2018 Usman Rashid
%   urashid@aut.ac.nz
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 3 of the License, or
%   (at your option) any later version.

% Provide constants
FS                  = 125;
TIME_BEFORE_EVENT   = 3;

% Load Signals table
SignalsTable = load(fullfile(pwd, 'Data', 'Step V', 'SignalsTable.mat'));
SignalsTable = SignalsTable.SignalsTable;
%% Remove cue paradigm
tableSubset = SignalsTable(SignalsTable.paraNum == 1 & SignalsTable.sessNum ~=4, :);

%% Obtain signals
gsDors         = tableSubset(tableSubset.sysNum == 1 & tableSubset.mvNum == 1, 'B');
protoDors      = tableSubset(tableSubset.sysNum == 2 & tableSubset.mvNum == 1, 'B');

gsStep         = tableSubset(tableSubset.sysNum == 1 & tableSubset.mvNum == 2, 'B');
protoStep      = tableSubset(tableSubset.sysNum == 2 & tableSubset.mvNum == 2, 'B');


gsDors         = cell2mat(table2array(gsDors)');

gsStep         = cell2mat(table2array(gsStep)');
protoStep      = cell2mat(table2array(protoStep)');

% For NaN values
protoDors            = table2array(protoDors)';
NaNIndex             = cellfun(@isempty, protoDors, 'UniformOutput', 1);
protoDors(NaNIndex)  = {NaN.*ones(length(protoDors{1}), 1)};
protoDors            = cell2mat(protoDors);

tVect                = (1:size(protoDors, 1)) ./ FS - TIME_BEFORE_EVENT;
tVect                = tVect';

%% Create table for export
grandAverageTable.partNum   = ones(length(tVect), size(gsDors, 2)) .* (1:22);
grandAverageTable.partNum   = grandAverageTable.partNum(:);
grandAverageTable.tVect     = repmat(tVect, 1, size(gsDors, 2));
grandAverageTable.tVect     = grandAverageTable.tVect(:);
grandAverageTable.gsDors    = gsDors(:);
grandAverageTable.protoDors = protoDors(:);
grandAverageTable.gsStep    = gsStep(:);
grandAverageTable.protoStep = protoStep(:);
grandAverageTable           = struct2table(grandAverageTable);

writetable(grandAverageTable, 'grandAverageTable.csv');

%% Find grand averages
gsDors      = mean(gsDors, 2, 'omitnan');
protoDors   = mean(protoDors, 2, 'omitnan');

gsStep      = mean(gsStep, 2, 'omitnan');
protoStep   = mean(protoStep, 2, 'omitnan');
subplot(2,1,1)
plot(tVect, gsDors, 'r-')
hold
plot(tVect, protoDors, 'k-')
ylabel('Amplitude (uV)');
subplot(2,1,2)
plot(tVect, gsStep, 'r-')
hold
plot(tVect, protoStep, 'k-')
xlabel('Time (s)');
ylabel('Amplitude (uV)');
end