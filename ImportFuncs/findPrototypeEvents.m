function [ indexVector ] = findPrototypeEvents( eventVector )
%FINDPROTOTYPEEVENTS Takes a logical vector of events from the prototype
%   data and generates a vector of indices.
%
%
%   Copyright (C) 2018 Usman Rashid
%   urashid@aut.ac.nz
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 3 of the License, or
%   (at your option) any later version.
diffOfEventVector = [0; diff(eventVector)];
indexVector = find(diffOfEventVector > 0);
end

