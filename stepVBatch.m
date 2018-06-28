function stepVBatch
%stepVBatch Pipeline setup for step V of study: "An EEG Experimental Study 
%   Evaluating the Performance of Texas Instruments ADS1299."
%   In this step a table is created for the data from previous step.
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
INPUT_FOLDER     = fullfile(DATA_FOLDER, 'Step IV');
OUTPUT_FOLDER    = fullfile(DATA_FOLDER, 'Step V');

%% Load all files as single table.
dataTable = loadFolderAsTable(INPUT_FOLDER);

%% Append mvNum, sysNum, paraNum as additional columns to the table
mvNum       = strcmpMSC(table2cell(dataTable(:, 'task')), {'Step on/off'}) + 1; % Step on/off = 2
sysNum      = strcmpMSC(table2cell(dataTable(:, 'system')), {'Prototype'}) + 1; % Prototype = 2
paraNum     = strcmpMSC(table2cell(dataTable(:, 'paradigm')), {'Cued'}) + 1; % Cued = 2
dataTable(:, 'mvNum')       = table(mvNum);
dataTable(:, 'sysNum')      = table(sysNum);
dataTable(:, 'paraNum')     = table(paraNum);

%% Create SummaryTable, MeasuresTable, PowerTable, SignalsTable
SummaryTable = dataTable(:, {'partNum', 'sessNum', 'mvNum',...
    'sysNum', 'paraNum', 'numEvents',...
    'numRejectedEpochs', 'numRejectedComponents', 'numMarkedAtHT',...
    'numMarkedAtLT', 'numInterpolatedChans'});
MeasuresTable = dataTable(:, {'partNum', 'sessNum', 'mvNum',...
    'sysNum', 'paraNum', 'L'});

PowerTable = dataTable(:, {'partNum', 'sessNum', 'mvNum',...
    'sysNum', 'paraNum', 'P'});
SignalsTable = dataTable(:, {'partNum', 'sessNum', 'mvNum',...
    'sysNum', 'paraNum', 'B'});

%% Expand MeasuresTable
measureNames        =  table2cell(dataTable(1, 'measureNames'));
measureNames        = measureNames{:};
measuresVals        = table2array(MeasuresTable(:, 'L'));
dataAsCell          = cellfun(@transpose, measuresVals, 'UniformOutput', 0);
if(sum(cellfun(@isempty, dataAsCell)) > 0)
    emptyCells = find(cellfun(@isempty, dataAsCell));
    for i=1:length(emptyCells)
        dataAsCell{emptyCells(i)} = NaN.*ones(1, length(measureNames));
    end
end
measuresValsTable   = array2table(cell2mat(dataAsCell), 'VariableNames', measureNames);
MeasuresTable       = MeasuresTable(:, {'partNum', 'sessNum', 'mvNum',...
    'sysNum', 'paraNum'});
MeasuresTable       = cat(2, MeasuresTable, measuresValsTable);

%% Expand PowerTable
bandNames           =  table2cell(dataTable(1, 'bandNames'));
bandNames           = bandNames{:};
bandVals            = table2array(PowerTable(:, 'P'));
dataAsCell          = cellfun(@transpose, bandVals, 'UniformOutput', 0);
if(sum(cellfun(@isempty, dataAsCell)) > 0)
    dataAsCell{cellfun(@isempty, dataAsCell)}...
        = NaN.*ones(1, length(bandNames));
end
bandValsTable       = array2table(cell2mat(dataAsCell), 'VariableNames', bandNames);
PowerTable          = PowerTable(:, {'partNum', 'sessNum', 'mvNum',...
    'sysNum', 'paraNum'});
PowerTable          = cat(2, PowerTable, bandValsTable);

%% Save tables as mat and csv when possible
if(~isfolder(OUTPUT_FOLDER))
    mkdir(OUTPUT_FOLDER);
end
save(fullfile(OUTPUT_FOLDER, 'DataTable.mat'), 'dataTable');
save(fullfile(OUTPUT_FOLDER, 'SummaryTable.mat'), 'SummaryTable');
writetable(SummaryTable, fullfile(OUTPUT_FOLDER, 'SummaryTable.csv'));
save(fullfile(OUTPUT_FOLDER, 'MeasuresTable.mat'), 'MeasuresTable');
writetable(MeasuresTable, fullfile(OUTPUT_FOLDER, 'MeasuresTable.csv'));
save(fullfile(OUTPUT_FOLDER, 'PowerTable.mat'), 'PowerTable');
writetable(PowerTable, fullfile(OUTPUT_FOLDER, 'PowerTable.csv'));
save(fullfile(OUTPUT_FOLDER, 'SignalsTable.mat'), 'SignalsTable');
end