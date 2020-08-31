close all;

filename = 'bird2.png';

f = double(imread(filename))/255;
figure; imshow(f,[]);
title('Image originale');
f = rgb2gray(f);
figure; imshow(f,[]);
title('Image noire et blanche');

% gradient original
G = grad(f,1);
% figure; imshow(G,[]);

% blurred image
sigma0 = 1;%2.25;
fblur = imgaussfilt(f,sigma0);
% figure; imshow(fblur,[]);

% gradient of blurred image
Gblur = grad(fblur,1);
% figure; imshow(Gblur,[]);

% use a Canny to detect the edges
edges = edge(f,'Canny');
% figure; imshow(edges);


% calculate R = ratio of gradients
R = abs(G)./abs(Gblur);
R = R.*edges;

% original defocus blur estimation
sigma = real(1./sqrt(R.^2-1).*sigma0);
% figure; imshow(sigma,[]);

%%
% sigmaS = 15;
sigmaS = std2(sigma);
% sigmaS = 1;
n = floor(min(size(sigma))*.1+1)+1-mod(floor(min(size(sigma))*.1+1),2);
sigmaR = (max(sigma(:))-min(sigma(:)))*0.1;
% sigmaR = std2(f);
% sigmaR = 0.2;
% joint bilateral filtering
sigma = bfilter2(sigma,f,n,sigmaS,sigmaR);
sigma = double(sigma)/255;
figure; imshow(sigma,[]);
title('Défocalisation aux bords');

%%
sigma = sparse(sigma(:)); % vectorized defocus blur amount

% defocus map interpolation from 
L = getLaplacian1(f,edges); % get laplacian matrix

lambda = .005;
edges = sparse(edges);
D = diag(edges(:));

% we solve the system
B = lambda*D*sigma;
A = L+lambda*D;
defocus_map = A\B;


map = reshape(full(defocus_map),size(f));
figure; imshow(map,[]);
title('Carte de défocalisation');

%%

% image segmentation : foreground and background
level = graythresh(map);
% level = 0.8;
segThresh = segment1(map,level);


figure; imshow((1-segThresh).*f,[]);
title('Objet en premier plan');
figure; imshow(segThresh.*f,[]);
title('Arrière-plan');

%%
% sigma_rendu = 10;
% f_couleur = double(imread('bird2.png'));
% RGB = cat(3, f_couleur(:,:,1).*segThresh, f_couleur(:,:,2).*segThresh, f_couleur(:,:,3).*segThresh);
% figure; imshow(RGB_IM, []);
% f_fond = imgaussfilt(segThresh.*f,sigma_rendu)
% f_fond = SV_blur(map,segThresh.*f);
% f_rendu = f_fond + (1-segThresh).*f ;
% figure; imshow(f_rendu, []);

% background reblurring

f_fond = SV_blur(map,segThresh.*f);
f_rendu = segThresh.*f_fond + (1-segThresh).*f ;
figure; imshow(f_rendu, []);
title('Accentuation du flou en arrière-plan');

%%

% colored foreground
f_couleur = double(imread(filename))/255;
objet_r = f_couleur(:,:,1).*(1-segThresh);
objet_g = f_couleur(:,:,2).*(1-segThresh);
objet_b = f_couleur(:,:,3).*(1-segThresh);
objet = cat(3,objet_r,objet_g,objet_b);
figure; imshow(objet,[]);
title('Objet en premier plan');







