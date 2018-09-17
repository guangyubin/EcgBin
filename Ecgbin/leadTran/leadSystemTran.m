% 采集的数据为12通道，以LL为参考
%　此函数把该数据转化为XYZ，和HEICA导联体系
function [Lead_8,Lead_XYZ, Lead_HEICA] = leadSystemTran(raw)

d = raw;

RA_LL = d(1,:);
LA_LL = d(2,:);
V1_LL = d(3,:);
V2_LL = d(4,:);
V3_LL = d(5,:);
V4_LL = d(6,:);
V5_LL = d(7,:);
V6_LL = d(8,:);
I_LL = d(9,:);
E_LL = d(10,:);
C_LL = V4_LL;
A_LL = V6_LL;
M_LL = d(11,:);
H_LL = d(12,:);
% 12 lead system
I = LA_LL - RA_LL;
II = -RA_LL;
III = -LA_LL;
aVR = -(I+II)/2;
aVL = (I-III)/2;
aVF = (II+III)/2;
V1 = V1_LL - (RA_LL+LA_LL)/3;
V2 = V2_LL - (RA_LL+LA_LL)/3;
V3 = V3_LL - (RA_LL+LA_LL)/3;
V4 = V4_LL - (RA_LL+LA_LL)/3;
V5 = V5_LL - (RA_LL+LA_LL)/3;
V6 = V6_LL - (RA_LL+LA_LL)/3;
Lead_8 = cat(1,I,II,V1,V2,V3,V4,V5,V6);
Lead_12 = cat(1,I,II,III,aVR,aVL,aVF,V1,V2,V3,V4,V5,V6);
% XYZ lead
X = I_LL-A_LL;
Y = -H_LL;
Z = M_LL-E_LL;
Lead_XYZ = cat(1,X,Y,Z);
% matrix_xyz_12 = [0.79,0.24,-0.56,-0.51,0.67,-0.16,-0.52,-0.15,0.69,1.34,1.09,0.65;...
%  -0.24,10.5,1.29,-0.41,-0.77,1.77,-0.06,-0.35,0.348,0.68,0.64,0.52;...
%  0.08,-0.01,-0.09,-0.03,0.08,-0.05,-0.104,-1.76,-1.16,-0.49,0.01,0.23];
% b = regress(I',Lead_XYZ');
% figure;plot(Lead_XYZ'*b,'r');hold on;plot(I);

% beta = mvregress(Lead_XYZ',Lead_8');
%  Lead_8_fromxyz = beta'*Lead_XYZ;
% HEICA lead system
EH = E_LL - H_LL;
AH = A_LL - H_LL;
AI = A_LL - I_LL;
CI = C_LL - I_LL;
Lead_HEICA = cat(1,EH,AH,AI,CI);