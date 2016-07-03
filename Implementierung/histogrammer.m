% Generiert ein Histogramm bezüglich einem gegebenen Bild
% Kann einerseits dazu verwendet werden Bilder graphisch zu analyisieren
% oder um Testdatensätze zu generieren
%
%
% Author: Patrick Hromniak

function [histR, histG, histB] =  histogrammer(x)
figure;
rgbImage = imread(x);
%kontrast beeinflussen
%rgbImage = imadjust(rgbImage,[.7 .7 0; .8 .8 1],[]);
fontSize = 10;
[rows, columns, numberOfColorBands] = size(rgbImage);
subplot(3, 3, 1);
imshow(rgbImage, []);
title('Kennzeichen / Rechteck', 'Fontsize', fontSize);
set(gcf, 'Position', get(0,'Screensize')); 

redPlane = rgbImage(:, :, 1);
greenPlane = rgbImage(:, :, 2);
bluePlane = rgbImage(:, :, 3);

[pixelCountR, grayLevelsR] = imhist(redPlane);
subplot(3, 3, 2);
plot(pixelCountR, 'r');
title('Rotkanal', 'Fontsize', fontSize);
xlim([0 grayLevelsR(end)]); 

[pixelCountG, grayLevelsG] = imhist(greenPlane);
subplot(3, 3, 3);
plot(pixelCountG, 'g');
title('Grünkanal', 'Fontsize', fontSize);
xlim([0 grayLevelsG(end)]); 

[pixelCountB, grayLevelsB] = imhist(bluePlane);
subplot(3, 3, 4);
plot(pixelCountB, 'b');
title('Blaukanal', 'Fontsize', fontSize);
xlim([0 grayLevelsB(end)]); 

[rows, columns, numberOfColorBands] = size(rgbImage);
gray_kennzeichen = rgbImage(:, :, 2); 
subplot(3, 3, 5);
title('BW Histogram', 'Fontsize', fontSize);
imhist(gray_kennzeichen);

[rows, columns, numberOfColorBands] = size(rgbImage);
gray_kennzeichen = rgbImage(:, :, 2); 
gray_kennzeichen = histeq(gray_kennzeichen);
subplot(3, 3, 6);
title('Equalisiertes BW Histogram', 'Fontsize', fontSize);
imhist(gray_kennzeichen);

histR = pixelCountR;
histG = pixelCountG;
histB = pixelCountB;
end

