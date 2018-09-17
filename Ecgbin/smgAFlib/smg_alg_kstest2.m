function P = smg_alg_kstest2(x1, x2, n1,n2)


x1  =  x1(~isnan(x1));
x2  =  x2(~isnan(x2));
x1  =  x1(:);
x2  =  x2(:);

if isempty(x1)
    error(message('stats:kstest2:NotEnoughData', 'X1'));
end

if isempty(x2)
    error(message('stats:kstest2:NotEnoughData', 'X2'));
end

n =  n1 * n2 /(n1 + n2);

sampleCDF1  =  x1(1:end);
sampleCDF2  =  x2(1:end);

deltaCDF  =  abs(sampleCDF1 - sampleCDF2);
KSstatistic   =  max(deltaCDF);

%%

tmpCDF1 = sampleCDF1 - sampleCDF2;
tmpCDF2 = sampleCDF2 - sampleCDF1;
KSstatistic2 = max(tmpCDF1)+max(tmpCDF2);

%%
lambda =  max((sqrt(n) + 0.12 + 0.11/sqrt(n)) * KSstatistic , 0);
lambda2 =  max((sqrt(n) + 0.155 + 0.24/sqrt(n)) * KSstatistic2 , 0);

j       =  (1:101)';
j2=j.^2;

pValue1  =  2 * sum((-1).^(j-1).*exp(-2*lambda*lambda*j2));
pValue1  =  min(max(pValue1, 0), 1);

pValue2  =  kuiperprob(lambda2);
pValue2  =  min(max(pValue2, 0), 1);

P(1,:)=pValue1;
P(2,:)=pValue2;


    function QK = kuiperprob(lambda)
        % probability for Kuiper statistic
        if lambda < 0.3
            QK = 1;
        elseif lambda > 5
            QK = 0;
        else
            j       =  (1:101)'; % use ceil(sqrt(-log(eps)/2)/0.3)=15 terms to evaluate series
            ej = 2*(lambda*j).^2;
            QK = 2*sum((2*ej-1).*exp(-ej));
        end
    end
end
