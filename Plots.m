%Colin Manuel Fernandes
%Universita Degli Studi Di Milano
%914777
%Intelligent Systems Project

%5: Plot all observations

clear all
close all
clc

matFiles='.\..\Observations\';
plotDir = '.\..\Observations\Plots\';
mkdir(plotDir);
load([matFiles 'ReportGender.mat']);
load([matFiles 'ReportAge.mat']);
load([matFiles 'Results.mat']);
    for i=1:length(ReportGender(:,1))
        filename=replace(ReportGender(i,1),'_pca500.mat','');
        %Load Gender Data
        G=Results.Gender{1, i}.TestData;
        G=reshape(permute(G,[2,1,3]),size(G,2),[])';
        figure('Name',[cell2mat(filename) ' Gender Classification'] ,'NumberTitle','off');
        h = histogram(abs(cell2mat(G(:,2))-cell2mat(G(:,3))));
        hold on
        xlabel({'Gender',['0: Correct' newline 'Rest: Wrong']})
        ylabel({'Images','(in thousands)'})
        hold off
        saveas(h,[plotDir cell2mat(filename) 'Gender.jpg']);


        %Load Age Data
        A=Results.Age{1, i}.TestData;
        A=reshape(permute(A,[2,1,3]),size(A,2),[])';
        figure('Name',[cell2mat(filename),'Age Classification'],'NumberTitle','off');
        plot(sort(abs(cell2mat(A(:,2))-cell2mat(A(:,3)))));
        hold on
        ylabel({'Age Difference','(in Years)'})        
        xlabel({'Images','(in thousands)'})
        hold off
        saveas(gcf,[plotDir cell2mat(filename) 'Age.jpg']);
    end
    
    close all
