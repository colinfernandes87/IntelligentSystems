%Colin Manuel Fernandes
%Universita Degli Studi Di Milano
%914777
%Intelligent Systems Project

%3:Building ProblemSet using Extracted Feature & Reducing corellated
%features to 500

clear all
close all
clc

%Directory of Features
dirFeatures='.\..\ImageFeatures\';

%Directory of Concatenated Features Set
dirFeatSet='.\..\FeaturesSet\';
mkdir(dirFeatSet);

%UDF to concatenate Feature set
FeatureCat(dirFeatures,dirFeatSet,'VggFace')

files = dir([dirFeatSet '*_FeatureSet.mat']);

for i =1:length(files)
    
    FeatSet = load(fullfile(files(i).folder,files(i).name));    
    preFix = replace(files(i).name,'_FeatureSet.mat','');
    
    %apply PCA
    [coeff, score]=pca(FeatSet.p);
    %pca500=coeff(1:500,:)*FeatSet.p';
    
    %keep only 500 Features
    pca500 = score(:,1:500);
    FeatSet.p=pca500;
    
    save ([dirFeatSet preFix '_pca500'],'-struct', 'FeatSet');
    
    clear FeatSet
    clear pca500
    
end


