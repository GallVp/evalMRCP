function createMeasurePlots
%createMeasurePlots Creates plots for Pre-movement noise, SNR, PN,
%   PNT.
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

% Create a box plot for PN and PNT
subplot(1,2,1)
pnValues = [mean(values_gsDors_PN, 'omitnan') mean(values_protoDorsA_PN, 'omitnan'); mean(values_gsStep_PN, 'omitnan') mean(values_protoStepA_PN, 'omitnan')];
pnErrors = [std(values_gsDors_PN, 'omitnan') std(values_protoDorsA_PN, 'omitnan'); std(values_gsStep_PN, 'omitnan') std(values_protoStepA_PN, 'omitnan')];
barwitherrnn(pnErrors, -pnValues);
axInfo = axis;
axis([axInfo(1) axInfo(2) 0 8]);
ylabel('PN amplitude (uV)');
set(gca, 'TickLength', [0 0]);
xticklabels({'Dorsiflexion', 'Step on/off'});
yticklabels(num2str([-0; -1; -2; -3; -4; -5; -6; -7; -8]))
hold on;
plot([1 2], [7 7], 'LineWidth', 2, 'Color', 'black');
text(1.36, 7.2, '***', 'FontSize', 18, 'FontWeight', 'bold');
legend off;
box off;
subplot(1,2,2)
pntValues = [mean(values_gsDors_PNT, 'omitnan') mean(values_protoDorsA_PNT, 'omitnan'); mean(values_gsStep_PNT, 'omitnan') mean(values_protoStepA_PNT, 'omitnan')];
pntErrors = [std(values_gsDors_PNT, 'omitnan') std(values_protoDorsA_PNT, 'omitnan'); std(values_gsStep_PNT, 'omitnan') std(values_protoStepA_PNT, 'omitnan')];
barwitherrnn(pntErrors, pntValues);
ylabel('PN time (ms)');
axInfo = axis;
axis([axInfo(1) axInfo(2) 0 800]);
set(gca, 'TickLength', [0 0]);
xticklabels({'Dorsiflexion', 'Step on/off'});
legend({'GS', 'Proto'}, 'Location', 'northwest', 'EdgeColor', [1 1 1]);
box off;
% Create a box plot for PMN and SNR
figure
subplot(1,2,1)
pmnValues = [mean(values_gsDors_PMN, 'omitnan') mean(values_protoDorsA_PMN, 'omitnan'); mean(values_gsStep_PMN, 'omitnan') mean(values_protoStepA_PMN, 'omitnan')];
pmnErrors = [std(values_gsDors_PMN, 'omitnan') std(values_protoDorsA_PMN, 'omitnan'); std(values_gsStep_PMN, 'omitnan') std(values_protoStepA_PMN, 'omitnan')];
barwitherrnn(pmnErrors, pmnValues);
ylabel('PMN (uVrms)');
axInfo = axis;
axis([axInfo(1) axInfo(2) 0 15]);
set(gca, 'TickLength', [0 0]);
hold on;
plot([1 2], [14 14], 'LineWidth', 2, 'Color', 'black');
text(1.36, 14.2, '***', 'FontSize', 18, 'FontWeight', 'bold');
box off;
xticklabels({'Dorsiflexion', 'Step on/off'});
subplot(1,2,2)
snrValues = [mean(values_gsDors_SNR, 'omitnan') mean(values_protoDorsA_SNR, 'omitnan'); mean(values_gsStep_SNR, 'omitnan') mean(values_protoStepA_SNR, 'omitnan')];
snrErrors = [std(values_gsDors_SNR, 'omitnan') std(values_protoDorsA_SNR, 'omitnan'); std(values_gsStep_SNR, 'omitnan') std(values_protoStepA_SNR, 'omitnan')];
barwitherrnn(snrErrors, snrValues);
axInfo = axis;
axis([axInfo(1) axInfo(2) 0 15]);
ylabel('SNR (dB)');
set(gca, 'TickLength', [0 0]);
xticklabels({'Dorsiflexion', 'Step on/off'});
hold on;
plot([1 2], [10 10], 'LineWidth', 2, 'Color', 'black');
text(1.36, 10.2, '***', 'FontSize', 18, 'FontWeight', 'bold');
box off;
legend({'GS', 'Proto'}, 'Location', 'northwest', 'EdgeColor', [1 1 1]);
end