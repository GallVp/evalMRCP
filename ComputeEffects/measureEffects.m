function measureEffects
%measureEffects Computes effect sizes for performance measures.
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
MeasuresTable = load(fullfile(pwd, 'Data', 'Step V', 'MeasuresTable.mat'));
MeasuresTable = MeasuresTable.MeasuresTable;
%% Remove cue paradigm
tableSubset = MeasuresTable(MeasuresTable.paraNum == 1, :);

%% Gather data for PN
[values_gsDors_PN, values_gsStep_PN, values_protoDorsA_PN, values_protoStepA_PN, ~, ~] = getDataGroups(tableSubset,...
    'PN');

%% Gather data for PNT
[values_gsDors_PNT, values_gsStep_PNT, values_protoDorsA_PNT, values_protoStepA_PNT, ~, ~] = getDataGroups(tableSubset,...
    'PNT');

%% Gather data for PMN
[values_gsDors_PMN, values_gsStep_PMN, values_protoDorsA_PMN, values_protoStepA_PMN, ~, ~] = getDataGroups(tableSubset,...
    'PMN');

%% Gather data for SNR
[values_gsDors_SNR, values_gsStep_SNR, values_protoDorsA_SNR, values_protoStepA_SNR, ~, ~] = getDataGroups(tableSubset,...
    'SNR');

% Effect Size for PN
fprintf('Effect Size for PN\n');
computeCohensD(values_gsDors_PN, values_protoDorsA_PN);
computeCohensD(values_gsStep_PN, values_protoStepA_PN);
fprintf('----------------------------\n');

% Effect Size for PNT
fprintf('Effect Size for PNT\n');
computeCohensD(values_gsDors_PNT, values_protoDorsA_PNT);
computeCohensD(values_gsStep_PNT, values_protoStepA_PNT);
fprintf('----------------------------\n');

% Effect Size for PMN
fprintf('Effect Size for PMN\n');
computeCohensD(values_gsDors_PMN, values_protoDorsA_PMN);
computeCohensD(values_gsStep_PMN, values_protoStepA_PMN);
fprintf('----------------------------\n');

% Effect Size for SNR
fprintf('Effect Size for SNR\n');
computeCohensD(values_gsDors_SNR, values_protoDorsA_SNR);
computeCohensD(values_gsStep_SNR, values_protoStepA_SNR);
fprintf('----------------------------\n');
end