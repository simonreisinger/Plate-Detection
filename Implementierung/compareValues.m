% Vergleich zwei verschiedene Histogramme auf ihre Ähnlichkeit.
% Dies geschieht über die euklidische Distanz.
% 
% Nur "new version" in Verwendung!
%
% Gibt entsprechend dem Matching 0 - 3 zurück
% 3 -> Alle Histogramme ähnlich
% 0 -> Keine Ähnlichkeiten
% Author: Patrick Hromniak

function output = compareValues(r_input,g_input,b_input,r_comp,g_comp,b_comp)

ri = r_input ./ sum(r_input);
rc = r_comp ./ sum(r_comp);
diffHistLBPr = ri - rc;
SSDr = sum(diffHistLBPr.^2);
%new version
valr = pdist2(r_input',r_comp');

gi = g_input ./ sum(g_input);
gc = g_comp ./ sum(g_comp);
diffHistLBPg = gi - gc;
SSDg = sum(diffHistLBPg.^2);
%new version
valg = pdist2(g_input',g_comp');

bi = b_input ./ sum(b_input);
bc = b_comp ./ sum(b_comp);
diffHistLBPb = bi - bc;
SSDb = sum(diffHistLBPb.^2);
%new version
valb = pdist2(b_input',b_comp');

checker = 0;

if(valr/1000 < 1)
    checker = checker + 1;
end

if(valg/1000 < 1)
    checker = checker + 1;
end

if(valb/1000 < 1)
    checker = checker + 1;
end

output = checker;

end