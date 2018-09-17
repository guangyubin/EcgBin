function classifyResult = challenge(recordName)
%
% Sample entry for the 2017 PhysioNet/CinC Challenge.
%
% INPUTS:
% recordName: string specifying the record name to process
%
% OUTPUTS:
% classifyResult: integer value where
%                     N = normal rhythm
%                     A = AF
%                     O = other rhythm
%                     ~ = noisy recording (poor signal quality)
%
% To run your entry on the entire training set in a format that is
% compatible with PhysioNet's scoring enviroment, run the script
% generateValidationSet.m
%
% The challenge function requires that you have downloaded the challenge
% data 'training_set' in a subdirectory of the current directory.
%    http://physionet.org/physiobank/database/challenge/2017/
%
% This dataset is used by the generateValidationSet.m script to create
% the annotations on your training set that will be used to verify that
% your entry works properly in the PhysioNet testing environment.
%
%
% Version 1.0
%
%
% Written by: Chengyu Liu and Qiao Li January 20 2017
%             chengyu.liu@emory.edu  qiao.li@emory.edu
%
% Last modified by:
%
%

% addpath('ecgpuwave')

addpath('osealib');
addpath('smgAFlib');
classifyResult = '~'; % default output noisy

X = ecg_feature_extract(recordName);

load('tree_adaboost.mat')
[class,score] = predict(tree_adaboost,X);

if class == 1
    classifyResult = '~';
elseif class == 2
    classifyResult = 'N';
elseif class == 3
    classifyResult = 'A';
elseif class == 4
    classifyResult = 'O';
end

