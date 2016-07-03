% @author Simon Reisinger
% calculates and returns all areas in the image in a certain interval
% image reprsents a binary image
function newMatrix = findareas(image)
    counter = 1;
    area = size(image,1) * size(image,2);

    % find all black Pixels
    findAllAreas = image;
    %[row,column] = find(findAllAreas == 0);
    [row,column] = findnextWhitePixel(findAllAreas, 1, 1);

    % iterates over all black pixels of the image
    while row > 0 %~isempty(row) %

        toBeAdded = imfill(findAllAreas,[row(1), column(1)],4);
        newColoredPixels = toBeAdded-findAllAreas;
        % sum fuer mindestgroesse
        amountOfPixel = sum(sum(newColoredPixels));
        % adds just the areas in a certain range
        if (amountOfPixel > area*0.0005 && amountOfPixel < area*0.5)
            newMatrix(:,:,counter) = newColoredPixels;
            counter = counter +1;
        end
        findAllAreas = toBeAdded;
        % updates the list of black pixel
        %[row,column] = find(findAllAreas == 0);
        [row,column] = findnextWhitePixel(findAllAreas, row, column);
    end
    if counter == 1
        newMatrix = zeros(0,0,0);
    end
end

% TODO implement this function in the algorithmn above
% Iterates over the image and trys to find and return the next black pixel
% image reprsents a binary image
% row, column are normale numbers between 1 and the width/height of the
% image
% returns row = -1, column = -1 if there is no black pixel left else the
% coordinates of this pixel
function [row, column] = findnextWhitePixel(image, row, column)
    rowStart = row;
    rowEnd = size(image,1);
    
    columnStart = column;
    columnEnd = size(image,2);
    
    found = false;
    
    while rowStart <= rowEnd && ~found
       while columnStart <= columnEnd && ~found
           if image(rowStart, columnStart) == 0
               found = true;
           end
           columnStart = columnStart + 1;
       end
       if ~found
           columnStart = 1;
       end
       rowStart = rowStart + 1;
    end
    
    row = -1;
    column = -1;
    
    if found
        row = row+rowStart;
        column = column+columnStart;
    end
end