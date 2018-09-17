
%%
load('FT_208')
tmptree = templateTree('MaxNumSplits',55,'MergeLeaves','on');
Mdl = fitensemble(FT',label,'AdaBoostM2',40,tmptree,'KFold',100);
genError = kfoldLoss(Mdl,'Mode','Cumulative');
figure;plot(genError);
%%
load('FT_207')
tmptree = templateTree('MaxNumSplits',55,'MergeLeaves','on');
tree_adaboost = fitensemble(FT',label,'AdaBoostM2',20,tmptree);
save('tree_adaboost.mat','tree_adaboost');
class1 = predict(tree_adaboost,FT');
confusion_matrix(label',class1,1); 

%%
alltree = fitctree(FT(1:37,:)',label,'MaxNumSplits',55,'MergeLeaves','on'£¬);
class = predict(alltree,FT(1:37,:)');
save('alltree.mat','alltree');
confusion_matrix(label',class,1);
