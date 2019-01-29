%Colin Manuel Fernandes
%Universita Degli Studi Di Milano
%914777
%Intelligent Systems Project

%2:Template Extraction using pre trained VGG-FACE Network , to use different
%network(from the matlab nntoolbox) use the commented code to used
%matconvnet tool box change 'cnnMatFile' to point the required network 

clear all
close all
clc

dirImages='.\..\CroppedImages\';
dirOutput='.\..\ImageFeatures\';
mkdir(dirOutput);

files = dir([dirImages '*.jpg']);

%Load pretrained cnn
cnnMatFile = '.\..\CNN_Models\VggFace\vgg-face.mat';

%Download from below link for Pre-Trined CNN
% if ~exist(cnnMatFile)
%   fprintf('Downloading the VGG-Face model ... this may take a while\n') ;
%   mkdir(fileparts(cnnMatFile)) ;
%   urlwrite(...
%     'http://www.vlfeat.org/matconvnet/models/vgg-face.mat', ...
%     cnnMatFile) ;
% end

%Run MatConvNet
%Download from below site
%http://www.vlfeat.org/matconvnet/
%kindly make changes in vl_compilenn and change 'cl.exe' to respective
%compiler file in your system
run '.\..\Matconvonet\matconvnet-1.0-beta25\matconvnet-1.0-beta25\matconvnet-1.0-beta25\matlab\vl_setupnn'

% vl_compilenn('enableGpu', false) %run only for the first setup

net = load(cnnMatFile) ;
% featureLayer = 'fc7';

%for Matlab toolbox comment the below line and use the respective FC layer for the network 
%net=alexnet                    %change as per desired pretrained network
%layer = 'fc7';                 %Alexnet FC layer
%layer = 'pool5-drop_7x7_s1';   %GoogLeNet Feature Layer

for j = 1 : numel(files)
  
    im=imread([dirImages files(j).name]);
    im_ = single(im) ; % note: 255 range
    im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
    im_ = bsxfun(@minus,im_,net.meta.normalization.averageImage) ;
    
    %Comment below two line for Pretrained Networks from Matlab Toolbox
    res = vl_simplenn(net, im_) ;
    features = squeeze(res(33).x);
    
    %Un-Comment the below line for using Pretrained Networks from Matlab Toolbox
    %features = activations(net,im_,layer,'OutputAs','rows'); %Alexnet      
    features = features./norm(features,2);

    save([dirOutput replace(files(j).name,'.jpg','') '-features.mat'],'features');
end