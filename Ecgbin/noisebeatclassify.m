%%

path = 'D:\MGCDB\mitdb250\';
list = dir([path '*.dat']);
m = 1;
beatdata = [];
ratio = [];
group = [];

left = 60;
right = 100;
for ii = 1: length(list)
    
    [hea, d] = loadmgcdata([path,list(ii).name(1:end-4)]);
    ann = readannot([path,list(ii).name(1:end-4), '.atr']);
    index = find(ann.anntyp=='V');
    if ~isempty(index)
        for jj = 1:length(index)
            t1 = ann.time(index(jj)) - left;
            t2 = ann.time(index(jj)) + right;
            if t1 > 0 && t2 < length(d)
                x = d(t1:t2);
                [Fx, r] = matmgc('absfft' ,x*200,length(x));
                 r = matmgc('hfratio' ,x*200,length(x));
                if sum(Fx(1:40))~= 0
                    ratio(:,m) = [ sum(Fx(20:60)) / sum(Fx(4:80))   ];
                    ratio2(:,m) = r;
                    group(m) = 2;
                    m = m +1;
                end
            end
        end
    end
end

%%
path = 'D:\MGCDB\CAREB0\ErrorVEB\';
list = dir([path '*.dat']);

for ii = 1:length(list)
    try
        [hea, d] = loadmgcdata([path,list(ii).name(1:end-4)]);
        ann = loadmgcqrs([path,list(ii).name(1:end-4), '.qrs']);
        index = find(ann.anntyp=='V');
        if ~isempty(index)
            for jj = 1:length(index)
                t0 = double(ann.time(index(jj))) + double(ann.qrs(index(jj),4));
                t1 = ann.time(index(jj)) - left;
                t2 = ann.time(index(jj)) + right;
                if t1 > 0 && t2 < length(d)
                    
                    x = d(t1:t2);
                    [Fx, r] = matmgc('absfft' ,x*200,length(x));
                        r = matmgc('hfratio' ,x*200,length(x));
                    if sum(Fx(1:40))~= 0
                        ratio(:,m) = [ sum(Fx(20:60)) / sum(Fx(4:80))   ];
                         ratio2(:,m) = r;
                        group(m) = 3;
                        m = m +1;
                    end
                end
            end
        end
    catch
    end
end

figure;plot(ratio);hold on;plot(ratio2);
%%
X = ratio2'; Y = group';
figure;subplot(311);hist(X(Y==1,1));
subplot(312);hist(X(Y==2,1));
subplot(313);hist(X(Y==3,1));
% figure;subplot(311);hist(X(Y==1,2));
% subplot(312);hist(X(Y==2,2));
% subplot(313);hist(X(Y==3,2));
%%

thr = 0.32;
X = ratio2(1,:)'; Y = group(1,:)';
disp([length(find(X(Y==1)>thr)) length(X(Y==1))]);
disp([length(find(X(Y==2)>thr)) length(X(Y==2))]);
disp([length(find(X(Y==3)>thr)) length(X(Y==3))]);

%%
X = ratio'; Y = group';
[CLASS,ERR,POSTERIOR,LOGP,COEF] = classify(X(Y~=1),X(Y~=1),Y(Y~=1));
disp(ERR)


% disp(COEF)
