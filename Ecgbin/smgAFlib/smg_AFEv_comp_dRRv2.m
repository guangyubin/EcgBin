% //This software is licensed under the BSD 3 Clause license: http://opensource.org/licenses/BSD-3-Clause 
% 
% 
% //Copyright (c) 2013, University of Oxford
% //All rights reserved.
% 
% //Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
% 
% //Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
% //Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
% //Neither the name of the University of Oxford nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
% //THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
%   The method implemented in this file has been patented by their original
%   authors. Commercial use of this code is thus strongly not
%   recocomended.
%
% //Authors: 	Gari D Clifford - 
% //            Roberta Colloca -
% //			Julien Oster	-

function [ dRR_s ] = smg_AFEv_comp_dRRv2( RR,meanRR )

dRR_MIN=0.3;
dRR_MAX=0.6;

% RR_s(:,1)=RR(i) and RR_s(:,2)=RR(i-1)
RR=RR(:);
RR_s=[RR(2:length(RR),1) RR(1:length(RR)-1,1)];
dRR_s=[];

% Normalization factors (normalize according to the heart rate)
k1=2;
k3=1.5;
k5=1.25;

k2=0.5;
k4=0.75;
k6=0.25;
for i=1:length(RR_s)
    if RR_s(i,1)>0 && RR_s(i,2)>0
        if sum(RR_s(i,:)<0.500)>=1
            tmpdRR = k1*(RR_s(i,1)-RR_s(i,2));
            if abs(tmpdRR)>0.6
                tmpdRR = k3*(RR_s(i,1)-RR_s(i,2));
            end
            if abs(tmpdRR)>0.6
                tmpdRR = k5*(RR_s(i,1)-RR_s(i,2));
            end
            
        else if sum(RR_s(i,:)>1)>=1
                tmpdRR = k2*(RR_s(i,1)-RR_s(i,2));
               
            else
                tmpdRR = (RR_s(i,1)-RR_s(i,2));
                if abs(tmpdRR)>0.6
                    tmpdRR = k4*(RR_s(i,1)-RR_s(i,2));
                end
                
            end
        end
        
        dRR_s=[dRR_s; tmpdRR];
    end
end

% if meanRR<0.5
% RR_s=RR_s*2;
% end
% 
% for i=1:length(RR_s)
%     if RR_s(i,1)>0 && RR_s(i,2)>0
%          dRR_s=[dRR_s; RR_s(i,1)-RR_s(i,2)];
%     end
% end
% 
% tmpdRR_s = abs(dRR_s);
% maxdRR = max(tmpdRR_s);
% if maxdRR>1.2    
%     maxdRR=1.2;
% end
% mindRR=min(tmpdRR_s(tmpdRR_s>dRR_MIN));
% % if mindRR>=dRR_MAX/2
% %     mindRR = dRR_MAX/2;
% % end
% if maxdRR>dRR_MAX 
%    for ii=1:length(dRR_s)       
%        if tmpdRR_s(ii) >=mindRR           
%             tmpdRR_s(ii) = mindRR + (tmpdRR_s(ii)-mindRR)*(dRR_MAX-mindRR)/(maxdRR-mindRR);
%             if dRR_s(ii)<0
%                 dRR_s(ii)=-tmpdRR_s(ii);
%             else
%                 dRR_s(ii)=tmpdRR_s(ii);
%             end
%        end
%    end
% end

end
