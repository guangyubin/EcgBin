
%%

subplot(231);histogram(FT(5,label==2),0:1:10,'Normalization','probability');
subplot(232);histogram(FT(5,label==3),0:1:10,'Normalization','probability');
subplot(233);histogram(FT(5,label==4),0:1:10,'Normalization','probability');


subplot(234);histogram(FT(3,label==2),0:0.01:1,'Normalization','probability');
subplot(235);histogram(FT(3,label==3),0:0.01:1,'Normalization','probability');
subplot(236);histogram(FT(3,label==4),0:0.01:1,'Normalization','probability');
%%


subplot(231);histogram(FT(1,label==2),-100:2:100);
subplot(232);histogram(FT(1,label==3),-100:2:100);
subplot(233);histogram(FT(1,label==4),-100:2:100);

subplot(234);histogram(FT(2,label==2),0:.05:1);
subplot(235);histogram(FT(2,label==3),0:.05:1);
subplot(236);histogram(FT(2,label==4),0:.05:1);
%%
subplot(231);histogram(FT(5,label==2),0:1:10);
subplot(232);histogram(FT(5,label==3),0:1:10);
subplot(233);histogram(FT(5,label==4),0:1:10);

subplot(234);histogram(FT(6,label==2),0:1:10);
subplot(235);histogram(FT(6,label==3),0:1:10);
subplot(236);histogram(FT(6,label==4),0:1:10);