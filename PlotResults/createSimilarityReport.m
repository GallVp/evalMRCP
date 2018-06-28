function createSimilarityReport
%createSimilarityReport Creates box plots for Cosine similarity of MRCPs.
%
%
%   Copyright (C) 2018 Usman Rashid
%   urashid@aut.ac.nz
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 3 of the License, or
%   (at your option) any later version.

% Load Power table
SignalsTable = load(fullfile(pwd, 'Data', 'Step V', 'SignalsTable.mat'));
SignalsTable = SignalsTable.SignalsTable;
%% Remove cue paradigm
tableSubsetForDors = SignalsTable(SignalsTable.paraNum == 1 & SignalsTable.mvNum == 1, :);
tableSubsetForStep = SignalsTable(SignalsTable.paraNum == 1 & SignalsTable.mvNum == 2, :);

%% Perform the scalar product analysis in Dorsiflexion
goldStandardSignals         = tableSubsetForDors(tableSubsetForDors.sysNum == 1, 'B');
prototypeSignals            = tableSubsetForDors(tableSubsetForDors.sysNum == 2, :);

prototypeSignalsA           = prototypeSignals(prototypeSignals.sessNum ~=4, 'B');

goldStandardSignals         = cell2mat(table2array(goldStandardSignals)');

% For NaN values
prototypeSignalsA           = table2array(prototypeSignalsA)';
NaNIndex                    = cellfun(@isempty, prototypeSignalsA, 'UniformOutput', 1);
prototypeSignalsA(NaNIndex) = {NaN.*ones(length(prototypeSignalsA{1}), 1)};
prototypeSignalsA           = cell2mat(prototypeSignalsA);
goldVsProtoADors            = cosineSimilarity(goldStandardSignals(:, :), prototypeSignalsA(:, :));

%% Perform the scalar product analysis in Step on/off
goldStandardSignalsStep         = tableSubsetForStep(tableSubsetForStep.sysNum == 1, 'B');
prototypeSignals                = tableSubsetForStep(tableSubsetForStep.sysNum == 2, :);

prototypeSignalsAStep           = prototypeSignals(prototypeSignals.sessNum ~=4, 'B');

goldStandardSignalsStep         = cell2mat(table2array(goldStandardSignalsStep)');

% For NaN values
prototypeSignalsAStep           = table2array(prototypeSignalsAStep)';
NaNIndex                        = cellfun(@isempty, prototypeSignalsAStep, 'UniformOutput', 1);
prototypeSignalsAStep(NaNIndex) = {NaN.*ones(length(prototypeSignalsAStep{1}), 1)};
prototypeSignalsAStep           = cell2mat(prototypeSignalsAStep);

goldVsProtoAStep                = cosineSimilarity(goldStandardSignalsStep(:, :), prototypeSignalsAStep(:, :));

%% System dors vs step
protoDosrsVsProtoStep       = cosineSimilarity(prototypeSignalsA(:, :), prototypeSignalsAStep(:, :));
goldDosrsVsGoldStep         = cosineSimilarity(goldStandardSignals(:, :), goldStandardSignalsStep(:, :));

% Create a box plot
figure
subplot(1, 2, 1)
csValues = [goldVsProtoADors' goldVsProtoAStep'];
boxplotWT(csValues, [1 2], {'Dorsiflexion', 'Step on/off'}, {'GS vs Proto'}, [1.5]);
ylabel('Cosine similarity (r)');
legend('Location', 'SouthWest')
axInfo = axis;
axis([axInfo(1) axInfo(2) -0.2 1])
set(gca, 'LineWidth', 1.5)
% Create a box plot
subplot(1, 2, 2)
csValues = [goldDosrsVsGoldStep' protoDosrsVsProtoStep'];
boxplotWT(csValues, [1 2], {'GS', 'Proto'}, {'Dorsiflexion vs Step on/off'}, [1.5]);
ylabel('Cosine similarity (r)');
legend('Location', 'SouthEast')
axInfo = axis;
axis([axInfo(1) axInfo(2) -0.2 1])
set(gca, 'LineWidth', 1.5)
end