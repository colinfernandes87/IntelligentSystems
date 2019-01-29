%Colin Manuel Fernandes
%Universita Degli Studi Di Milano
%914777
%Intelligent Systems Project

%4: Train and Test Neural Network, Report all the observations

clear all
close all 
clc

matFiles='.\..\FeaturesSet\';
obsFolder = '.\..\Observations\';
mkdir(obsFolder);
Files = dir([matFiles '*_pca500.mat']);
for i =1:length(Files)

    pcaFile=[Files(i).folder '\' Files(i).name];    
    [Results.Age{i}, AgeNet]=Func_FFNN(pcaFile,'age',10,30);
    
    ReportAge{i,1}=Files(i).name;
    ReportAge{i,2}=Results.Age{i}.Type; 
    ReportAge{i,3}=mean(Results.Age{i}.MAE); 
    ReportAge{i,4}=mean(Results.Age{i}.StdMAE);
    ReportAge{i,5}=mean(Results.Age{i}.ClassError);
    ReportAge{i,6}=Results.Age{i};

    save ([obsFolder 'ReportAge.mat'], 'ReportAge');
    save ([obsFolder 'AgeNet.mat'], 'AgeNet');
    
    [Results.Gender{i}, GenderNet]=Func_FFNN(pcaFile,'gender',10,30);
    
    ReportGender{i,1}=Files(i).name;
    ReportGender{i,2}=Results.Gender{i}.Type; 
    ReportGender{i,3}=mean(Results.Gender{i}.MAE); 
    ReportGender{i,4}=mean(Results.Gender{i}.StdMAE);
    ReportGender{i,5}=mean(Results.Gender{i}.ClassError);
    ReportGender{i,6}=Results.Gender{i};
    
    save ([obsFolder 'ReportGender.mat'], 'ReportAge');
    save ([obsFolder 'GenderNet.mat'], 'GenderNet');
    
end
