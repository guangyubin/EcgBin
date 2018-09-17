 %% Fig1
load('FT_207')
maxnumsplits = 20:5:70;
for ii = 1:10
    for jj = 1:length(maxnumsplits)
        Md = fitctree(FT(1:37,:)',label,'MaxNumSplits',maxnumsplits(jj),'MergeLeaves','on','CrossVal','on','KFold',100);
        classError(ii,jj) = kfoldLoss(Md);
    end
end
save('classError_fitctree','classError');
figure;;plot(maxnumsplits,mean(classError)); xlabel('maximal number of decision splits');
ylabel('Cross-validated MSE')

 %% Fig2
classError = [];
load('FT_207')
parfor ii = 1:10
    tmptree = templateTree('MaxNumSplits',55,'MergeLeaves','on');
    Mdl = fitensemble(FT',label,'AdaBoostM2',40,tmptree,'KFold',100);
    classError(:,ii) = kfoldLoss(Mdl,'Mode','Cumulative');
    ii
end
save('classError_fitensemble','classError');
figure;plot(1:40,mean(classError,2)); xlabel('Number of decision trees');
ylabel('Cross-validated MSE')
 %% Fig3

  
 
 Ftname = {'AFEv','se','radius','meanRR',...
     'm','tPR',' tQRS','tQT','Pamp','Qamp','Samp','Tamp',...
     'sqiratio','status0','status1','status2',...
     'tQRS2','mtQRS1','mtQRS2',' mtPR','mPamp ','mQamp',' mRamp ','mSamp',' mTamp','ST','qrmrp','tso','bVF',...
     'tpr2',' tqrs2','tqt2 ',' pamp2','tamp2','st2','npvc'...
     'ks_p12'};
  Ftname = {'F10','F11','F12','F30',...
     'F31','F21B',' tQRS','tQT','F25B','Qamp','Samp','Tamp',...
     'F43','F40','F41','F42',...
     'tQRS2','F20A','F23A',' F21A','F25A ','F26A',' F27A ','F28A',' F29A','F24A','qrmrp','tso','bVF',...
     'F21B',' F20B','F22B ',' F25B','F29B','F24B','npvc'...
     'F13'};

 for ii = 1:10
     b = TreeBagger(20,FT',label,'OOBVarImp','on',...
         'CategoricalPredictors',6,...
         'MinLeaf',8);
     DeltaError(:,ii) = b.OOBPermutedVarDeltaError;
 end
 Delta1 = mean(DeltaError,2);
 Ftname1 = Ftname(list)';
 [a ,list] = sort(Delta1,'descend');          
bar(Delta1(list),'name',Ftname1);

