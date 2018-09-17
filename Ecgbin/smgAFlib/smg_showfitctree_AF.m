function [F1,allmaxtree,class] = smg_showfitctree_AF(X,Y,MaxNumSplits,showtree)
%
Mdl7 = fitctree(X,Y,'MaxNumSplits',MaxNumSplits,'MergeLeaves','on','CrossVal','on','KFold',10);
classErrorDefault = kfoldLoss(Mdl7);
disp(['Cross Validated = ' num2str(classErrorDefault)]);
disp('*****************************************************');
Acc = [] ;F = [];
for ii = 1 : length( Mdl7.Trained)
    tree4 = Mdl7.Trained{ii};
    [class4,score] = predict(tree4,X);
    [m2,mF(ii),Acc(ii),F] = confusion_matrix(Y,class4);
    %      mF(ii) = mean(F(2:4));
end
disp('*****************************************************');
disp(['average F =' num2str(mean(mF)) ', average Acc = '  num2str(mean(Acc))]);


[ a ,idx ] = max(mF);
tree = Mdl7.Trained{idx};

[class,score, node, cnum] = predict(tree,X);

allmaxtree = tree;

[m2,mF,acc,F] = confusion_matrix(Y,class,1);

% F1 = mean(F(2:4));
F1 = mean(F);


% view(tree,'Mode','graph')