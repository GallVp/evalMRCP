function powerEffects
%powerEffects Computes cohen's d effect sizes for power.
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
PowerTable = load(fullfile(pwd, 'Data', 'Step V', 'PowerTable.mat'));
PowerTable = PowerTable.PowerTable;
%% Remove cue paradigm
tableSubset = PowerTable(PowerTable.paraNum == 1, :);

%% Gather data for Delta band
[values_gsDors_d, values_gsStep_d, values_protoDorsA_d, values_protoStepA_d, ~, ~] = getDataGroups(tableSubset,...
    'PWR_d');

%% Gather data for Theta band
[values_gsDors_t, values_gsStep_t, values_protoDorsA_t, values_protoStepA_t, ~, ~] = getDataGroups(tableSubset,...
    'PWR_t');

%% Gather data for Alpha band
[values_gsDors_a, values_gsStep_a, values_protoDorsA_a, values_protoStepA_a, ~, ~] = getDataGroups(tableSubset,...
    'PWR_a');

%% Gather data for Beta band
[values_gsDors_b, values_gsStep_b, values_protoDorsA_b, values_protoStepA_b, ~, ~] = getDataGroups(tableSubset,...
    'PWR_b');

deltaBand_gs = values_gsStep_d ./ values_gsDors_d;
thetaBand_gs = values_gsStep_t ./ values_gsDors_t;
alphaBand_gs = values_gsStep_a ./ values_gsDors_a;
betaBand_gs =  values_gsStep_b ./ values_gsDors_b;


deltaBand_proto_A =  values_protoStepA_d ./ values_protoDorsA_d;
thetaBand_proto_A =  values_protoStepA_t ./ values_protoDorsA_t;
alphaBand_proto_A =  values_protoStepA_a ./ values_protoDorsA_a;
betaBand_proto_A =  values_protoStepA_b ./ values_protoDorsA_b;


% Effect Size for Dorsiflexion
fprintf('Effect Size for Dorsiflexion\n');
computeCohensD(values_gsDors_d, values_protoDorsA_d);
computeCohensD(values_gsDors_t, values_protoDorsA_t);
computeCohensD(values_gsDors_a, values_protoDorsA_a);
computeCohensD(values_gsDors_b, values_protoDorsA_b);
fprintf('----------------------------\n');

% Effect Size for step on/off
fprintf('Effect Size for step on/off\n');
computeCohensD(values_gsStep_d, values_protoStepA_d);
computeCohensD(values_gsStep_t, values_protoStepA_t);
computeCohensD(values_gsStep_a, values_protoStepA_a);
computeCohensD(values_gsStep_b, values_protoStepA_b);
fprintf('----------------------------\n');

% Effect Size for power ratio
fprintf('Effect Size for power ratio\n');
computeCohensD(deltaBand_gs, deltaBand_proto_A);
computeCohensD(thetaBand_gs, thetaBand_proto_A);
computeCohensD(alphaBand_gs, alphaBand_proto_A);
computeCohensD(betaBand_gs, betaBand_proto_A);
fprintf('----------------------------\n');
end