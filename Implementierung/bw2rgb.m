% Wandelt ein Schwarzweiss Bild in ein Farbbild um.
% "kodierungstechnisch" natürlich nur um es als Farbbild verarbeiten zu
% können und nicht als eigenständiges Binärbild
% Author: Patrick Hromniak

function rgbPic = bw2rgb(bwPic)

bwPicSize = size(bwPic);

rgbPic = zeros(bwPicSize(1),bwPicSize(2),3);

rgbPic(bwPic==1)=255;
rgbPic(:,:,2) = rgbPic(:,:,1);
rgbPic(:,:,3) = rgbPic(:,:,1);

rgbPic = im2uint8(rgbPic);