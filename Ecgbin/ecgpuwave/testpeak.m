function pic=testpeak(X,pic,Fs,p)

% ---- Adjust the correspondence between the null-derivative criterium
% peak and the ECG signal peak ----

kpos=round(10e-3*Fs);
laux=pic;
a = max(pic-kpos,1);
b = min(pic+kpos,length(X));
Xaux=X(a:b);
if p==1
   [mpic,iaux]=max(Xaux);
else
   [mpic,iaux]=min(Xaux);
end
pic=pic-kpos+iaux-1;
   
