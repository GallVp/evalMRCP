function createSummaryPlots
%createSummaryPlots Creates a plot with subplots for stats of processing
%   steps.
%
%
%   Copyright (C) 2018 Usman Rashid
%   urashid@aut.ac.nz
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 3 of the License, or
%   (at your option) any later version.

% Load Summary table
SummaryTable = load(fullfile(pwd, 'Data', 'Step V', 'SummaryTable.mat'));
SummaryTable = SummaryTable.SummaryTable;
%% Remove cue paradigm
tableSubset = SummaryTable(SummaryTable.paraNum == 1, :);

%% Gather data for numInterpolatedChans
[values_gsDors, values_gsStep, values_protoDorsA, values_protoStepA, ~, ~] = getDataGroups(tableSubset,...
    'numInterpolatedChans');
% Create a bar plot with errors
valueErrors = round([std(values_gsDors) std(values_protoDorsA);...
    std(values_gsStep) std(values_protoStepA)], 1);
valueStat = round([mean(values_gsDors) mean(values_protoDorsA);...
    mean(values_gsStep) mean(values_protoStepA)], 1);
subplot(2,2,1)
barwitherrnn(valueErrors, valueStat);
box off;
xticklabels(gca, [])
xticks(gca, []);
axInfo = axis;
axis([axInfo(1) axInfo(2) 0 10])
yticks(gca, [0 2 4 6 8 10])
ylabel('Interpolated channels (n)')
set(gca,'TickLength',[0 0])
legend({'GS', 'Proto'}, 'Box', 'off')

%% Gather data for numRejectedComponents
[values_gsDors, values_gsStep, values_protoDorsA, values_protoStepA, ~, ~] = getDataGroups(tableSubset,...
    'numRejectedComponents');
% Create a bar plot with errors
valueErrors = round([std(values_gsDors) std(values_protoDorsA);...
    std(values_gsStep) std(values_protoStepA)], 1);
valueStat = round([mean(values_gsDors) mean(values_protoDorsA);...
    mean(values_gsStep) mean(values_protoStepA)], 1);
subplot(2,2,2)
barwitherrnn(valueErrors, valueStat);
box off;
xticks(gca, []);
xticklabels(gca, [])
yticks(gca, [0 2 4 6 8 10])
axInfo = axis;
axis([axInfo(1) axInfo(2) 0 10])
set(gca,'TickLength',[0 0])
ylabel('Rejected components (n)')

%% Gather data for numMarkedAtLT
[values_gsDors_R, values_gsStep_R, values_protoDorsA_R, values_protoStepA_R, ~, ~] = getDataGroups(tableSubset,...
    'numRejectedEpochs');
[values_gsDors_E, values_gsStep_E, values_protoDorsA_E, values_protoStepA_E, ~, ~] = getDataGroups(tableSubset,...
    'numEvents');
[values_gsDors, values_gsStep, values_protoDorsA, values_protoStepA, ~, ~] = getDataGroups(tableSubset,...
    'numMarkedAtLT');
values_gsDors       = (values_gsDors + values_gsDors_R) ./ values_gsDors_E .* 100;
values_gsStep       = (values_gsStep + values_gsStep_R) ./ values_gsStep_E .* 100;
values_protoDorsA   = (values_protoDorsA + values_protoDorsA_R) ./ values_protoDorsA_E .* 100;
values_protoStepA   = (values_protoStepA + values_protoStepA_R) ./ values_protoStepA_E .* 100;
% Create a bar plot with errors
valueErrors = round([std(values_gsDors) std(values_protoDorsA);...
    std(values_gsStep) std(values_protoStepA)], 1);
valueStat = round([mean(values_gsDors) mean(values_protoDorsA);...
    mean(values_gsStep) mean(values_protoStepA)], 1);
subplot(2,2,3)
barwitherrnn(valueErrors, valueStat);
box off;
xticklabels({'Dorsiflexion', 'Step on/off'});
axis([axInfo(1) axInfo(2) 0 100])
ylabel('Rejected epochs (%)')
set(gca,'TickLength',[0 0])
title('At threshold 75 uVpp')
yticks(gca, [0 20 40 60 80 100])

%% Gather data for numMarkedAtHT
[values_gsDors_R, values_gsStep_R, values_protoDorsA_R, values_protoStepA_R, ~, ~] = getDataGroups(tableSubset,...
    'numRejectedEpochs');
[values_gsDors_E, values_gsStep_E, values_protoDorsA_E, values_protoStepA_E, ~, ~] = getDataGroups(tableSubset,...
    'numEvents');
[values_gsDors, values_gsStep, values_protoDorsA, values_protoStepA, ~, ~] = getDataGroups(tableSubset,...
    'numMarkedAtHT');
values_gsDors       = (values_gsDors + values_gsDors_R) ./ values_gsDors_E .* 100;
values_gsStep       = (values_gsStep + values_gsStep_R) ./ values_gsStep_E .* 100;
values_protoDorsA   = (values_protoDorsA + values_protoDorsA_R) ./ values_protoDorsA_E .* 100;
values_protoStepA   = (values_protoStepA + values_protoStepA_R) ./ values_protoStepA_E .* 100;
% Create a bar plot with errors
valueErrors = round([std(values_gsDors) std(values_protoDorsA);...
    std(values_gsStep) std(values_protoStepA)], 1);
valueStat = round([mean(values_gsDors) mean(values_protoDorsA);...
    mean(values_gsStep) mean(values_protoStepA)], 1);
subplot(2,2,4)
barwitherrnn(valueErrors, valueStat);
xticklabels({'Dorsiflexion', 'Step on/off'});
box off;
axis([axInfo(1) axInfo(2) 0 100])
ylabel('Rejected epochs (%)')
set(gca,'TickLength',[0 0])
yticks(gca, [0 20 40 60 80 100])
title('At threshold 125 uVpp')
end