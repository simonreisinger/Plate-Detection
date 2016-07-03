% Tests if the image contains a blue euro symbol area
% author: Michael Pointner
function [result, color] = euroTest(image, destinationWidth, destinationHeight, f)

    % Search area for Euro Symbol
    imageEuro = image((destinationHeight*0.25):(destinationHeight*0.75),(destinationWidth*f*0.25):(destinationWidth*f*0.75),:);
    %figure, imshow(imageEuro);
    
    sizeE = size(imageEuro);
    count = sizeE(1)*sizeE(2);
    
    % Get color channel mean
    red = sum(sum(imageEuro(:,:,1))) / count;
    green = sum(sum(imageEuro(:,:,2))) / count;
    blue = sum(sum(imageEuro(:,:,3))) / count;
    
    color = [red, green, blue];
    
    % Test difference of channels
    if(red + 0.10 <= blue && green < blue)
        result = true;
    else
        result = false;
    end
end
