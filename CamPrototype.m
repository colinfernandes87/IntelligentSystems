%Colin Manuel Fernandes
%Universita Degli Studi Di Milano
%914777
%Intelligent Systems Project

%Prototype of Working application on live Feed captured using Webcam

clear all
close all
%Load trained FFNN for Age & Gender
load('.\..\Observations\Total Features\AgeNet.mat') ;
load('.\..\Observations\Total Features\GenderNet.mat') ;
%Load pretrained cnn
cnnMatFile = '.\..\CNN_Models\VggFace\vgg-face.mat';
%Run MatConvNet
run '.\..\Matconvonet\matconvnet-1.0-beta25\matconvnet-1.0-beta25\matconvnet-1.0-beta25\matlab\vl_setupnn'
net = load(cnnMatFile) ;
faceDetector = vision.CascadeObjectDetector(); 
camera=webcam;
age=0;
frame=10;
gender='';
runLoop = true;
%Loop Until the figure window is closed
while runLoop 
    picture=camera.snapshot;
    %Detect Face and crop
    bbox= step(faceDetector, picture);
    if (isempty(bbox)==0)
        if (size(bbox,1)~=1)
            bbox = bbox(end,:);
        end
        CroppedImage = imcrop(picture,bbox);
        if (isempty(CroppedImage)==0)
            %Resize the image to input dimension of VGG face
            im_ = single(CroppedImage) ; % note: 255 range
            im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
            im_ = bsxfun(@minus,im_,net.meta.normalization.averageImage) ;
            %Extract Features from the cropped and captured image
            res = vl_simplenn(net, im_) ;
            features = squeeze(res(33).x);    
            features = features./norm(features,2);
            %Classify with the Trained models of FFNN's
            age = round(AgeNet(double(features)));
            gender = round(GenderNet(double(features)));
            if gender==1
                disp='Male';
            elseif gender==0
                disp='Female';
            else
                disp='';
            end
        end       
    end
    try
        %Display in Figure window with title as Age and Gender
        imshow(picture),title(['Age: ' int2str(age) ' Gender:' disp]);
    catch
        warning('Contact Colin Fernandes in Case of issues');
        runLoop=false;
        close all
    end
    drawnow;
end
clear camera;
close all