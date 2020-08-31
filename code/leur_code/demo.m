%% read the input image
close all,clear all;
I=im2double(imread('input.png'));

%% get edge map
% Canny edge detector is used here. Other edge detectors can also be used
eth=0.1; % thershold for canny edge detector
edgeMap=edge(rgb2gray(I),'canny',eth,1);

%% estimate the defocus map
std=1;
lambda=0.005;
maxBlur=3;
tic; % about 1 mins for a 800x600 image
[sDMap, fDmap] = defocusEstimation(I,edgeMap,std,lambda,maxBlur);
toc;

%% end of their code

% segmentation : background and foreground
level = graythresh(fDmap);
segThresh = segment1(fDmap,level);
seuil1 = fDmap >= 1;


figure; imshow(I,[]);
title('Image originale');
figure; imshow(fDmap,[0 maxBlur]);
title('Carte de d�focalisation');
figure; imshow(I.*(1-seuil1),[]);
% figure; imshow(I.*(1-segThresh),[]);
title('Objet en premier plan');

% background reblurring - B&W
Ibw = rgb2gray(I);
f_fond = SV_blur(fDmap,segThresh.*Ibw,9);
f_rendu = segThresh.*f_fond + (1-segThresh).*Ibw ;
figure; imshow(f_rendu, []);
title('Accentuation du flou en arri�re-plan');

% background reblurring - color
fondR = SV_blur(fDmap,I(:,:,1),15);
fondG = SV_blur(fDmap,I(:,:,2),15);
fondB = SV_blur(fDmap,I(:,:,3),15);

% color image
fond = cat(3,seuil1,seuil1,seuil1).*cat(3,fondR,fondG,fondB);
objet = (ones(size(I))-cat(3,seuil1,seuil1,seuil1)).*I;

newI = fond+objet;
figure; imshow(newI,[]);
title('Accentuation du flou');



