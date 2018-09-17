%%
function [R2,Rs] = leadSysEval(Ref,Test);
% Ref = Lead_8;
% Test = Lead_8_fromHEICA;
for ii = 1:size(Ref,1)
    x1 = Ref(ii,:);
    x2 = Test(ii,:);
    
    R2(ii) = 1-sum((x1-x2).^2)/sum(x1.*x1);
end;
Rs = 1-sum(sum((Ref - Test).^2)) / sum(sum(Ref.*Ref));