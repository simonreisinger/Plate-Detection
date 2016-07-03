% Histogramm Überprüfung für Kennzeichen
% Author: Patrick Hromniak
% Version: 1.0
%
% Todo: Benützung von fertig berechneten Daten
%
% Diese Methode erhält ein Farbbild und ein Binärbild mit dem zu
% überprüfenden Rechteck. Anhand von Kennzeichen wird überprüft
% ob dieses Rechteck anhand des Histograms ein Kennzeichen ist
% Natürlich kann eine reine Histogrammüberprüfung keine Garantie sein.
% Die Methode liefert einen prozentuellen Wert der erfolgreichen Testfälle
% Rechtecke die keine Kennzeichen waren wurden im Test mit 0% abgelehnt.
% Rechtecke die defintiv Kennzeichen waren erreichten im Schnitt 30-50%.
% Der niedrige Prozentsatz beruht auf die idealen Kennzeichen die auch
% Testsatz enthalten sind. Diese werden natürlich von schlechten Crops
% nicht erreicht. Weist ein Rechteck einen Prozentsatz von über 30% auf
% kann von einem Kennzeichen ausgegangen werden.
% Kennzeichen die fast eher nur Schwarz/Weiß sind werden oft abgelehnt
% diese wirken als wären sie aus plastik und haben auch einen extremen
% Kontrast.


function val = makeHistograms(original,binary)

%kennzeichen croppen
img = subtract(original,binary);
%kontrast anheben
%contrastImage = imadjust(img, [0 0.8], [0 1]);
imwrite(img, 'crop.jpg', 'jpg')

%ideale kennzeichen errechnen
%diese kennzeichen sind perfekt, werden aber eher im seltensten fall
%auftreten

% rot werte

data=load('values/r_ideal1.mat');
variables=fields(data);
r_ideal1=data.(variables{1});

data=load('values/r_ideal2.mat');
variables=fields(data);
r_ideal2=data.(variables{1});

data=load('values/r_ideal3.mat');
variables=fields(data);
r_ideal3=data.(variables{1});

data=load('values/r_ideal5.mat');
variables=fields(data);
r_ideal5=data.(variables{1});

data=load('values/r_ideal6.mat');
variables=fields(data);
r_ideal6=data.(variables{1});

data=load('values/r_ideal7.mat');
variables=fields(data);
r_ideal7=data.(variables{1});

data=load('values/r_ideal8.mat');
variables=fields(data);
r_ideal8=data.(variables{1});

data=load('values/r_ideal9.mat');
variables=fields(data);
r_ideal9=data.(variables{1});

data=load('values/r_ideal10.mat');
variables=fields(data);
r_ideal10=data.(variables{1});

data=load('values/r_ideal11.mat');
variables=fields(data);
r_ideal11=data.(variables{1});


data=load('values/r_ideal12.mat');
variables=fields(data);
r_ideal12=data.(variables{1});


data=load('values/r_ideal13.mat');
variables=fields(data);
r_ideal13=data.(variables{1});


data=load('values/r_ideal14.mat');
variables=fields(data);
r_ideal14=data.(variables{1});

% grün werte

data=load('values/g_ideal1.mat');
variables=fields(data);
g_ideal1=data.(variables{1});

data=load('values/g_ideal2.mat');
variables=fields(data);
g_ideal2=data.(variables{1});

data=load('values/g_ideal3.mat');
variables=fields(data);
g_ideal3=data.(variables{1});

data=load('values/g_ideal5.mat');
variables=fields(data);
g_ideal5=data.(variables{1});

data=load('values/g_ideal6.mat');
variables=fields(data);
g_ideal6=data.(variables{1});

data=load('values/g_ideal7.mat');
variables=fields(data);
g_ideal7=data.(variables{1});

data=load('values/g_ideal8.mat');
variables=fields(data);
g_ideal8=data.(variables{1});

data=load('values/g_ideal9.mat');
variables=fields(data);
g_ideal9=data.(variables{1});

data=load('values/g_ideal10.mat');
variables=fields(data);
g_ideal10=data.(variables{1});

data=load('values/g_ideal11.mat');
variables=fields(data);
g_ideal11=data.(variables{1});

data=load('values/g_ideal12.mat');
variables=fields(data);
g_ideal12=data.(variables{1});

data=load('values/g_ideal13.mat');
variables=fields(data);
g_ideal13=data.(variables{1});

data=load('values/g_ideal14.mat');
variables=fields(data);
g_ideal14=data.(variables{1});

%blau werte

data=load('values/b_ideal1.mat');
variables=fields(data);
b_ideal1=data.(variables{1});

data=load('values/b_ideal2.mat');
variables=fields(data);
b_ideal2=data.(variables{1});

data=load('values/b_ideal3.mat');
variables=fields(data);
b_ideal3=data.(variables{1});

data=load('values/b_ideal5.mat');
variables=fields(data);
b_ideal5=data.(variables{1});

data=load('values/b_ideal6.mat');
variables=fields(data);
b_ideal6=data.(variables{1});

data=load('values/b_ideal7.mat');
variables=fields(data);
b_ideal7=data.(variables{1});

data=load('values/b_ideal8.mat');
variables=fields(data);
b_ideal8=data.(variables{1});

data=load('values/b_ideal9.mat');
variables=fields(data);
b_ideal9=data.(variables{1});

data=load('values/b_ideal10.mat');
variables=fields(data);
b_ideal10=data.(variables{1});

data=load('values/b_ideal11.mat');
variables=fields(data);
b_ideal11=data.(variables{1});

data=load('values/b_ideal12.mat');
variables=fields(data);
b_ideal12=data.(variables{1});

data=load('values/b_ideal13.mat');
variables=fields(data);
b_ideal13=data.(variables{1});

data=load('values/b_ideal14.mat');
variables=fields(data);
b_ideal14=data.(variables{1});

%[r_ideal1,g_ideal1,b_ideal1] = histogrammer('ideales_kennzeichen1.jpg');
%[r_ideal2,g_ideal2,b_ideal2] = histogrammer('ideales_kennzeichen2.jpg');
%[r_ideal3,g_ideal3,b_ideal3] = histogrammer('ideales_kennzeichen3.jpg');

%normale ausschnitte
%kennzeichen die eher dem regelfall entsprechen
%[r_ideal4,g_ideal4,b_ideal4] = histogrammer('normal1.jpg');
%[r_ideal5,g_ideal5,b_ideal5] = histogrammer('small_badlightning.jpg');
%[r_ideal6,g_ideal6,b_ideal6] = histogrammer('dunkel.jpg');
%[r_ideal7,g_ideal7,b_ideal7] = histogrammer('dunkel_small.jpg');
%[r_ideal8,g_ideal8,b_ideal8] = histogrammer('dunkel_tiny.jpg');
%[r_ideal9,g_ideal9,b_ideal9] = histogrammer('verydark.jpg');
%[r_ideal10,g_ideal10,b_ideal10] = histogrammer('verydark_small.jpg');
%[r_ideal11,g_ideal11,b_ideal11] = histogrammer('verydark_tiny.jpg');


%das ist unser kennzeichen dass wir mit dem idealen kennzeichen vergleichen
%möchten
[r_input,g_input,b_input] = histogrammer('crop.jpg');
close all;

%vergleichen mit den kennzeichen
RES1 = compareValues(r_input,g_input,b_input,r_ideal5,g_ideal5,b_ideal5);
RES2 = compareValues(r_input,g_input,b_input,r_ideal6,g_ideal6,b_ideal6);
RES3 = compareValues(r_input,g_input,b_input,r_ideal7,g_ideal7,b_ideal7);
RES4 = compareValues(r_input,g_input,b_input,r_ideal8,g_ideal8,b_ideal8);
RES5 = compareValues(r_input,g_input,b_input,r_ideal9,g_ideal9,b_ideal9);
RES6 = compareValues(r_input,g_input,b_input,r_ideal10,g_ideal10,b_ideal10);
RES8 = compareValues(r_input,g_input,b_input,r_ideal1,g_ideal1,b_ideal1);
RES9 = compareValues(r_input,g_input,b_input,r_ideal2,g_ideal2,b_ideal2);
RES10 = compareValues(r_input,g_input,b_input,r_ideal3,g_ideal3,b_ideal3);
% neue testsätze
RES11 = compareValues(r_input,g_input,b_input,r_ideal11,g_ideal11,b_ideal11);
RES12 = compareValues(r_input,g_input,b_input,r_ideal12,g_ideal12,b_ideal12);
RES13 = compareValues(r_input,g_input,b_input,r_ideal13,g_ideal13,b_ideal13);
RES14 = compareValues(r_input,g_input,b_input,r_ideal14,g_ideal14,b_ideal14);

RES = [RES1,RES2,RES3,RES4,RES5,RES6,RES8,RES9,RES10,RES11,RES12,RES13,RES14];

val = (sum(RES)/(numel(RES)*3))*100;

end
