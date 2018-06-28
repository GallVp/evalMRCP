function [values_gsDors, values_gsStep, values_protoDorsA, values_protoStepA, values_protoDorsB, values_protoStepB] = getDataGroups(fromTable, forVariable)
%getDataGroups Returns data grouped by system and movement.
%
%
%   Copyright (C) 2018 Usman Rashid
%   urashid@aut.ac.nz
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 3 of the License, or
%   (at your option) any later version.

values_gsDors = table2array(fromTable(fromTable.sysNum == 1 & fromTable.mvNum == 1, {forVariable}));
values_gsStep = table2array(fromTable(fromTable.sysNum == 1 & fromTable.mvNum == 2, {forVariable}));

values_protoDorsA = table2array(fromTable(fromTable.sysNum == 2 & fromTable.mvNum == 1 & fromTable.sessNum ~= 4, {forVariable}));
values_protoStepA = table2array(fromTable(fromTable.sysNum == 2 & fromTable.mvNum == 2 & fromTable.sessNum ~= 4, {forVariable}));

values_protoDorsB = table2array(fromTable(fromTable.sysNum == 2 & fromTable.mvNum == 1 & fromTable.sessNum == 4, {forVariable}));
values_protoStepB = table2array(fromTable(fromTable.sysNum == 2 & fromTable.mvNum == 2 & fromTable.sessNum == 4, {forVariable}));
end

