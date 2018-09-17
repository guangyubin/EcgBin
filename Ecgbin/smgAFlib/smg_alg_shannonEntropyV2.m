%Statistical AF Detection Algorithm
%Term Project
%Shannon Entropy Function

function [se] = smg_alg_shannonEntropy (signal)
%Initialize shannon entropy
se = 0;

%Set constant calculation parameters
bin_size = 15;

datalength = length(signal);
if(datalength > 6)
    
    radius = 0.6;
    
    %Calculate histogram bins    
    edges=-radius:0.04:radius; 
    [h] = histcounts(signal,edges);
    
%     h = histc (signal, -radius:(radius+radius)/bin_size:radius);
    
    widow_length = length(h(:));
    window_size = sum(h(:));
    
    if window_size>0
        %Calculate probability of each bin        
        probabilities = h  / window_size;
        
        %Calculate shannon entropy
        for n = 1:widow_length
            if probabilities (n) ~= 0
                se = se + probabilities (n) * ( log (probabilities (n)) );
                %              se = se - probabilities (n) * (log2( probabilities (n) ));
            end
        end
        
        se = - se / log(widow_length);
    end
end
end