%%
Ftname = {'AFEv','se','radius','meanRR',...
              'm','tPR',' tQRS','tQT','Pamp','Qamp','Samp','Tamp',...
              'sqiratio','status0','status1','status2',...
              'tQRS2','mtQRS1','mtQRS2',' mtPR','mPamp ','mQamp',' mRamp ','mSamp',' mTamp','ST','qrmrp','tso','bVF',...
              'tpr2',' tqrs2','tqt2 ',' pamp2','tamp2','st2','npvc'...
              'ks_p12'};
          

%%
clc
X = FT([5:25 30:41],:)';
% X = FT([1:41],:)';
X(isnan(X)) = 0 ;
Y = label';
Cost = [0, 0.8 ,0.8 ,0.8; 0.8 ,0,1,1;0.8,1,0,1;0.8,1,1,0]
Cost = [0, 1 ,1 ,1; 1 ,0,1,1;1,1,0,1;1,1,1,0];
 MdlDeep = fitctree(X,Y,'Cost',Cost,'MaxNumSplits',55,'MergeLeaves','on','CrossVal','on','KFold',100);
 errorDeep = kfoldLoss(MdlDeep)
 
MdlDeep = fitctree(X,Y,'Cost',Cost,'MaxNumSplits',55,'MergeLeaves','on');
class = predict(MdlDeep,X);
  confusion_matrix(label',class,1);
%  
%  
%  X = FT([1:41],:)';
% X(isnan(X)) = 0 ;
% Y = label';
% Cost = [0, 1 ,1 ,1; 1 ,0,1,1;1,1,0,1;1,1,1,0]; 
%  MdlDeep = fitctree(X,Y,'Cost',Cost,'MaxNumSplits',55,'MergeLeaves','on','CrossVal','on','KFold',100);
%  errorDeep = kfoldLoss(MdlDeep)
%  
%  
%  X = FT(1:16,:)';
% X(isnan(X)) = 0 ;
% Y = label';
% Cost = [0, 1 ,1 ,1; 1 ,0,1,1;1,1,0,1;1,1,1,0]; 
%  MdlDeep = fitctree(X,Y,'Cost',Cost,'MaxNumSplits',45,'MergeLeaves','on','CrossVal','on','KFold',100);
%  errorDeep = kfoldLoss(MdlDeep)
% 
% %        MdlDeep = fitctree(X,Y,'Cost',Cost,'MaxNumSplits',55,'MergeLeaves','on');
% %   class = predict(MdlDeep,X);
% %   confusion_matrix(label',class,1);
% %%
% % templ = templateTree('MaxNumSplits',50);
% 
% % % color = 'krgb';
% % % m = 1;
% % % 
% % %     templ = templateTree('MaxNumSplits',40,'MergeLeaves','on');
% % %     ClassTreeEns = fitensemble(X,Y,'AdaBoostM2',100,templ,...
% % %         'KFold',10);
% % %     genError = kfoldLoss(ClassTreeEns,'Mode','Cumulative');
% % % figure;plot(genError);
% % % 
% % % 
% % % ClassTreeEns = fitensemble(X,Y,'AdaBoostM2',25,templ);
% % % class = predict(ClassTreeEns,X);
% % %   [m2,mF(ii),Acc(ii),F] = confusion_matrix(label',class,1);
% %%
% nTrees = 100;
% leaf = 10;
% b = TreeBagger(nTrees,X,Y,'OOBVarImp','on',...
%                           'CategoricalPredictors',6,...
%                           'MinLeaf',leaf);
% bar(b.OOBPermutedVarDeltaError);
% [a,idx] = sort(b.OOBPermutedVarDeltaError,'descend');
% disp(Ftname(idx));
% xlabel('Feature number');
% ylabel('Out-of-bag feature importance');
% title('Feature importance results');
% 
% oobErrorFullX = b.oobError;
% figure;plot(oobErrorFullX);
