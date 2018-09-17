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

function [ dRR_s ] = smg_AFEv_comp_dRR( RR )


% RR_s(:,1)=RR(i) and RR_s(:,2)=RR(i-1)
RR=RR(:);
RR_s=[RR(2:length(RR),1) RR(1:length(RR)-1,1)];
dRR_s=[];

% Normalization factors (normalize according to the heart rate)
k1=2;
k3=1.5;
k2=0.5;
k4=0.75;
for i=1:length(RR_s)
    if RR_s(i,1)>0 && RR_s(i,2)>0
        if sum(RR_s(i,:)<0.500)>=1
            tmpdRR = k1*(RR_s(i,1)-RR_s(i,2));
            if abs(tmpdRR)>0.6
                tmpdRR = k3*(RR_s(i,1)-RR_s(i,2));
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


% for i=1:length(RR_s)
%     if RR_s(i,1)>0 && RR_s(i,2)>0
%          dRR_s=[dRR_s; RR_s(i,1)-RR_s(i,2)];
%     end
% end
% 
% tmpdRR_s = abs(dRR_s);
% maxdRR = max(tmpdRR_s);
% if maxdRR>0.6
%     if maxdRR >1
%         maxdRR=1;
%     end
%     factor = 0.6/maxdRR;
% 
%     dRR_s = dRR_s*factor;
% end

end
