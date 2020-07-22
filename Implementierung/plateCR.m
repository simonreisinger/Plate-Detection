%AUTHOR: Mohammad Zanpdour
%
%Faehrt die Buchstabenpruefung durch.
%bekommt RGB bild mit rotiertem Kennzeichen, liefert TRUE wenn es ein nummernschild sein kann, false
%wenn es kein nummernschild sein kann.
function result = plateCR( imageTransformed )
    %graustufenbild
    I = rgb2gray(imageTransformed);
    %OCR aus vorhandenen funktionen
    %%%%%%%%%%% OCR in MATLAB only %%%%%%%%%%%%%%%%%%%%
    results = ocr(I, 'CharacterSet', ...
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'TextLayout','Block');
    %%%%%%%%%%% OCR in MATLAB only %%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% OCR OCTAVE %%%%%%%%%%%%%%%%%%%%
    % TODO edit here
    %%%%%%%%%%% OCR OCTAVE %%%%%%%%%%%%%%%%%%%%


    %sortiere nach confidence level gefundener symbole absteigend fuer
    %schleifeneffizienz
    [sortedConf, ~] = sort(results.CharacterConfidences, 'descend');
    notNan = ~isnan(sortedConf);
    %bereinigung um NaNs aus dem ergebnis zu nehmen, warum auch immer die
    %auftauchen
    sortedConf = sortedConf(notNan);
    %diesen kommentar drunter einfach ignorieren, brauchen wir vllt noch
    %indexesNaNsRemoved = sortedIndex(notNan);
    [a, ~] = size(sortedConf);
    %zaehler um festzuhalten wieviele charactere in einem bestimmten
    %confidence threshold gefunden werden
    countValidSymbol = 0;
    %durchlaufe alle confidence levels (pro erkanntem symbol)
    for l = 1 : a
        %ab 75 prozent confidence level behaupte ich: das gefundene symbol
        %ist wirklich ein buchstabe/eine zahl
        if (sortedConf(l) > 0.75)
            countValidSymbol = countValidSymbol + 1;
        end
        %wenn wir min. 4 symbole mit dem conf.level am schild finden breche
        %ab denn: potenzielles nummernschild gefunden!
        if(countValidSymbol > 3)
            result = true;
            return;
        end
    end
    result = false;
    %{

    %dashier einfach ignorieren, brauchen wir vllt noch

    topTenIndexes = indexesNaNsRemoved; %indexesNaNsRemoved(1:10);
    digits = num2cell(results.Text(topTenIndexes));
    bboxes = results.CharacterBoundingBoxes(topTenIndexes, :);
    regularExpr = '\d';
    Idigits = insertObjectAnnotation(I, 'rectangle', bboxes, digits);
    %}
end
