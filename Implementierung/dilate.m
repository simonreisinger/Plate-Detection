% Dilation
% @author Simon Reisinger
% this function represents the dilation
% strongEdge: binary image
% se: binary filter
% strongEdgeOutput: Dilation adds pixels to the boundaries of objects in an image
% The number of pixels added or removed from the objects in an image depends
% on the size and shape of the structuring element se
function strongEdgeOutput = dilate(strongEdge, se)
    rsize = size(se,1);
    csize = size(se,2);
    strongEdgeOutput = strongEdge;
    for r = 1 : rsize
        for c = 1 : csize
            rl = ceil(rsize/2)-r;
            cl = ceil(csize/2)-c;
            if se(r,c) ~= 0
                startrl = rl; startrl(startrl < 0) = 0;
                endrl = rl; endrl(endrl > 0) = 0;
                startcl = cl; startcl(startcl < 0) = 0;
                endcl = cl; endcl(endcl > 0) = 0;
                empty1 = zeros(size(strongEdge));
                empty1(1-endrl:end-startrl,1-endcl:end-startcl) ...
                        = strongEdge(startrl+1:end+endrl,startcl+1:end+endcl);
                strongEdgeOutput = logical(strongEdgeOutput) | logical(empty1);
            end
        end
    end
end