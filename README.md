# Plate Dectection
## How to run the program
Erst ab Matlab Version 2014b (OCR needed)
Um den Algorithmus für ein einzelnes Bild zu testen ruft man einfach
plateDetection(filename)
auf. Die Methode gibt das Ergebnisbild zurück, um es anzuzeigen, ist also ein weiteres imshow nötig.
Es gibt zusätzliche optionale Parameter, mit denen sich Einstellungen ändern lassen (siehe Kommentar in plateDetection.m)

## Test data
Zum Testen des Datensatzes oder mehrerer Bilder gibt es auch die Datei testPlateDetection.m. Diese Datei liest mehrere Bilder aus einem angegebenen Verzeichnis ein und speichert die Ausgabebilder. Für eine genaue Bedienung bitte den Kommentar in der Datei lesen.

Der Datensatz befindet sich im Ordner Implementierung/datensatz. Darin befindet sich ein Ordner tested, welcher die Ausgabebilder für alle Bilder des Datensatzes enthält.

# Packages Needed
* image
* signal
* ocr (not in octave)

## TODOs
* Run in Octave (implementing [OCR in OCTAVE](https://github.com/baumanta/OCR_octave))
* replace finding areas with ccl
* adding gui
* change all comments to english
* image skaling consideration height
* rename variables
* reorder some functions to one class
* remove TODOs

## Acknowledgment
This project was created for the course [Introduction to image processing](https://www.prip.tuwien.ac.at/teaching/edbv_ue.php) at the [TU Wien](https://www.prip.tuwien.at).

# Authors
* Simon Maximilian Fraiss: https://www.linkedin.com/in/simon-maximilian-fraiss/
* Patrick Hromniak: https://www.hromniak.at/
* Michael Pointner: https://michael.pointner.info
* Simon Reisinger: https://simonreisinger.com
* Mohammad Zandpour: https://soundcloud.com/n0mster
