% Non Maximum Suppression
% @author: Simon Reisinger
% This function represents the non maximum suppression of the canny
% Algorithm
% G is the Matrix of the edge image - this egdes will be "thined"
% theta is a matrix which contains the direction of each edge
% 
% This function test for each pixel if on pixel orthogonal to the edge
% direction has a higher value. If so the pixel is set to zero else to one
% returns a filter for G which just contains the maxima of each edge
%
% To avoid loops we do not calculate the Maxima for each pixel individually
% but we calculate the values for each matrix and than move them so that
% all neighbor pixel of a pixel in G lie directly above the position of the
% pixel in G and compare which one the highest values has.
function edgesPositionX = nonMaximumSuppression(G, theta)
    rsize = 3;
    csize = 3;
    maxP = zeros(size(G));
    
    for r = 1:rsize
        for c = 1:csize
            rl = ceil(rsize/2)-r;
            cl = ceil(csize/2)-c;
            if rl ~= 0 || cl ~= 0
            % it is not nessesary to compare one matrix to itself
                % calculate the new Position of the matrix
                startrl = rl; startrl(startrl < 0) = 0;
                endrl = rl; endrl(endrl > 0) = 0;
                startcl = cl; startcl(startcl < 0) = 0;
                endcl = cl; endcl(endcl > 0) = 0;
                compare = zeros(size(G));
                compare(1-endrl:end-startrl,1-endcl:end-startcl) ...
                        = G(startrl+1:end+endrl,startcl+1:end+endcl);
                % compare the matrx to the orginal matrix
                isHigher = G - compare;
                empty2 = zeros(size(G));
                empty2(isHigher >= 0) = 1;
                empty2(isHigher <  0) = 0;
                maxP(:,:,(r-1)*csize+c) = empty2;
            else
                maxP(:,:,(r-1)*csize+c) = zeros(size(G));
            end
        end
    end
    
    % calculate the maxima for each of the four directions
    diagonal1  = logical(maxP(:,:,1)) & logical(maxP(:,:,9));
    vertical   = logical(maxP(:,:,2)) & logical(maxP(:,:,8));
    diagonal2  = logical(maxP(:,:,3)) & logical(maxP(:,:,7));
    horizontal = logical(maxP(:,:,4)) & logical(maxP(:,:,6));

    edgesPositionX = zeros(size(G));
    
    % just takes the values where the edge direction is correct
    edgesPositionX(theta == 0.00 * pi) =   vertical(theta == 0.00 * pi);
    edgesPositionX(theta == 0.25 * pi) =  diagonal1(theta == 0.25 * pi);
    edgesPositionX(theta == 0.50 * pi) = horizontal(theta == 0.50 * pi);
    edgesPositionX(theta == 0.75 * pi) =  diagonal2(theta == 0.75 * pi);
end
