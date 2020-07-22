clc;    % Clear command window.
clear;  % Delete all variables.
close all;  % Close all figure windows except those created by imtool.
imtool close all;   % Close all figure windows created by imtool.
workspace;  % Make sure the workspace panel is showing.

% pkg load image
% pkg load signal
% pkg load ocr

%{
Hinweise an der Nutzer:
- startIndex und endIndex anpassen, um alle (1-43) oder nur ein Bild zu
  testen.
- dir gibt den relativen Unterordner an, indem die Bilder liegen
- dirOutput gibt den Unterordner von dir an, indem die Ergebnisbilder
  gespeichert werden sollen und muss vor dem Starten des Codes bereits
  angelegt sein.
- endung gibt die Dateiendung der Testbilder an.
- debugFlag ist nur zu Testzwecken gedacht. Ist es true, werden zusaetzliche
  Debug-Informationen im Ausgabebild angezeigt.
- Zur Ausgabe der Bilder am Bildschirm das imshow in der untersten Schleife
  aktivieren.
- Die Bilder dauern durchschnittlich 90 Sekunden (Testgeraet: i5 quadcore
  mit 3.5 GHz), abhaengig davon wieviele kleine Flaechen gefunden werden
  (z.B. Gras), weil die imfill Methode von Matlab dann laenger braucht.
  Selbstimplementierte Teile haben eine relativ stabile Laufzeit.

Zum Testen von eigenen Bildern einfach mit 44.jpg, ... bezeichnen und
dem Ordner dir hinzufuegen.
%}
startIndex = 1;
endIndex = 43;

dir = 'datensatz/';
dirOutput = 'tested/';
endung = '.jpg';
debugFlag = false;

for i = startIndex:endIndex
    filename = int2str(i);

    filenameDir = strcat(dir, filename);

    nowRunning = filename

    filenameWithEndung = strcat(filenameDir, endung);
    filenameWrite = strcat(dir, strcat(dirOutput, strcat(filename, endung)));

    imgOutput = plateDetection(filenameWithEndung, true, false, debugFlag);

    imwrite(imgOutput, filenameWrite);

    sizeI = size(imgOutput);
    imgOutputArray(1:sizeI(1),1:sizeI(2),1:sizeI(3),i) = imgOutput;

    filenameArray{i} = filenameWrite;
end

for i = startIndex:endIndex
    %figure('Name',filenameArray{i}), imshow(imgOutputArray(:,:,:,i));
end
