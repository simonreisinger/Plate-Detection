% Interpolations-Funktion
% Autor: Simon Fraiss
% Diese Funktion implementiert die bilineare Interpolation für die
% geometrische Transformation.
% Für gegebene "Zwischenkoordinaten" (Kommazahlen) wird der interpolierte Wert anhand der
% nähersten Punkte berechnet. Bei Nicht-Kommazahlen wird der Originalwert
% aus dem Eingangsbild zurückgegeben.
% Parameter:
%    img: Nichttransformiertes Originalbild im Double-Format.
%     px: X-Koordinate, für die der Wert berechnet werden soll. Muss >= 1
%         sein und <= der Breite des Bildes. Darf eine Kommazahl sein.
%     py: Y-Koordinate, für die der Wert berechnet werden soll. Muss >= 1
%         sein und <= der Höhe des Bildes. Darf eine Kommazahl sein.
% Die resultierende Farbe wird als Dreier-Double-Vektor [r g b]
% zurückgegeben.
%
function color = interpolation( img, px, py )
    s = size(img);
    
    %Gewichtungen berechnen.
    weightRight = px-floor(px);
    weightLeft = 1-weightRight;
    weightBottom = py-floor(py);
    weightTop = 1-weightBottom;
    
    %Zwischen LT und RT (falls vorhanden) interpolieren
    topcolor = weightLeft*img(floor(py),floor(px),:);
    if (px < s(2))
        topcolor = topcolor + weightRight*img(floor(py),mceil(px),:);
    end
    topcolor = [ topcolor(1,1,1) topcolor(1,1,2) topcolor(1,1,3)];
    %Zwischen LB und RB (falls vorhanden) interpolieren
    bottomcolor = [ 0 0 0 ];
    if (py < s(1))
        bottomcolor = weightLeft*img(mceil(py),floor(px),:);
        if (px < s(2))
            bottomcolor = bottomcolor + weightRight*img(mceil(py),mceil(px),:);
        end
        bottomcolor = [ bottomcolor(1,1,1) bottomcolor(1,1,2) bottomcolor(1,1,3)];
    end
    %zwischen TOP und BOTTOM interpolieren
    color = (weightTop*topcolor + weightBottom*bottomcolor);
    
end

%Kleine Hilfsfunktion. Rundet auf die nächste ganze Zahl, selbst wenn die 
%Zahl keine Kommazahl ist.
function res = mceil(val)
    res = floor(val)+1;
end