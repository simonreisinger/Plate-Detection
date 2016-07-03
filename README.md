# Plate Dectection
## How to run the program
Erst ab Matlab Version 2014b (OCR)
Um den Algorithmus für ein einzelnes Bild zu testen ruft man einfach
plateDetection(filename)
auf. Die Methode gibt das Ergebnisbild zurück, um es anzuzeigen, ist also ein weiteres imshow nötig.
Es gibt zusätzliche optionale Parameter, mit denen sich Einstellungen ändern lassen (siehe Kommentar in plateDetection.m)

## Test data
Zum Testen des Datensatzes oder mehrerer Bilder gibt es auch die Datei testPlateDetection.m. Diese Datei liest mehrere Bilder aus einem angegebenen Verzeichnis ein und speichert die Ausgabebilder. Für eine genaue Bedienung bitte den KOmmentar in der Datei lesen.

Der Datensatz befindet sich im Ordner Implementierung/datensatz. Darin befindet sich ein Ordner tested, welcher die Ausgabebilder für alle Bilder des Datensatzes enthält.

## TODOs
* replace finding areas with ccl
* adding gui
* change all comments to english
* image skaling consideration height
* rename variables
* reorder some functions to one class
* remove TODOs

# Authors
Simon Maximilian Fraiss: e1425602@student.tuwien.ac.at
Patrick Hromniak: e1425731@student.tuwien.ac.at
Michael Pointner: e1427791@student.tuwien.ac.at
Simon Reisinger: e1426220@student.tuwien.ac.at
Mohammad Zandpour: e1425603@student.tuwien.ac.at