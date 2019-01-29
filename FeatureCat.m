function FeatureCat(dirFeatures,dirFeatSet,PreFix)
% FeatureCat  Concatenate Features to a single Matlab file.
%   FeatureCat(dirFeatures,dirFeatSet,PreModel) 
%   dirFeatures--> Directory where Feature files are located
%   dirFeatSet --> Directory where Feature files are concatenated and saved
%   PreFix --> Prefix for the concatenated file
%   Created by Colin Fernandes
%   See also Func_FFNN.

    %dirImages='D:\Project\IntelligentSystems\Dataset\WIKI\FeaturesVggF\';
    files = dir([dirFeatures '*.mat']);
    j=0;
    
    for i =1:length(files)
        load(fullfile(files(i).folder,files(i).name), 'features');
        featName=files(i).name;
        spit=strsplit(featName,'_');
        if (length(spit) ==4 && (str2double(spit{2}) < 120 && str2double(spit{2}) > 0 && ~isnan(str2double(spit{2})) && ~isnan(str2double(spit{3}))))
            j=j+1;
            ID(j,1) =str2double(spit{1});
            age(j,:) =str2double(spit{2});
            gender(j,:) = str2double(spit{3});
            templateName{j,:} = replace(featName,'-features.mat','');
            VGGfeatures(j,:) = features;        
        end

    end
    
    FeatSet.filename = templateName;
    FeatSet.p = VGGfeatures;
    FeatSet.t = (ID);
    FeatSet.age=(age);
    FeatSet.gender=(gender);
   

    save ([dirFeatSet PreFix '_FeatureSet.mat'] , '-struct', 'FeatSet');
    clear features;

end   