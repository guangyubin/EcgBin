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

function [AFEv, ATEv, OrgIndex] = smg_AFEv_comput_AFEv(RR,meanRR,XYedges,debug)

%comput_AFEv takes the RR intervals segment (column vector)
%and computes AFEv

%Inputs
%segment:   RR intervals segment (column vector)

%Output
%AFEv:   feature for detection of Atrial Fibrillation

AFEv=0;
ATEv=0;
OrgIndex=0;

%Compute dRR intervals series
% dRR=comp_dRR(RR);
dRR=smg_AFEv_comp_dRR(RR);
% dRR=smg_AFEv_comp_dRRv2(RR,meanRR);

if length(dRR)>0
%Compute metrics

[OriginCount,IrrEv,PACEv,AnisotropyEv,DensityEv,RegularityEv]=smg_AFEv_metrics_v2(dRR, XYedges, debug);
% [OriginCount,IrrEv,PACEv,AnisotropyEv,DensityEv,RegularityEv]=smg_AFEv_metrics(dRR, debug);

%Compute AFEvidence
AFEv=IrrEv-OriginCount-2*PACEv;

%Compute ATEvidence
ATEv=IrrEv+AnisotropyEv+DensityEv+RegularityEv-4*PACEv;

%Compute OrgIndex
OrgIndex=OriginCount+AnisotropyEv+DensityEv+RegularityEv-2*IrrEv;

if debug>0
    display(['(dRR>=0.6) = ' num2str(length(dRR(abs(dRR)>0.6))) ' dRR length=' num2str(length(dRR(abs(dRR)<0.6)))...
        ' maxdRR=' num2str(max(abs(dRR))) ' mean dRR=' num2str(mean(abs(dRR))) ...
        ' AFEv=' num2str(AFEv)]);
    
end
end
end