% Closes one pixel holes in the image in horizontal, diagonal and vertical
% direction
% author: Michael Pointner
function image = closeOnePixelHoles(image)
    sizeImage = size(image);
    
    % Inverted origin image
    zerosImage = ~image;
    
    % Right pixels
    rightImage = zeros(sizeImage);
    rightImage(:, 1:end-1) = image(:, 2:end);
    % Left pixels
    leftImage = zeros(sizeImage);
    leftImage(:,2:end) = image(:, 1:end-1);
    
    corrHorizontal = zerosImage & rightImage & leftImage;
    
    % Left down pixels
    leftDownImage = zeros(sizeImage);
    leftDownImage(1:end-1, 2:end) = image(2:end, 1:end-1);
    
    corrHorizontalDiagonalLeft = zerosImage & rightImage & leftDownImage;
    
    % Right down pixels
    rightDownImage = zeros(sizeImage);
    rightDownImage(1:end-1, 1:end-1) = image(2:end, 2:end);
    
    corrHorizontalDiagonalRight = zerosImage & leftImage & rightDownImage;
    
    % Up pixels
    upImage = zeros(sizeImage);
    upImage(2:end, 1:end) = image(1:end-1, 1:end);
    % Down pixels
    downImage = zeros(sizeImage);
    downImage(1:end-1, 1:end) = image(2:end, 1:end);
    
    corrVertical = zerosImage & upImage & downImage;
    
    image = image | corrHorizontal | corrHorizontalDiagonalLeft | corrHorizontalDiagonalRight | corrVertical;
end