% Returns the input image filtered with the kernel
% input:  2D - Matrix representing a gray image ~= null
% kernel: The filter kernel
% @auther: Simon Reisinger
% filters the image matrix input with the kernel
function [result] = imagefilter(input, kernel)
    S = size(input);
    kernelsize  = size(kernel);
    kernelrows  = kernelsize(1);
    kernelcolumn= kernelsize(2);
    kernelrowsmiddle  = floor(kernelsize(1)/2);
    kernelcolumnmiddle= floor(kernelsize(2)/2);
    
    result = zeros(S(1,1),S(1,2));
    temp = zeros(S(1,1)+2*kernelrowsmiddle,S(1,2)+2*kernelcolumnmiddle);
    temp(kernelrowsmiddle+1:end-kernelrowsmiddle,kernelcolumnmiddle+1:end-kernelcolumnmiddle,:) = ...
        input(:,:,:);

    tempChannel = zeros(S(1,1),S(1,2),kernelrows*kernelcolumn);
    % To improve performance it does not claculate the value for each pixel
    % of the image. It multiplies each pixel of the filter separately and
    % than moved and added. 
    for r=1:kernelrows
        for c=1:kernelcolumn
            tempChannel(:,:,(r-1)*kernelcolumn+c) = ...
                temp(r:end-kernelrows+r,c:end-kernelcolumn+c) * kernel(r,c);
        end
    end
    result(:,:) = sum(tempChannel, 3);
end