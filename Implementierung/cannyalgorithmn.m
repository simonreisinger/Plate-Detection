% Canny Filter
% this class represents the Canny Algorithm
% img: a Matrix of a gray Image with double Values in the interval[0,1]
% img ~= null
% returns image: A edge image: 1 represents edges, everything else: 0
% @author: Simon Reisinger
% 
function image = cannyalgorithmn(img)

    % 1) Apply Gaussian filter to smooth the image in order to remove the noise
    gaus = gaussian([3 ,3],0.5);
    img = imagefilter(img, gaus);

    % 2) Find the intensity gradients of the image
    gx = [1,4,6,4,1;0,0,0,0,0;-1,-4,-6,-4,-1]/16;
    gy = gx';
    x = imagefilter(img, gx);
    y = imagefilter(img, gy);
    
    theta = atan2(y,x);
    theta((theta >=      0.0 & theta <= pi*0.125) | (theta > pi*0.875 & theta <= pi)) = 0;
    theta((theta > pi*0.125 & theta <= pi*0.375)) = 0.25 * pi;
    theta((theta > pi*0.375 & theta <= pi*0.625)) = 0.5 * pi;
    theta((theta > pi*0.625 & theta <= pi*0.875)) = 0.75 * pi;

    theta((theta <       0.0 & theta >= -pi*0.125) | (theta < -pi*0.875 & theta >= -pi)) = 0;
    theta((theta < -pi*0.125 & theta >= -pi*0.375)) = 0.75 * pi;
    theta((theta < -pi*0.375 & theta >= -pi*0.625)) = 0.5  * pi;
    theta((theta < -pi*0.625 & theta >= -pi*0.875)) = 0.25 * pi; 
    
    % absolute egde strength
    G = sqrt(x .* x + y .* y);

    % 3) Apply non-maximum suppression to get rid of spurious response to edge detection
    edgesPosition = nonMaximumSuppression(G, theta);
    G = edgesPosition .* G;

    % 4) Apply double threshold to determine potential edges Track
    % Finalize the detection of edges by suppressing all the other edges
    % that are weak and not connected to strong edges.
    highThreshold = 0.05;
    lowThreshold = 0.03;
    strongEdge = G;
    strongEdge(strongEdge < highThreshold) = 0;
    strongEdge(strongEdge >= highThreshold) = 1; 

    % Structuring element
    se = [1,1,1;1,1,1;1,1,1];
    strongEdge = dilate(strongEdge, se);
    weakEdge = G;
    weakEdge(G < lowThreshold) = 0;
    % Puts a Mask over the pixels,
    % Just the pixels next to a stronge edgeleft
    weakEdge(~strongEdge) = 0;
    weakEdge(weakEdge > 0) = 1;
    weakEdge(weakEdge <= 0) = 0;
    
    image = logical(weakEdge);
end
