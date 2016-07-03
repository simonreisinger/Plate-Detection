% Gaussian
% @author: Simon Reisinger
% creates Gaussian Filter with the size filterSize and the SiGMA
function gaus = gaussian(filterSize, SIGMA)
    xSize = (filterSize(1)-1)/2;
    ySize = (filterSize(2)-1)/2;
    % Gaussian distribution
    [x, y] = meshgrid(-ySize: ySize, -xSize : xSize);
    exponent = -(x.*x + y.*y)/(2*SIGMA*SIGMA);
    
    gaus = exp(exponent);
    total = sum(gaus(:));
    if total ~= 0
        gaus = gaus/total;
    end
end