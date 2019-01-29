%Colin Manuel Fernandes
%Universita Degli Studi Di Milano
%914777
%Intelligent Systems Project

%1:Cropping Face form Image and rename with Age and Gender

clear all
close all
clc

DatasetDir = dir('.\..\DataSet\');
mkdir(DatasetDir);
%DatasetDir = dir('D:\Project\IntelligentSystems\Dataset\WIKI\wiki\wiki_crop_input\');
folderOut = '.\..\CroppedImages\';
mkdir(folderOut);

%Load Matlab file
%download the .mat and images(WIKI only 'Download faces only(1 GB)') from
%below url save mat files and unziped sub directories in respective folders
%mentioned above
%https://data.vision.ee.ethz.ch/cvl/rrothe/imdb-wiki/
load '.\..\DataSet\wiki.mat';

%Loop through Matfile
for i = 1:length(wiki.full_path)
   
    fPath = wiki.full_path{i};
    fullPath = [DatasetDir(1).folder '\' replace(fPath,'/','\')];
    im = imread(fullPath);
   
    dob= strsplit(datestr(wiki.dob(i)),'-');
    age(i,1)= wiki.photo_taken(i)- str2num(dob{3});
    gender(i,1)= wiki.gender(i);
    name = strsplit(replace(fPath,'/','_'),'_');
    id(i) = str2num(name{2});
    
    %Crop Face using the faceLoaction point in the wiki.Mat file
    %Most location is wrong so we discard it
    %I1=imcrop(im,cell2mat(wiki.face_location(1)));
    
    %Code borrowed from below link
    %https://in.mathworks.com/matlabcentral/answers/73057-how-to-crop-a-detected-face-and-face-parts-and-save-them-as-separate-images
    % Create a cascade detector object.
    faceDetector = vision.CascadeObjectDetector();    
    %faceDetector.MergeThreshold = 7 % Keep Default to 4
    
    % locate Face and put bounding box.
    bbox= step(faceDetector, im);

    if (isempty(bbox)==0)

        if (size(bbox,1)~=1)
            bbox = bbox(end,:);
        end    
        
        % Draw the returned bounding box around the detected face.
        %DetetedImage = insertObjectAnnotation(im,'rectangle',bbox,'Face');
        %figure, imshow(DetetedImage), title('Detected face');
        %close
        
        %Crop Image based on bbox
        CroppedImage = imcrop(im,bbox);

        if (isempty(CroppedImage)==0)
            imName = [num2str(id(i)) '_' num2str(age(i,1)) '_' num2str(gender(i,1)) '_im.jpg'];
            imwrite(CroppedImage,[folderOut '\' imName]);
            clear im
        end       
    end
end