function [ RR ] = smg_get_RR( QRS, noiseQRS,fs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
RR = [];

QRS=QRS(:);
noiseQRS=noiseQRS(:);
if length(QRS)>0 && length(noiseQRS)>0
    row=1;
    for ii=1:length(noiseQRS)+1
        if ii==1
            tmpmin=0;
        else
            tmpmin=noiseQRS(ii-1);
        end
        
        if ii<length(noiseQRS)+1
            tmpmax = noiseQRS(ii);
        else
            tmpmax =QRS(end)+1;
        end
        tmpQRS=QRS(QRS<tmpmax & QRS>tmpmin);
        if length(tmpQRS)>1
%             RR{row}=diff(tmpQRS)/fs;
%             row=row+1;
            RR=[RR; diff(tmpQRS)/fs];
        end

    end
else
    RR = diff(QRS)/fs;
end
end

