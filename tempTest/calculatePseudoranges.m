function [pseudoranges] = calculatePseudoranges( ...
                                                trackResult1, ...
                                                trackResult2,...
                                                settings)


%--- For all channels in the list ... 

    %--- Compute the travel times -----------------------------------------    
    travelTime1 = ...
        (trackResult1.codePhase/settings.codeLength) * settings.CA_Period/2^settings.ncoLength ;
    travelTime2 = (floor(travelTime1 * settings.freqDiff) + ...
        mod(abs(2^settings.ncoLength+trackResult2.carrPhase - trackResult1.carrPhase),2^settings.ncoLength)/2^settings.ncoLength) ...
        /settings.freqDiff;

%--- Truncate the travelTime and compute pseudoranges ---------------------


%--- Convert travel time to a distance ------------------------------------
% The speed of light must be converted from meters per second to meters
% per millisecond. 
    pseudoranges.pseudorange1   = travelTime1 * settings.c ;
    pseudoranges.pseudorange2   = travelTime2 * settings.c ;
    
    
