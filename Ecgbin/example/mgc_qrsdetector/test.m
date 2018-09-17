ii = 46;
%     matmgc('creat_qrs' ,[path,list(ii).name(1:end-4)]);
%      matmgc('creat_xml' ,[path,list(ii).name(1:end-4)]);
 qrs = loadmgcqrs([path,list(ii).name(1:end-4), '.qrs']);
  qrs = qrs_reprocess(qrs);
   qrs2atr([path,list(ii).name(1:end-4), '.ate1'],qrs)
     ann = readannot([path,list(ii).name(1:end-4), '.ate1']);
 tm=   matmgc('mit_bxb',path,list(ii).name(1:end-4),'atr','ate1','5:0');