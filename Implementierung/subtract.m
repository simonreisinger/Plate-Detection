% Invertiert ein Bild anhand einem gegebenen Binärbild
% Author: Patrick Hromniak

function img = subtract(original,binary)
%original = imread(original);
%binary = im2bw(imread(binary));
binaryn = im2bw(binary);
binaryn = imfill(binaryn,'holes');
binaryn = imcomplement(binaryn);
binaryn = bw2rgb(binaryn);
X = imsubtract(original,binaryn);
X = crop_img(X);
img = X;
end
