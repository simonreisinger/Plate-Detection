%{
Vierecks-Prüfungs-Funktion
Autor: Simon Fraiss
Diese Funktion erhält als Parameter ein Binärbild, welches eine gefüllte
Fläche enthält. Die Funktion prüft, ob es sich bei diesem Objekt um ein
Viereck handelt, und gibt bei erfolgreicher Prüfung die vier Eckpunkte
zurück.
Wurde festgestellt, dass das Objekt ausgesprochen "unkonvex" ist (was bei
Nummernschildern nicht der Fall sein sollte), wird false zurückgegeben 
(wird nicht unbedingt immer bemerkt).
Werden weniger oder mehr als 4 Ecken entdeckt, wird false zurückgegeben.
Wurden 4 Ecken gefunden, deren Verbindungslinien einen Großteil des 
Objektes (mind. 30%) nicht einschließen, wird false zurückgegeben.

Einige Schwell- und Glättwerte wurden empirisch so festgelegt, dass sie
möglichst gute Ergebnisse erzielen. In Einzelfällen kann es natürlich sein,
dass sie nicht ideal sind. In den meisten Fällen funktioniert der
Algorithmus aber gut.

Eine zusätzliche Verbesserungsmöglichkeit wäre bei mehr als 4 Punkten noch 
zu prüfen, ob einer der Punkte auf einer Gerade zwischen den zwei anderen 
Punkten liegt. So können unnötige Kanten-Punkte eliminiert werden. Scheint
derzeit aber nicht nötig zu sein.

Der Algorithmus basiert auf einer Idee, die in diesem Forum vorgeschlagen
wurde:
http://stackoverflow.com/questions/1711916/find-the-corners-of-a-polygon-represented-by-a-region-mask
(Von Nutzer Amro, am 11. November 2009)
%}
function result = checkQuad( image )
    debug = false;
    %Bild vorbereiten, Closen, Füllen, Eckendetektor
    I = imclose(image, strel('square', 3));
    I = imfill(I, 'holes');
    BW = edge(I, 'canny');
    %Aus Edgesize Smoothing-Wert festlegen
    edgesize = sum(sum(BW));
    smoothvar = 0.1;
    if edgesize <= 150
        smoothvar = 0.5; 
    elseif edgesize <= 300
        smoothvar = 0.4;
    elseif edgesize <= 450
        smoothvar = 0.3;
    elseif edgesize <= 600
        smoothvar = 0.2;
    end
    %Randpixel
    [by, bx] = find(BW==1);
    B = [by, bx];

    %Mittelpunkt.
    center = mean(B);
    if (I(round(center(1)), round(center(2))) == 0)
        %Nicht 1 -> "Mittelpunkt" außerhalb des Vierecks -> nicht konvex.
        result = false;
        if debug
            disp('checkQuad: Not a convex polygon! (ERR01)');
        end
        return;
    end
    
    %Mittelpunkt abziehen
    objB = bsxfun(@minus, B, mean(B));
    %In Polarkoordinaten umwandeln
    [theta, rho] = cart2pol(objB(:,2), objB(:,1));

    %Funktionsobjekt erzeugen.
    try
        func1 = DiscreteZyclicFunction(theta',rho');
    catch ME
        %Falls es für einen Winkel mehrere Rho-Werte gibt, dann ist das
        %Objekt auch nicht konvex. Tritt aber praktisch nie ein, denn
        %selbst wenn es nicht konvex ist, unterscheidet sich der Winkel
        %minimal.
        result = false;
        if debug
            disp('checkQuad: Not a convex polygon! (ERR02)');
        end
        return;
    end
    %Funktion equidistant abtasten
    func1e = func1.equidistant();
    %Funktion glätten
    func1s = func1e.sgSmooth(0.2);
    %Funktion ableiten und glätten
    func2 = func1s.getDerivative(1);
    func2 = func2.sgSmooth(0.1);
    %Ableitung ableiten und glätten
    func3 = func2.getDerivative(1);
    func3s = func3.sgSmooth(smoothvar);
    %Nach lokalen Minima (=Ecken) suchen. Treshold ist hier fix auf 1/3 
    %gesetzt. Dieser Wert wurde empirisch getestet und für gut befunden.
    treshold = 1/3.2;
    [cTheta, cRho] = func3s.getLowMinima(treshold);
    %Anzahl prüfen
    if (length(cTheta) ~= 4)
        result = false;
        if debug
            disp(['checkQuad: Found ', num2str(length(cTheta)), ' corners']);
        end
        return;
    end
    %Konkovaität der Kurven annährend prüfen
    %{
    for i=1:length(cTheta)
        if func3.percLargerZero(cTheta(i), cTheta(mod(i, length(cTheta))+1)) < 0.3
            result = false;
            if debug
                disp('Not a valid square!');
            end
            return;
        end
    end
    %}
    
    %Näherste Theta-Werte in der Original-Funktion finden
    rTheta = func1.getXNeighbour(cTheta);
    %Zugehörige Rho-Werte abfragen
    rRho = func1.getYLinearInterpolated(rTheta);
    %Zurück ins kartesische Koordinatensystem
    [x, y] = pol2cart(rTheta, rRho);
    x = x+center(2);
    y = y+center(1);

    %Prüfen, ob die Punkte das Objekt zu mindestens 70% einschließen
    s = size(I);
    Idbl = im2double(I);
    xq1 = 1:s(2);
    yq1 = 1:s(1);
    xq2 = reshape(repmat(xq1,length(yq1),1), [1 length(yq1)*length(xq1)]);
    yq2 = repmat(yq1, 1, length(xq1));
    inpolymat = inpolygon(xq2, yq2, x, y);
    inpolymat = reshape(inpolymat,[s(1) s(2)]);
    sizeoriginal = sum(sum(im2double(Idbl)));
    intersected = Idbl & inpolymat;
    sizeinter = sum(sum(intersected));
    if (sizeinter/sizeoriginal < 0.7)
        result = false;
        if debug
            disp('Ecken schließen Objekt nicht ein!');
        end
        return;
    end
    %Ecken zurückgeben.
    result = [x', y'];
end

