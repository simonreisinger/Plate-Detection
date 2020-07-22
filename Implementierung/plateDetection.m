%{
Aufruf der Funktion via Kommando plateDetection('filename.png');
Es gibt zwei OPTIONALE Parameter:
ownCanny: Gibt an, ob Simons Canny-Filter statt dem von Matlab verwendet
werden soll. Default-Wert: true
colorCheck: Gibt an, ob Patricks Farbpruefung aktiviert werden
soll. Default-Wert: false
debugFlag: Wenn true, werden zusaetzliche Debug-Informationen angezeigt
(Algorithmus kann dadurch laenger dauern, da fuer alle viereckigen Objekte
alle restlichen Pruefungen durchgefuehrt werden). Default-Wert: false

Autoren: Hauptsaechlich Reisinger und Pointner, Ergaenzungen durch alle
Mitglieder
%}
function imgOutput = plateDetection(filename, ownCanny, colorCheck, debugFlag)

    if ~exist('debugFlag')
        debugFlag = false;
    end
    if ~exist('colorCheck')
        colorCheck = false;
    end
    if ~exist('ownCanny')
        ownCanny = true;
    end

    imgOrg = imread(filename);

    % Resizing
    widthResized = 1200;
    sizeOrg = size(imgOrg);
    resizeFactor = 1;
    if sizeOrg(2) > widthResized
        resizeFactor = sizeOrg(2) / widthResized;
        factor = sizeOrg(1) / sizeOrg(2);
        img = imresize(imgOrg, [widthResized*factor, widthResized]);
    else
        img = imgOrg;
    end

    % Convert to gray
    gray = rgb2gray(img);
    if (ownCanny)
        gray = im2double(gray); % TODO read here @michi
        % Canny
        canny = cannyalgorithmn(gray);
        % Schliessen von kleinen Loechern
        canny = closeOnePixelHoles(canny);
    else
        canny = edge(gray, 'canny');
    end

    % Fuellen aller Flaechen
    newMatrix = findareas(canny);

    dimensions = size(newMatrix, 3);

    % Initialising
    bd = 10;
    plateSize = [100, 400];
    outputSize = size(img);
    imgOutput(1:outputSize(1),1:outputSize(2),:) = im2double(img);
    imgOutput(1:outputSize(1),outputSize(2)+1:outputSize(2)+plateSize(2)+2*bd,:) = ones(outputSize(1),plateSize(2)+2*bd,3);
    plateCount = 0;
    outputMarkerCount = 0;

    for i = 1: dimensions
        % Find areas in area
        numberPlateWithHoles = newMatrix(:,:,i);
        numberPlateWithoutHoles = imfill(newMatrix(:,:,i), 'holes');
        holes = (numberPlateWithoutHoles) -(numberPlateWithHoles);
        % Without holes it is no plate
        numberHoles = sum(sum(holes));
        if numberHoles ~= 0
            % Testsingle from SMF
            image = newMatrix(:,:,i);
            result = checkQuad(image);
            if (result ~= false)
                % Histogrammcheck
                if (colorCheck)
                    val = makeHistograms(img,numberPlateWithHoles);
                else
                    val = 1;
                end
                if(debugFlag || val > 0)

                    % Geometric Transformation
                    p = round(result .* resizeFactor);
                    [imageTransformed, euroTestPassed, marker] = geometricTransformation(im2double(imgOrg), p, plateSize(1,2), plateSize(1,1));

                    if(debugFlag || euroTestPassed == true)
                        plateCRpassed = plateCR(imageTransformed);
                        if(debugFlag || plateCR(imageTransformed))

                            if(debugFlag)
                                text_str = cell(3,1);
                                box_color = {'green','green','green'};
                                if(val > 0) text_str{1} = ['HistogramTest: passed'];
                                else text_str{1} = ['Histogram: failed']; box_color(1) = {'red'}; end
                                if(euroTestPassed == true) text_str{2} = ['EuroTest: passed'];
                                else text_str{2} = ['EuroTest: failed']; box_color(2) = {'red'}; end
                                if(plateCRpassed == true) text_str{3} = ['PlateCRTest: passed'];
                                else text_str{3} = ['PlateCRTest: failed']; box_color(3) = {'red'}; end

                                position = [1 1;1 30;1 60];
                                imageTransformed = insertText(imageTransformed,position,text_str,'FontSize',18,'BoxColor',box_color,'BoxOpacity',0.4,'TextColor','black');
                            end

                            % Speichern der transformierten Marker
                            marker = round(marker ./ resizeFactor);
                            mSize = size(marker);
                            outputMarker(outputMarkerCount+1:outputMarkerCount+mSize(1),1:2) = marker(:,:);
                            outputMarkerCount = outputMarkerCount + mSize(1);

                            % Hinzufuegen des Nummernschildes zum Ausgabebild
                            transSize = size(imageTransformed);
                            imgOutput(plateCount*(transSize(1)+bd)+1+bd:(plateCount+1)*(transSize(1)+bd),outputSize(2)+1+bd:outputSize(2)+transSize(2)+bd,1:3) = imageTransformed(:,:,:);
                            plateCount = plateCount + 1;
                        end
                    end
                end
            end
        end
    end

    if(debugFlag)

        areasSize = [size(newMatrix, 1), size(newMatrix, 2), size(newMatrix, 3)];
        areas = zeros(areasSize(1), areasSize(2));

        for i = 1:dimensions
            areas = areas + (newMatrix(:,:,i) .* i ./ dimensions);
        end

        areas = repmat(areas, 1, 1, 3);
        areas = imresize(areas, [plateSize(2)*areasSize(1)/areasSize(2), plateSize(2)]);
        areasSize = size(areas);

        cannySize = size(canny);
        canny = repmat(canny, 1, 1, 3);
        cannySize = size(canny);

        imgOutput(plateCount*(plateSize(1)+bd)+1+bd:(plateCount+1)*(plateSize(1)+bd)+(areasSize(1)-plateSize(1)), outputSize(2)+1+bd:outputSize(2)+plateSize(2)+bd, 1:3) = areas(:,:,:);

        imgOutput(1:cannySize(1), outputSize(2)+1+2*bd+plateSize(2):outputSize(2)+cannySize(2)+plateSize(2)+2*bd, 1:3) = canny(:,:,:);
    end

    if(outputMarkerCount > 0)
        imgOutput = insertMarker(imgOutput, outputMarker, 'x', 'color', 'red', 'size', 10);
    end
end
