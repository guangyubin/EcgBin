%%
index = find(label==4 & class' ==3);

other = zeros(1,length(index));
for ii= 2:length(index)
    
    jj = index(ii);
%     if ( p2(ii,3) < 3)
        fname = [data_dir RECORDS{jj}];
        
        [tm,ecg,fs,siginfo]=rdmat(fname);    
      [QRS,sign,en_thres,p2] = qrs_detect3(ecg',0.25,0.6,fs);
      p3 = Feature_Other(QRS,fs)
           plot(ecg);  hold on;plot(QRS,ecg(QRS),'.');   hold off;
           title( [num2str(p3) '  ' num2str(label(jj))] ); hold off;

 
    
end

length(find(other == 1))