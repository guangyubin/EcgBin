%%
clc
clear

load('D:\MGCDB\MuseDB_500Hz.mat');
for ii = 1:length(DATA)
    type_ref = DATA(ii).QRStype;
    rpos_ref = DATA(ii).rpos;
    wave  =  DATA(ii).wave;
    if length(unique(type_ref)) == 3
        ecgplot_8chan(wave',500,rpos_ref,type_ref);
      
    end;
  

    


end
%%
[avg_err,std_err,n5,n10,n20,n30,n40,n100] = meas_qt(qt2,qt1);
%%

