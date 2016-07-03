% Transformes the content in the square of the given points to a rectangle
% @author: Michael Pointer
function [imageDestination, euroTestPassed, marker] = geometricTransformation(image, p, destinationWidth, destinationHeight)

    marker = p;

    p1 = p(1,:).';
    p2 = p(2,:).';
    p3 = p(3,:).';
    p4 = p(4,:).';

    % Get size of the input image
    sizeI = size(image);
    sourceWidth = sizeI(2);
    sourceHeight = sizeI(1);
    
    % Corrects the order of the points, so the image doesnt appear rotated
    [p1, p2, p3, p4] = rotatePoints(p1, p2, p3, p4);

    % Pixel x and y coordinates go from 1 to width/height
    % Transform the coordinate into the intervall (0, 1]
    x1 = p1(1)/sourceWidth; y1 = p1(2)/sourceHeight;
    x2 = p2(1)/sourceWidth; y2 = p2(2)/sourceHeight;
    x3 = p3(1)/sourceWidth; y3 = p3(2)/sourceHeight;
    x4 = p4(1)/sourceWidth; y4 = p4(2)/sourceHeight;

    % Get transformation matrix for given Points
    transMatrix = calcGeometricTransformationMatrix(x1,y1,x2,y2,x3,y3,x4,y4);

    imageDestination = calcOutputImage(image, transMatrix, 0, destinationWidth, destinationHeight, sourceWidth, sourceHeight);
    
    imageDestination = blackWhiteLevel(imageDestination);
    
    % The euro symbol area should be 8 percent of the width of the hole
    % plate
    f = 0.08;
    
    euroTestPassed = true;
    
    % Euro area not in the image
    [euroTest1Passed, color1] = euroTest(imageDestination, destinationWidth, destinationHeight, f);
    if (~euroTest1Passed)
        
        % Offset for the new search area
        offset = round(destinationWidth * f / (1-f));
        
        % Transform the image again with the new offset
        imageDestination = calcOutputImage(image, transMatrix, offset, destinationWidth, destinationHeight, sourceWidth, sourceHeight);
    
        imageDestination = blackWhiteLevel(imageDestination);
        
        % Calculate the new markers of the vertices of the square
        marker = calcMarker(transMatrix, offset, destinationWidth, destinationHeight, sourceWidth, sourceHeight);
        
        [euroTest2Passed, color2] = euroTest(imageDestination, destinationWidth, destinationHeight, f);
        if(~euroTest2Passed)
            euroTestPassed = false;
        end
    end
end

% Calculate the new markers of the vertices of the square
function marker = calcMarker(transMatrix, offset, destinationWidth, destinationHeight, sourceWidth, sourceHeight)
    [px1, py1] = calcPoint(1-offset, 1, transMatrix, offset, destinationWidth, destinationHeight, sourceWidth, sourceHeight);
    [px2, py2] = calcPoint(destinationWidth-offset, 1, transMatrix, offset, destinationWidth, destinationHeight, sourceWidth, sourceHeight);
    [px3, py3] = calcPoint(destinationWidth-offset, destinationHeight, transMatrix, offset, destinationWidth, destinationHeight, sourceWidth, sourceHeight);
    [px4, py4] = calcPoint(1-offset, destinationHeight, transMatrix, offset, destinationWidth, destinationHeight, sourceWidth, sourceHeight);
    
    marker = [px1, py1; px2, py2; px3, py3; px4, py4];
end

% Changes the colors so they use the hole range
function result = blackWhiteLevel(image)
    maxV = max(image(:));
    minV = min(image(:));
    result = (image - minV) ./ (maxV - minV);
end

% Calculates the new output image
function [imageDestination] = calcOutputImage(image, transMatrix, offset, destinationWidth, destinationHeight, sourceWidth, sourceHeight)

    % Create empty output image of given size
    imageDestination = zeros(destinationHeight, destinationWidth, 3);

    % Iterate over output image to fill each pixel
    for x=(1-offset):destinationWidth-offset
        for y=1:destinationHeight
            
            
            [px, py] = calcPoint(x, y, transMatrix, offset, destinationWidth, destinationHeight, sourceWidth, sourceHeight) ;

            % Interpolate the neighbor pixels and 
            % set the color in the output image
            if (px < 1 || py < 1 || px > sourceWidth || py > sourceHeight)
                color = 0;
            else
                color = interpolation(image, px, py);
            end
            imageDestination(y, x + offset, :) = color;
        end
    end
end

% Calculates the position of a point in the other image
function [px, py] = calcPoint(x, y, transMatrix, offset, destinationWidth, destinationHeight, sourceWidth, sourceHeight) 
    
    % Take middle of each pixel to get exact results
    % 1 for homogene coordinate
    p = [(x-0.5)/(destinationWidth-offset); (y-0.5)/destinationHeight; 1];

    % Transform the point into the original image coordinate system
    pnew = transMatrix * p;

    % Geometric transformation modifies the homogene coordinate,
    % so we have to devide throw it
    h = pnew(3);
    pnew = [pnew(1)/h, pnew(2)/h];

    % Scale point pnew to the size of the source image
    px = pnew(1)*sourceWidth;
    py = pnew(2)*sourceHeight;

end
