function [ pk,pk_index ] = smg_alg_peek( datum, direction )
% peak() takes a datum as input and returns a peak index
% when the signal returns to half its peak height, or
datum = datum(:);
data_max = 0;
pk = 0 ;
pk_index = 0;

if direction > 0
    lastDatum=datum(1);
    start_idx = 2;
    step = 1;
    end_idx = length(datum);
    
else
    lastDatum=datum(end);
    
    start_idx = length(datum)-1;
    step = -1;
    end_idx = 1;
    
end
stage = 0;  %0��Ѱ�����ֵ�������׶�  1 �����׶��ҵ�һ�����ֵ 2 �½��׶� 
data_max = lastDatum;
data_begin = lastDatum;
for ii=start_idx: step : end_idx
    
    if stage <2 
        if (datum(ii) > lastDatum) && (datum(ii) > data_max)
            data_max = datum(ii) ;
            stage=1;
            pk = data_max ;
            pk_index = ii;
        end
        % stage 0 ���뵥������
        if stage==0 && ( (datum(ii) < lastDatum)  || (datum(ii) < data_max) )
            break;
        end
    end
    
    if stage>0
        %�ڶ��׶������뵥���ݼ�
        if stage==2 && ((datum(ii) > lastDatum) || (datum(ii) > data_max))
            pk_index = 0;
            break;
        end
        if (datum(ii) < lastDatum)
            stage = 2;
            %��ֵС�����ֵ��һ�룬����Ϊ�ҵ�����
            if (datum(ii) < (data_max /2))                
                break;
            end
        end
    end

    lastDatum = datum(ii) ;
end

if pk>0 && direction < 0
    pk_index = length(datum)- pk_index +1;
end

end
