%Statistical AF Detection Algorithm
%Term Project
%Shannon Entropy Function

function [se] = smg_alg_shannonEntropyV1 (signal)
%Initialize shannon entropy
se = 0;

%Set constant calculation parameters
bin_size = 13;
%32 :F = 0.768   Acc = 0.91392;
%16: F = 0.78684   Acc = 0.9146
%13: F = 0.79187   Acc = 0.91629
%12: F = 0.78841   Acc = 0.91308
%10: F = 0.7738   Acc = 0.91241

%signal = diff(signal');

%13 : F = 0.80259   Acc = 0.9146
%16 ; F = 0.81026   Acc = 0.91561
%32 : F = 0.81218   Acc = 0.91865
%64 : F = 0.81489   Acc = 0.91949
%128 (0.2 0.6) F = 0.83833   Acc = 0.9308
%64 (0.2 0.6) F = 0.83863   Acc = 0.92827
%32 (0.2 0.6):F = 0.83688   Acc = 0.92844
%16 (0.2 0.6):F = 0.83456   Acc = 0.92675

%64(0.1 0.6) F = 0.88284   Acc = 0.94751   *****
%96(0.1 0.6) F = 0.88098   Acc = 0.94414
%32(0.1 0.6) F = 0.88174   Acc = 0.94549

%64(0.05 0.5) F = 0.85921   Acc = 0.93806
%64(0.0 0.5)F = 0.74183   Acc = 0.9038
%64(0.1 0.5)F = 0.87794   Acc = 0.94633
%64(0.1 0.7)F = 0.88496   Acc = 0.94734
%64(0.1 0.8)F = 0.88553   Acc = 0.94717
%64(0.1 0.9)F = 0.88262   Acc = 0.94549
%64(0.05 0.6)F = 0.87266   Acc = 0.94346

%     signal=comp_dRR(signal);
%64(0.1 0.8) F = 0.90298   Acc = 0.95612
%64(0.1 0.6) F = 0.90829   Acc = 0.95932
%64(0.1 0.5) F = 0.91007   Acc = 0.95966
%32(0.1 0.5)F = 0.91052   Acc = 0.96068
%16(0.1 0.5)F = 0.9116   Acc = 0.96051
%16(0.1 0.6)F = 0.90656   Acc = 0.95882
%16(-0.5 0.5)F = 0.91747   Acc = 0.96354
%32(-0.5 0.5)F = 0.90382   Acc = 0.95764
%16(-0.6 0.6) F = 0.91262   Acc = 0.96169
%16(-0.4 0.4)F = 0.91092   Acc = 0.96135

%14(-0.5 0.5)F = 0.91777   Acc = 0.96388
%13(-0.5 0.5)F = 0.92202   Acc = 0.96591 ***
%12(-0.5 0.5)F = 0.91775   Acc = 0.96354
%10(-0.5 0.5)F = 0.91252   Acc = 0.96068
%13(-0.45 0.45)F = 0.91513   Acc = 0.96354
%13(-0.55 0.55)F = 0.91172   Acc = 0.96118

%8(0.1 0.5)F = 0.90537   Acc = 0.95949
%13(0.1 0.5)F = 0.90824   Acc = 0.96


datalength = length(signal);
if(datalength > 6)
    
    radius = 0.5;
    
    %Calculate histogram bins
    %h = hist (signal, bin_size);
    h = histc (signal, -radius:(radius+radius)/bin_size:radius);
    %      h = histc (signal, -1:(1+1)/bin_size:1);
    widow_length = length(h(:));
    window_size = sum(h(:));
    if window_size > 0
        %Create empty vector for bin probabilities
        probabilities = zeros (widow_length, 1);
        
        %Calculate probability of each bin
        
        probabilities = h  / window_size;
        
        %Calculate shannon entropy
        for n = 1:widow_length
            if probabilities (n) ~= 0
                se = se + probabilities (n) * (log (probabilities (n)) / log (1 / 16));
                %              se = se - probabilities (n) * (log2( probabilities (n) ));
            end
        end
        
        %     se = length(find(probabilities~=0))/window_size * se;
    end
end
end