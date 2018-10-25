function createSignalPlotsMW(forParts, forMovement)
%createSignalPlotsMW Creates plots for Cosine similarity of MRCPs, movement
%   wise.
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

if nargin < 1
    forParts    = 1:6;
    forMovement = 1;
end

numParts =  length(forParts);
partNums = forParts;

% Load Power table
SignalsTable = load(fullfile(pwd, 'Data', 'Step V', 'SignalsTable.mat'));
SignalsTable = SignalsTable.SignalsTable;
%% Remove cue paradigm
tableSubset = SignalsTable(SignalsTable.paraNum == 1 & SignalsTable.mvNum == forMovement & SignalsTable.sessNum ~=4, :);

%% Obtain signals
goldStandardSignals         = tableSubset(tableSubset.sysNum == 1, 'B');
prototypeSignals            = tableSubset(tableSubset.sysNum == 2, 'B');

goldStandardSignals         = cell2mat(table2array(goldStandardSignals)');

% For NaN values
prototypeSignals            = table2array(prototypeSignals)';
NaNIndex                        = cellfun(@isempty, prototypeSignals, 'UniformOutput', 1);
prototypeSignals(NaNIndex)  = {NaN.*ones(length(prototypeSignals{1}), 1)};
prototypeSignals            = cell2mat(prototypeSignals);

tVect                       = (1:size(prototypeSignals, 1)) ./ FS - TIME_BEFORE_EVENT;
yAxisLims = zeros(numParts, 2);

% Gold Standard vs Prototype Dorsiflexion
for i=1:numParts
    subplot(numParts / 3, 3, i);
    yMin = min([min(goldStandardSignals(:, partNums(i))) min(prototypeSignals(:, partNums(i)))]);
    yMax = max([max(goldStandardSignals(:, partNums(i))) max(prototypeSignals(:, partNums(i)))]);
    plot([0 0], [yMin yMax], 'LineWidth', 2, 'Color', [0.3 0.3 0.3])
    matlabColors = get(gca,'colororder');
    hold on;
    p1 = plot(tVect, goldStandardSignals(:, partNums(i)), 'Color', [0 0 0]);
    p2 = plot(tVect, prototypeSignals(:, partNums(i)), 'Color', matlabColors(2, :));
    title(sprintf('r = %.2f', cosineSimilarity(goldStandardSignals(:, partNums(i)), prototypeSignals(:, partNums(i)))));
    box off;
    tickNums = round([yMin+1 yMax-1], 1);
    set(gca,'ytick', tickNums);
    yAxisLims(i, :) = [yMin yMax];
    if(i <= numParts-3)
        set(gca,'xtick',[]);
        set(gca,'xticklabel',[]); 
        set(gca, 'XColor', [1 1 1]);
    else
        set(gca,'xtick',[-3 -2 -1 0 1 2 3]);
        xlabel('Time (s)')
    end
    if(i == numParts-2)
        ylabel('Amp. (uV)');
    end
    set(gca, 'TickLength', [0 0]);
    set(gca, 'YGrid', 'on');
    axis([-3 3 yAxisLims(i, 1) yAxisLims(i, 2)]);
    hold off;
end
legend([p1 p2], {'GS', 'Proto'}, 'Box', 'off', 'Orientation', 'horizontal');
end