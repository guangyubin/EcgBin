%Statistical AF Detection Algorithm
%Term Project
%Remove outliers

function signal_minus_outliers = removeOutliers (outliers,signal)

	%Find length of signal
	signal_minus_outliers = signal;
    
	%Identify maximum outliers  
	for n = 1:(outliers/2)
    	[~, max_index] = max (signal_minus_outliers);
    	signal_minus_outliers (max_index) = 0;
	end
    %Remove maximum outliers
	signal_minus_outliers (signal_minus_outliers == 0) = [];
	
	%Identify minimum outliers
	for n = 1:(outliers/2)
    	[~, min_index] = min (signal_minus_outliers);
    	signal_minus_outliers (min_index) = 10;
    end
	%Remove minimum outliers
	signal_minus_outliers (signal_minus_outliers == 10) = [];
	