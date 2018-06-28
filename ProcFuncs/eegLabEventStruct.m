function [ eventStruct ] = eegLabEventStruct( forEventVect, eventType )
%eegLabEventStruct Takes an event times vector and returns a eeglab
%   compatible event structure.
%
%
%   Copyright (C) 2018 Usman Rashid
%   urashid@aut.ac.nz
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 3 of the License, or
%   (at your option) any later version.

numEvents = length(forEventVect);
eventStruct = struct([]);

for eventNum = 1:numEvents
    eventStruct(eventNum).('type') = eventType;
    eventStruct(eventNum).('latency') = forEventVect(eventNum);
    eventStruct(eventNum).('duration') = 1; % Number of samples
    eventStruct(eventNum).('urevent') = eventNum;
end

end