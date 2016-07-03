% Calculates the perspective transformation matrix for the given 4 Points
% author: Michael Pointner
function transMatrix = calcGeometricTransformationMatrix(x1, y1, x2, y2, x3, y3, x4, y4)

% Transformationsmatrix laut Buch
% Digitale Bildverarbeitung
% von Wilhelm Burger und Mark James Burge
% Seite 371

a31 = ((x1-x2+x3-x4)*(y4-y3)-(y1-y2+y3-y4)*(x4-x3))/((x2-x3)*(y4-y3)-(x4-x3)*(y2-y3));
a32 = ((y1-y2+y3-y4)*(x2-x3)-(x1-x2+x3-x4)*(y2-y3))/((x2-x3)*(y4-y3)-(x4-x3)*(y2-y3));
a33 = 1;

a11 = x2-x1+a31*x2;
a12 = x4-x1+a32*x4;
a13 = x1;

a21 = y2-y1+a31*y2;
a22 = y4-y1+a32*y4;
a23 = y1;

transMatrix = [a11, a12, a13; a21, a22, a23; a31, a32, a33];

end