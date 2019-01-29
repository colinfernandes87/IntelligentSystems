function [TestResult,net] = Func_FFNN(FileName,LabelType,Iter,Neurons) 
% Func_FFNN  Train & Test Feed Forward Neural Network. Outputs Structure
% and Trained Network
%   FeatureCat(dirFeatures,dirFeatSet,PreModel) 
%   FileName    --> Full File name with path of the Feature Set
%   LableType   --> Problem Type Either 'age' or 'gender'
%   Iter        --> No. of iterations
%   Neurons     --> No. of Neurons
%   Created by Colin Fernandes
%   See also FeatureCat.
    problem= load((FileName));
    nSamples = length(problem.(LabelType));
    for i = 1:Iter
        %Diving problem set to 10% testing and 90%Trainng 
        [trainI,testI]=crossvalind('HoldOut',nSamples,.1);
              
        %Training Set
        trainf = problem.p(:,trainI)';
        trainl = problem.(LabelType)(trainI);
        
        %Testing Set
        testf = problem.p(:,testI)';
        testl = problem.(LabelType)(testI);

        % create a neural network
        neuronsXLayer = [Neurons]; % number of neurons per layer
        neuronTransferFunction{1} = 'tansig';
        neuronTransferFunction{2} = 'tansig';
%         neuronTransferFunction{3} = 'tansig';
%         neuronTransferFunction{4} = 'tansig';

        net = feedforwardnet(neuronsXLayer,'trainscg');

        % training and testing data
        net.divideParam.trainRatio = 1; 
        net.divideParam.testRatio  = 0; 
        net.divideParam.valRatio   = 0;

        net.trainParam.epochs = 500;
        net.trainParam.goal = 0.01;

        for iL = 1: size(neuronsXLayer,2)
            net.layers{iL}.transferFcn = neuronTransferFunction{iL}; 
        end


        % train a neural network
        net = train(net,trainf',trainl');

        % test a neural network
        testResult = net(double(testf'));
        testResult= round(testResult);

        %Mean Absolute Error
        MAE(i,1)=sum(abs(testl-testResult'))/length(testResult);

        %Classification Error
        error(i,1)=nnz(testResult'==testl);
        ClassError(i,1)=(length(testl)-error(i,1))/length(testl)*100;
        SampleSize(i,1)=length(testl);
        %Test Results
        
        TestData(:,:,i) = [problem.filename(testI), num2cell(problem.(LabelType)(testI)) num2cell(testResult')];

        
    end
    
    TestResult.File=FileName;
    TestResult.Type=LabelType;
    TestResult.TestData=TestData;
    TestResult.MAE=MAE;
    TestResult.StdMAE=MAE;
    TestResult.SampleSize= SampleSize;
    TestResult.Error = error;
    TestResult.ClassError=ClassError;
    TestResult.StdClassError=ClassError;

end