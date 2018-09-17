function [classErrorDefault,macc,mFv] = train_trees(FT,label,nlayers)
list = 1:size(FT,2);

group = label(list)';
FT(isnan(FT)) = 0 ;
index = find(group==1|group==2 | group==3 | group==4);
X = FT(: ,index)';
Y = group(index);
Mdl7 = fitctree(X,Y,'MaxNumSplits',nlayers,'MergeLeaves','on','CrossVal','on','KFold',100);
classErrorDefault = kfoldLoss(Mdl7);

for ii = 1 : length( Mdl7.Trained)
    tree4 = Mdl7.Trained{ii};
    [class4,score] = predict(tree4,FT');
    [m2,mF(ii),Acc(ii),F] = confusion_matrix(label',class4);
end

[ a ,idx ] = max(mF);

macc = mean(Acc);
mFv = mean(mF);



