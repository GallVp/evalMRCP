function createPowerPlots
%createPowerPlots Creates a plot for ratio of power in Step on/off and
%   Dorsiflexion for the four frequency bands.
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

% Plot power across bands in dors
errorData = [std(values_gsDors_d, 'omitnan') std(values_protoDorsA_d, 'omitnan');...
    std(values_gsDors_t, 'omitnan') std(values_protoDorsA_t, 'omitnan');...
    std(values_gsDors_a, 'omitnan') std(values_protoDorsA_a, 'omitnan');...
    std(values_gsDors_b, 'omitnan') std(values_protoDorsA_b, 'omitnan')];
statData = [mean(values_gsDors_d, 'omitnan') mean(values_protoDorsA_d, 'omitnan');...
    mean(values_gsDors_t, 'omitnan') mean(values_protoDorsA_t, 'omitnan');...
    mean(values_gsDors_a, 'omitnan') mean(values_protoDorsA_a, 'omitnan');...
    mean(values_gsDors_b, 'omitnan') mean(values_protoDorsA_b, 'omitnan')];
subplot(2,2, 1)
barwitherrnn(errorData, statData);
xticklabels(gca, {'Delta', 'Theta', 'Alpha', 'Beta'});
set(gca,'TickLength',[0 0])
box off;
axInfo = axis;
axis([axInfo(1) axInfo(2) 0 30])
ylabel('Power (dB)')
hold on;
plot([1 4], [25 25], 'LineWidth', 2, 'Color', 'black');
text(2, 25.5, '***', 'FontSize', 18, 'FontWeight', 'bold');
%yticks(gca, [0 0.5 1 1.5 2 2.5 3 3.5 4])
title('Dorsiflexion')

% Plot power across bands in step
errorData = [std(values_gsStep_d, 'omitnan') std(values_protoStepA_d, 'omitnan');...
    std(values_gsStep_t, 'omitnan') std(values_protoStepA_t, 'omitnan');...
    std(values_gsStep_a, 'omitnan') std(values_protoStepA_a, 'omitnan');...
    std(values_gsStep_b, 'omitnan') std(values_protoStepA_b, 'omitnan')];
statData = [mean(values_gsStep_d, 'omitnan') mean(values_protoStepA_d, 'omitnan');...
    mean(values_gsStep_t, 'omitnan') mean(values_protoStepA_t, 'omitnan');...
    mean(values_gsStep_a, 'omitnan') mean(values_protoStepA_a, 'omitnan');...
    mean(values_gsStep_b, 'omitnan') mean(values_protoStepA_b, 'omitnan')];
subplot(2,2, 2)
barwitherrnn(errorData, statData);
xticklabels(gca, {'Delta', 'Theta', 'Alpha', 'Beta'});
set(gca,'TickLength',[0 0])
box off;
axInfo = axis;
axis([axInfo(1) axInfo(2) 0 30])
ylabel('Power (dB)')
hold on;
plot([1 4], [25 25], 'LineWidth', 2, 'Color', 'black');
text(2, 25.5, '***', 'FontSize', 18, 'FontWeight', 'bold');
%yticks(gca, [0 0.5 1 1.5 2 2.5 3 3.5 4])
title('Step on/off')
%% Plot S/D ratio
errorData = [std(deltaBand_gs, 'omitnan') std(deltaBand_proto_A, 'omitnan');...
    std(thetaBand_gs, 'omitnan') std(thetaBand_proto_A, 'omitnan');...
    std(alphaBand_gs, 'omitnan') std(alphaBand_proto_A, 'omitnan');...
    std(betaBand_gs, 'omitnan') std(betaBand_proto_A, 'omitnan')];
statData = [mean(deltaBand_gs, 'omitnan') mean(deltaBand_proto_A, 'omitnan');...
    mean(thetaBand_gs, 'omitnan') mean(thetaBand_proto_A, 'omitnan');...
    mean(alphaBand_gs, 'omitnan') mean(alphaBand_proto_A, 'omitnan');...
    mean(betaBand_gs, 'omitnan') mean(betaBand_proto_A, 'omitnan')];
subplot(2,2, [3,4])
barwitherrnn(errorData, statData);

set(gca,'TickLength',[0 0])
box off;
axInfo = axis;
axis([axInfo(1) axInfo(2) 0 2])
ylabel('Ratio S/D')
yticks(gca, [0 1 1.2 1.4 1.6 1.8 2])
set(gca, 'YGrid', 'on');
xticklabels(gca, {'Delta', 'Theta', 'Alpha', 'Beta'});
legend({'GS', 'Proto'}, 'Box', 'off', 'Location', 'northwest');
end