function ecg = loadmgcraw(record)


fid = fopen(record,'rb');
fseek(fid,100,'bof');
d= fread(fid,[57 inf], 'int8');

fclose(fid);
d = int8(d);
ecg = zeros(1,50*size(d,2));
for ii = 1:size(d,2)
    x = typecast(d(7:8,ii),'int16');
    y = cumsum(d(9:end,ii));
    x = double(x);y = double(y);
    ecg(1,(ii-1)*50+1 :ii*50) =  [x; x+y]';
end
