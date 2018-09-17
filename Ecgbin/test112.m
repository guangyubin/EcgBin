load('D:\MGCDB\muse\musedb_500Hz');

%%
x = DATA(574).wave(:,2)*200;
tic

qrs = matmgc('beat_detector',x(1:2:end)/200',250);
toc
figure;plot(x);hold on;plot(qrs(1,:)*2, x(qrs(1,:)*2),'.r');
clear matmgc;