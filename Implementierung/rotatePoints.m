% Corrects the order of the points, so the image doesnt appear rotated
% @author: Michael Pointner
function [newp1, newp2, newp3, newp4] = rotatePoints(p1, p2, p3, p4)
    
    p = [p1, p2, p3, p4];

    % Get nearest point of Point 1 (shortest side of the square)
    p1NP = 2;
    d1NP = distance(p1, p2);
    for i = 3:4
        d = distance(p1, p(:,i));
        if (d < d1NP)
            p1NP = i;
            d1NP = d;
        end
    end
    
    % Calculate the second shortest side of the square
    nP1 = [1, p1NP];
    nP2 = [3, 4];
    if(p1NP == 3)
        nP2 = [2, 4];
    end
    if(p1NP == 4)
        nP2 = [2, 3];
    end
    
    % change in y coordinate is in incorrect order
    if(p(2, nP1(1)) > p(2, nP1(2)))
        nP1 = [nP1(2), nP1(1)];
    end
    if(p(2, nP2(1)) > p(2, nP2(2)))
        nP2 = [nP2(2), nP2(1)];
    end
    
    % change points on x coordinate
    if(middleX(p(:, nP2(1)), p(:, nP2(2))) < middleX(p(:, nP1(1)), p(:, nP1(2))))
        temp = nP1;
        nP1 = nP2;
        nP2 = temp;
    end
    
    newp1 = p(:, nP1(1));
    newp2 = p(:, nP2(1));
    newp3 = p(:, nP2(2));
    newp4 = p(:, nP1(2));
    
end

% Calculates the arithmetic distance
function d = distance(p1, p2)
    d = sqrt((p1(1)-p2(1))^2 + (p1(2)-p2(2))^2);
end

% Calculates the middle x value of 2 points
function m = middleX(p1, p2)
    m = (p1(1) + p2(1)) / 2;
end
