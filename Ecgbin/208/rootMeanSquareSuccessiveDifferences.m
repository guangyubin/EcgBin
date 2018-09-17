%Statistical AF Detection Algorithm
%Term Project
%Root Mean Square of Successive Differences Function
 
function [rmssd] = rootMeanSquareSuccessiveDifferences (signal)
	
	signal_length = length (signal);
 
	%Initialize rmssd
	rmssd = 0;
	
	%Calculate RMSSD
	for j = 1:(signal_length - 1)
    	rmssd = rmssd + (signal (j + 1) - signal (j))^2;
	end
    
	rmssd = rmssd / (signal_length - 1);
	
	rmssd = sqrt (rmssd);
