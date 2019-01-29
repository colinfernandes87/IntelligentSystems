clear all
close all
clc

DataSet=load('.\..\FeaturesSet\VggF_ProblemSet.mat');

NetDir='.\..\Observations\Total Features\';
mkdir('.\..\Observations\Total Features\')

% create a neural network
neuronsXLayer = [30]; % number of neurons per layer
neuronTransferFunction{1} = 'tansig';
neuronTransferFunction{2} = 'tansig';

net = feedforwardnet(neuronsXLayer,'trainscg');

% training and testing data
net.divideParam.trainRatio = 1; 
net.divideParam.testRatio  = 0; 
net.divideParam.valRatio   = 0;

net.trainParam.epochs = 1000;
net.trainParam.goal = 0.01;

for iL = 1: size(neuronsXLayer,2)
net.layers{iL}.transferFcn = neuronTransferFunction{iL}; 
end

% train FFNNs for Age and Gender
AgeNet = train(net,DataSet.p',DataSet.age');
save ([NetDir 'AgeNet.mat'], AgeNet);

GenderNet = train(net,DataSet.p',DataSet.gender');
save ([NetDir 'GenderNet.mat'], GenderNet);
