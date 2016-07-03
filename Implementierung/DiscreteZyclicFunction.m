classdef DiscreteZyclicFunction < handle
    %{
    Autor: Simon Fraiss
    Diese Klasse stellt eine diskrete, zyklische Funktion dar.
    Sie besitzt eine endliche Menge an X-Werten und zu jedem X-Wert genau 
    einen zugehörigen Y-Wert.
    Sie ist zyklisch, damit ist gemeint, dass beim Überschreiten des
    höchsten X-Wertes ganz links auf die Funktion zugegriffen wird. Der
    Einfachheit halber wird angenommen, dass der Abstand zwischen letztem
    und ersten Wert 0 ist. Dies kann zu leichten Fehlern führen, die aber
    vernachlässigbar sind.
    %}
    
    properties
        X,Y
    end
    
    methods
        %{
        Konstruktor. 
        Parameter X enthält alle X-Werte.
        Parameter Y enthält die Y-Werte zu den entsprechenden X-Werten.
        Dementsprechend sollten beide Vektoren gleich lang sein, sonst wird
        ein Fehler geworfen.
        Außerdem sollte für alle i,j aus 1:length(X) gelten, dass
        X(i) == X(j) => Y(i) == Y(j)
        Sprich für jeden X-Wert gibt es genau einen zugehörigen Y-Wert.
        Ansonsten wird ebenfalls ein Fehler geworfen.
        Doppelte X,Y-Paare werden vor dem Übernehmen verworfen.
        Außerdem wird nach X-Werten sortiert.
        %}
        function obj = DiscreteZyclicFunction(X,Y)
            if (size(X) ~= size(Y))
                error('Sizes of X and Y must match!');
            end
            %Sort by X
            [~, order] = sort(X);
            X = X(order);
            Y = Y(order);
            doubles = X(1:length(X)-1) >= X(2:length(X));
            if sum(doubles) ~= 0
                f = find(doubles);
                for i=1:length(f)
                    if Y(f(i)) ~= Y(mod(f(i), length(Y))+1)
                        error(['Not a valid function! Different values for ', num2str(X(f(i))), '!']);
                    end
                end
                %Y is the same as well -> remove doubles
                X = X(~doubles);
                Y = Y(~doubles);
            end
            obj.X = X;
            obj.Y = Y;
        end
        
        %{
        Tastet die (an Zwischenwerten linear interpolierte) Funktion 
        äquidistant ab und liefert die neue Funktion als Ergebnis zurück.
        Die ursprüngliche Funktion bleibt unverändert.
        Die Menge an Abtastpunkten entspricht standardmäßig der doppelten 
        Anzahl an Punkten der Originalfunktion.
        %}
        function func = equidistant(obj)
            len = 2*length(obj.X)-1;
            minX = obj.X(1);
            dist = (obj.X(length(obj.X))-minX)/len;
            newX = zeros(1,len);
            newY = zeros(1,len);
            for i = 0:(len-1)
                xx = minX+i*dist;
                newX(i+1) = xx;
                newY(i+1) = obj.getYLinearInterpolated(xx);
            end
            func = DiscreteZyclicFunction(newX, newY);
        end
        
        %{
        Diese Funktion glättet die Funktion mithilfe dies
        Savitzy-Golay-Filters. Der Vorteil dieses Filters im Gegensatz zu
        einem normalen Glättungsfilter ist, dass sich die Minima nicht so
        stark verschieben.
        Voraussetzung ist, dass die Funktion äquidistant abgetastet ist.
        Ist dies nicht der Fall, kann der Filter möglicherweise zu falschen
        Resultaten führen.
        Zyklizität wird hier beachtet.
        span: Glättungsfilter-Fenstergröße (in der Einheit der X-Achse).
        %}
        function func = sgSmooth(obj, span)
            dist = obj.X(2)-obj.X(1);
            size = round(span/dist);
            if (mod(size,2) == 0)
                size = size+1;
            end
            if size <= 3
                size = 5;
            end
            filterY = [(obj.Y((length(obj.Y)-size+1) : (length(obj.Y)))) obj.Y obj.Y(1:size)];
            newYPlus = sgolayfilt(filterY,3,size);
            newY = newYPlus((size+1) : (length(newYPlus)-size+1));
            func = DiscreteZyclicFunction(obj.X, newY);
        end
        
        %{
        Liefert alle Y-Werte für die übergebenen X-Werte (in entsprechender Reihenfolge).
        Vorbedingung für korrekte Funktionalität ist, dass x tatsächlich in
        X vorkommt. Ansonsten wird 0 als entsprechender Wert zurückgegeben.
        Zyklizität wird nicht beachtet. Die X-Koordinaten sollten also im
        Originalintervall liegen.
        %}
        %{
        function y = getY(obj,x)
            if (length(x) == 1)
                y = sum(obj.Y(obj.X==x));
            else
                y = [];
                for i=1:length(x)
                    y = [y sum(obj.Y(obj.X==x(i)))];
                end
            end
        end
        %}
        
        %{
        Erhält eine beliebige X-Koordinate und gibt einen benachbarten
        abgetasteten X-Wert zurück, falls diese X-Koordinate selbst nicht
        abgetastet wurde. Es wird prinzipiell der X-Nachbar mit der höheren
        zugehörigen Y-Koordinate zurückgegeben.
        In dieser Funktion wird die Zyklizität nicht beachtet. x sollte
        also im Originalintervall liegen.
        %}
        function resx = getXNeighbour(obj,x)
            if isempty(x)
                resx = [];
                return;
            end
            if length(x) > 1
                resx = zeros(1,length(x));
                for i=1:length(x)
                    resx(i) = obj.getXNeighbour(x(i));
                end
                return;
            end
            if x < obj.X(1)
                resx = obj.X(1);
                return;
            elseif x > obj.X(length(obj.X))
                resx = obj.X(length(obj.X));
                return;
            end
            X = obj.X;
            l = 1;
            r = length(X);
            while (l <= r)
                m = floor((l+r)/2);
                if X(m) == x
                   resx = X(m);
                   return;
                elseif x < X(m)
                   r = m-1;
                else
                   l = m+1; 
                end
            end
            if abs(X(l)-x) > abs(X(r)-x)
                l = r;
            end
            if l > length(X)
                resx = X(length(X));
                return;
            end
            i1 = l;
            if x > X(l)
                i2 = l+1;
            else
                i2 = l-1;
            end
            if obj.Y(i1) > obj.Y(i2)
                resx = X(i1);
            else
                resx = X(i2);
            end
        end
        
        %x must be in range and > the first x and smaller the last x
        %{
        Liefert alle Y-Werte für die übergebenen X-Werte (in entsprechender Reihenfolge).
        Bei X-Werten, die nicht in abgetastet wurden, wird zwischen den
        abgetasteten Werten linear interpoliert.
        Zyklizität wird nicht beachtet. Die X-Koordinaten sollten also im
        Originalintervall liegen.
        %}
        function y = getYLinearInterpolated(obj,x)
            if isempty(x)
                y = [];
                return;
            end
            if length(x) > 1
                y = zeros(1,length(x));
                for i=1:length(x)
                    y(i) = obj.getYLinearInterpolated(x(i));
                end
                return;
            end
            X = obj.X;
            l = 1;
            r = length(X);
            while (l <= r)
                m = floor((l+r)/2);
                if X(m) == x
                   y = obj.Y(m);
                   return;
                elseif x < X(m)
                   r = m-1;
                else
                   l = m+1; 
                end
            end
            if l < 1 || l > length(X)
                y = false;
                return;
            end
            if x < X(l)
                if (l == 1)
                    y = false;
                    return;
                end
                l = l-1;
            end
            fulldist = obj.X(l+1)-obj.X(l);
            xdist = x-obj.X(l);
            lin = xdist/fulldist;
            y = obj.Y(l+1)*lin + obj.Y(l)*(1-lin);
        end
        
        %Bildet die Ableitung so, dass für jedes x der Wert von y' =
        %y(x+1)-y(x-1) ist.
        %{
        Bildet die n. diskrete Ableitung.
        Die Ableitung an der i. Stelle (also an der X-Koordinate X(i))
        wird berechnet durch
        Y'(i) = ((Y(i+1)-Y(i-1))/(X(i+1)-X(i-1)).
        Zyklizität wird beachtet.
        Parameter nr: Die Anzahl, wie oft abgeleitet werden soll. Ganze
        Zahl. Voraussetzung: Äquidistant
        %}
        function func = getDerivative(obj, nr)
            abl = obj.Y;
            for i=1:nr
                i1 = mod(((1:length(abl))),length(abl))+1;
                i2 = mod(((1:length(abl))-2),length(abl))+1;
                abl = (abl(i1) - abl(i2)) ./ (obj.X(3) - obj.X(1));
            end
            func = DiscreteZyclicFunction(obj.X, abl);
        end
        
        %{
        Berechnet den Mittelwert der Funktion.
        Dabei werden alle Elemente ab dem 2. addiert und mit ihrem Abstand
        zum vorhergehenden Element multipliziert.
        %}
        function mean = getMean(obj)
            mean = 0;
            for i=2:length(obj.X)
                mean = mean + obj.Y(i)*(obj.X(i)-obj.X(i-1));
            end
            mean = mean/(obj.X(length(obj.X)) - obj.X(1));
        end
        
        %Sucht nach lokalen Minima die unter dem Mittelwert - Treshold
        %liegen.
        %Von jeder Teilkurve, die unter Mittelwert-Treshold liegt wird das
        %mehr oder weniger globale Minimum genommen.
        %{
        Sucht nach Minima.
        Am Mittelwert wird eine horizontale Linie über die Funktion gelegt.
        Diese Linie wird um (GlobalesMinimum - Mittelwert)*<treshold> nach
        unten verschoben. Alles oberhalb der Linie wird ignoriert. Die
        Teilfunktionen, die durch Abschneiden an der Linie unterhalb
        entstehen, werden nach globalen Maxima durchsucht. Diese werden
        zurückgegeben.
        Gute Werte für Treshold sind zB 1/2 (wenige Minima) bis 1/5.
        Default-Wert für Treshold ist 0.
        %}
        function [X,Y] = getLowMinima(obj, treshold)
            if ~exist('treshold')
                treshold = 0;
            end
            mean = 0;
            treshold = (mean-min(obj.Y))*treshold;
            %Mindest-Treshold 100.
            if (treshold < 200) 
                treshold = 200;
            end
            cutline = min([mean-treshold 0]);
            cut = obj.Y < cutline;
            zeros = find(cut==0);
            if (isempty(zeros))
                minY = min(obj.Y);
                minX = obj.X(obj.Y == minY);
                X = [minX(1)];
                Y = [minY];
                return;
            end
            firstzero = zeros(1);
            X = [];
            Y = [];
            counter = 0;
            minX = -1;
            minY = 0;
            for off=1:length(cut)
                i = mod(firstzero+off-1, length(cut))+1;
                if (cut(i) == 0)
                    if (minX ~= -1)
                        counter = counter+1;
                        X(counter) = minX;
                        Y(counter) = minY;
                        minX = -1;
                    end
                else
                    if minX == -1
                        minX = obj.X(i);
                        minY = obj.Y(i);
                    else
                        if obj.Y(i) < minY
                            minY = obj.Y(i);
                            minX = obj.X(i);
                        end
                    end
                end
            end
        end
        
        %{
        Berechnet wieviel Prozent der Werte zwischen x1 und x2 größer 0
        sind. Ergebnis ist nur ungefähr und nicht genau, da nicht einfach 
        Werte gezählt werden, sondern da quasi eine Stufenfunktion gebildet
        wird und die Breite der Stufen berücksichtigt wird. Ist x1 größer 
        x2, werden alle Werte berücksichtigt, die kleiner x2 sind oder 
        größer x1 sind.
        %}
        %{
        function perc = percLargerZero(obj,x1,x2)
            if (x2 >= x1)
                xsum = 0;
                for i=2:length(obj.X)
                    if (obj.X(i) >= x1 && obj.X(i) <= x2 && obj.Y(i) > 0)
                        xsum = xsum + (obj.X(i)-obj.X(i-1));
                    end
                    if (obj.X(i) > x2)
                        break;
                    end
                end
                perc = xsum/(x2-x1);
            else
                xsum = 0;
                for i=2:length(obj.X)
                    if (obj.X(i) <= x2 || obj.X(i) >= x1) && obj.Y(i) > 0
                        xsum = xsum + (obj.X(i)-obj.X(i-1));
                    end
                end
                perc = xsum/((x2-obj.X(1)) + (obj.X(length(obj.X))-x1));
            end
        end
        %}
       
        %{
        Zeichnet die Funktion. Der Mittelwert wird als zusätzliche Linie
        eingezeichnet.
        treshold: Entspricht Treshold aus "getLowMinima"-Funktion. Falls !=
        0, wird er als zusätzliche Linie eingezeichnet. Default: 0
        xname: Beschriftung der X-Achse. Default: X
        yname: Beschriftung der Y-Achse. Default: Y
        Man kann nach Aufruf dieser Funktion mittels Matlab-plot weitere 
        Dinge in den Graphen zeichnen.
        %}
        function plot(obj,treshold,xname,yname)
            if ~exist('treshold')
                treshold = 0;
            end
            if ~exist('xname')
                xname = 'X';
            end
            if ~exist('yname')
                yname = 'Y';
            end
            figure, plot(obj.X, obj.Y), hold on;
            title(''), xlabel(xname), ylabel(yname), ylim([min(obj.Y) max(obj.Y)]);
            mean = obj.getMean();
            treshold = (mean-min(obj.Y))*treshold;
            if (treshold < 200) 
                treshold = 200;
            end
            minX = min(obj.X);
            maxX = max(obj.X);
            plot([minX, maxX], [mean mean]);
            if (treshold ~= 0)
                cutline = min([mean-treshold 0]);
                plot([minX, maxX], [cutline cutline]);
            end
        end
    
    end
    
end

